import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/state_model.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
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
  var prefs;
  TextEditingController _searchController = TextEditingController();
  List<ApiResponse> _allStates = [];
  List<ApiResponse> _filteredStates = [];
  String? maxSelections = "0";

  @override
  void initState() {
    _dataFuture = _fetchStates();
    loadProfile();
    super.initState();
  }

  Future<List<ApiResponse>> _fetchStates() async {
    prefs = await SharedPreferences.getInstance();
    maxSelections = prefs.getString(AppStrings.prefFavStateMaxCount);
    final stateRes = await AuthServices().getStates(context);
    if (stateRes.errorCount == 0 && stateRes.apiResponse != null) {
      setState(() {
        _allStates = stateRes.apiResponse!;
        _filteredStates = _allStates;
      });
      return stateRes.apiResponse!;
    } else {
      return [];
    }
  }

  void _filterStates(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStates = _allStates;
      } else {
        _filteredStates = _allStates
            .where((state) =>
                state.stateName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> loadProfile() async {
    prefs = await SharedPreferences.getInstance();
    var getProfileRes = await AuthServices()
        .getProfile(context, prefs.getString(AppStrings.prefUserID));
    if (getProfileRes?.errorCount == 0) {
      setState(() {
        for (var favState
            in getProfileRes?.apiResponse?[0].userFavouriteStateInfo ?? []) {
          String stateId = favState.stateInfo![0].stateId!;
          _selectedStateID.add(stateId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          prefs != null && prefs.getBool(AppStrings.prefIsFavStateSelected),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'State Selection',
            style: TextStyle(color: Colors.black54, fontSize: 16.0),
          ),
          leading: Visibility(
            visible: prefs != null &&
                prefs.getBool(AppStrings.prefIsFavStateSelected),
            child: IconButton(
              onPressed: () {
                NavigationHelper.pop();
              },
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
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
                    Text(
                      "Maximum $maxSelections Favourite States",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search states...",
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                  onChanged: _filterStates,
                ),
                const SizedBox(height: 10),
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
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filteredStates.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.only(left: 10),
                              activeColor: AppColors.primaryColor,
                              title: Text(_filteredStates[index].stateName!),
                              value: _selectedStateID
                                  .contains(_filteredStates[index].stateId!),
                              onChanged: (bool? isChecked) {
                                setState(() {
                                  String stateId =
                                      _filteredStates[index].stateId!;

                                  if (isChecked == true) {
                                    if (_selectedStateID.length <
                                        int.parse(maxSelections!)) {
                                      _selectedStateID.add(stateId);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Favourite States"),
                                          content: Text(
                                              'Only $maxSelections selections allowed'),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: RoundedLoadingButton(
                    width: double.maxFinite,
                    controller: _btnController,
                    onPressed: _selectedStateID.isNotEmpty
                        ? () async {
                            var updateFavStateRes = await AuthServices()
                                .updateFavState(
                                    context, _selectedStateID.join(","));
                            if (updateFavStateRes.errorCount == 0) {
                              _btnController.reset();
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.bottomSlide,
                                dialogType: DialogType.success,
                                dialogBackgroundColor: Colors.white,
                                title: updateFavStateRes
                                    .apiResponse![0].responseDetails,
                                titleTextStyle: AppTheme.appBarText,
                                descTextStyle: AppTheme.appBarText,
                                btnOkOnPress: () {
                                  NavigationHelper.pop(context);
                                  prefs.setBool(
                                      AppStrings.prefIsFavStateSelected, true);
                                },
                                btnOkText: 'OK',
                                btnOkColor: Colors.greenAccent.shade700,
                              ).show();
                            }
                          }
                        : null,
                    color: AppColors.primaryColor,
                    child: const Text(
                      AppStrings.submit,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
