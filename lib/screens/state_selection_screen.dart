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
  late Future<List<ApiResponse>> _dataFuture;
  List<String> _selectedStateID = [];
  List<String> _previousSelectedStateID = [];
  var prefs;

  @override
  void initState() {
    _dataFuture = _fetchStates();
    loadProfile();
    super.initState();
  }

  Future<List<ApiResponse>> _fetchStates() async {
    prefs = await SharedPreferences.getInstance();
    final stateRes = await AuthServices().getStates(context);

    if (stateRes.errorCount == 0 && stateRes.apiResponse != null) {
      return stateRes.apiResponse!;
    } else {
      return [];
    }
  }

  Future<void> loadProfile() async {
    var getProfileRes = await AuthServices().getProfile(context);
    if (getProfileRes.errorCount == 0) {
      setState(() {
        for (var favState
            in getProfileRes.apiResponse![0].userFavouriteStateInfo!) {
          String stateId = favState.stateId!;
          _previousSelectedStateID.add(stateId);
          _selectedStateID.add(stateId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: const MyAppBar(
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
                const SizedBox(width: 10),
                const Text(
                  "Maximum 5 Favourite States",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<ApiResponse>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      ),
                    );
                  } else if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Data Found!!',
                        style: AppTheme.rejectedTitle,
                      ),
                    );
                  } else {
                    List<ApiResponse> data2 = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data2.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          activeColor: AppColors.primaryColor,
                          title: Text(data2[index].stateName!),
                          value:
                              _selectedStateID.contains(data2[index].stateId!),
                          onChanged: (bool? isChecked) {
                            setState(() {
                              int maxSelections = int.tryParse(prefs.getString(
                                          AppStrings.prefFavStateMaxCount) ??
                                      '5') ??
                                  5;
                              String stateId = data2[index].stateId!;

                              if (isChecked == true) {
                                if (_selectedStateID.length < maxSelections) {
                                  _selectedStateID.add(stateId);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Favourite States"),
                                      content: const Text(
                                          'Only 5 selections allowed'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                _selectedStateID.remove(stateId);
                              }
                            });
                          },
                        );
                      },
                    );
                  }
                },
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
                            NavigationHelper.pushReplacementNamedUntil(
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
              child: const Text(
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
