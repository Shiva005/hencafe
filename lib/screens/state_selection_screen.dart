import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/state_model.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class StateSelectionPage extends StatefulWidget {
  const StateSelectionPage({super.key});

  @override
  State<StateSelectionPage> createState() => _StateSelectionPageState();
}

class _StateSelectionPageState extends State<StateSelectionPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<ApiResponse> _states = [];
  List<String> _selectedStateID = [];
  var prefs;

  @override
  void initState() {
    _fetchStates();
    super.initState();
  }

  Future<StateModel> _fetchStates() async {
    prefs = await SharedPreferences.getInstance();
    final stateRes = await AuthServices().getStates(context);
    if (stateRes.errorCount == 0 && stateRes.apiResponse != null) {
      setState(() {
        _states = stateRes.apiResponse!;
      });
    }
    return stateRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(
            title: 'Select Favourite States',
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  "Maximum 5 Favourite States",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: _states.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ))
                  : ListView.separated(
                      itemCount: _states.length,
                      itemBuilder: (context, index) {
                        final state = _states[index].stateId;
                        return CheckboxListTile(
                          activeColor: AppColors.primaryColor,
                          title: Text(_states[index].stateName!),
                          value: _selectedStateID.contains(state),
                          onChanged: (bool? isChecked) {
                            setState(() {
                              if (isChecked == true) {
                                if (_selectedStateID.length <
                                    int.parse(prefs.getString(
                                        AppStrings.prefFavStateMaxCount))) {
                                  _selectedStateID.add(state!);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("Favourite States"),
                                      content: Text(
                                        'Only 5 selection allowed',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                _selectedStateID.remove(state);
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height:
                              1, // Reduce height to make the divider more compact
                        ),
                      ),
                    ),
            ),
            RoundedLoadingButton(
              width: double.maxFinite,
              controller: _btnController,
              onPressed: _selectedStateID.isNotEmpty
                  ? () async {
                      var updateFavStateRes = await AuthServices()
                          .updateFavState(context, _selectedStateID.join(","));
                      if (updateFavStateRes.errorCount == 0) {
                        _btnController.reset();
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.success,
                          dialogBackgroundColor: Colors.white,
                          title:
                              updateFavStateRes.apiResponse![0].responseDetails,
                          titleTextStyle: AppTheme.appBarText,
                          descTextStyle: AppTheme.appBarText,
                          btnOkOnPress: () {
                            NavigationHelper.pushReplacementNamed(
                              AppRoutes.dashboardScreen,
                            );
                          },
                          btnOkText: 'OK',
                          btnOkColor: Colors.greenAccent.shade700,
                        ).show();
                      }
                    }
                  : null,
              color: AppColors.primaryColor,
              child: Text(
                AppStrings.finish,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
