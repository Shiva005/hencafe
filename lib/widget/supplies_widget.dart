import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/supply_Info.dart';
import 'package:hencafe/services/services.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/supply_model.dart';
import '../values/app_strings.dart';

class SuppliesWidget extends StatefulWidget {
  final List<SupplyInfo> supplyList;
  final String pageType;
  final String userCompanyUUID;
  final String createdByUserID;

  const SuppliesWidget({
    super.key,
    required this.supplyList,
    required this.pageType,
    required this.userCompanyUUID,
    required this.createdByUserID,
  });

  @override
  State<SuppliesWidget> createState() => _SuppliesWidgetState();
}

class _SuppliesWidgetState extends State<SuppliesWidget> {
  List<ApiResponse> _allSupplies = [];
  List<ApiResponse> _filteredSupplies = [];
  List<String> _selectedSupplyIDs = [];
  List<String> _userSupplies = [];
  bool _loading = true;
  var prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    prefs = await SharedPreferences.getInstance();
    final getSuppliesRes = await AuthServices().getSupplies(context);

    if (getSuppliesRes.errorCount == 0 && mounted) {
      setState(() {
        _allSupplies = getSuppliesRes.apiResponse!;
        _filteredSupplies = _allSupplies;

        _userSupplies = widget.supplyList
            .map<String>((SupplyInfo s) => s.supplytypeNameLanguage ?? "")
            .toList();

        _selectedSupplyIDs = _allSupplies
            .where(
              (supply) => _userSupplies.contains(supply.supplytypeLanguage),
            )
            .map((supply) => supply.supplytypeId.toString())
            .toList();

        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _userSupplies.map((name) {
                  final color = Utils.getRandomColor(name);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),

            if (prefs!.getString(AppStrings.prefUserID) ==
                widget.createdByUserID)
              ElevatedButton(
                onPressed: () {
                  _openSuppliesBottomSheet(widget.userCompanyUUID);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Update Supplies"),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_right_alt, color: Colors.white),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openSuppliesBottomSheet(String userCompanyUUID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Supply Types",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredSupplies.length,
                    itemBuilder: (context, index) {
                      final supply = _filteredSupplies[index];
                      final supplyId = supply.supplytypeId.toString();

                      return CheckboxListTile(
                        title: Text(supply.supplytypeName ?? ''),
                        value: _selectedSupplyIDs.contains(supplyId),
                        activeColor: AppColors.primaryColor,
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) {
                              _selectedSupplyIDs.add(supplyId);
                            } else {
                              _selectedSupplyIDs.remove(supplyId);
                            }
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      var prefs = await SharedPreferences.getInstance();
                      var updateSupplyRes;
                      if (widget.pageType == AppRoutes.companyDetailsScreen) {
                        updateSupplyRes = await AuthServices().updateSupplies(
                          context,
                          'COMPANY',
                          _selectedSupplyIDs.join(","),
                          userCompanyUUID,
                        );
                      } else if (widget.pageType == AppRoutes.myProfileScreen) {
                        updateSupplyRes = await AuthServices().updateSupplies(
                          context,
                          'USER',
                          _selectedSupplyIDs.join(","),
                          userCompanyUUID,
                        );
                      }
                      Navigator.pop(context);
                      SnackbarHelper.showSnackBar(
                        updateSupplyRes.apiResponse![0].responseDetails,
                      );
                      if (widget.pageType == AppRoutes.companyDetailsScreen) {
                        NavigationHelper.pushReplacementNamed(
                          AppRoutes.companyDetailsScreen,
                          arguments: {
                            'companyUUID': userCompanyUUID,
                            'companyPromotionStatus': 'true',
                          },
                        );
                      } else if (widget.pageType == AppRoutes.myProfileScreen) {
                        NavigationHelper.pushReplacementNamed(
                          AppRoutes.myProfileScreen,
                          arguments: {
                            'pageType': AppRoutes.dashboardScreen,
                            'userID': prefs.getString(AppStrings.prefUserID),
                          },
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
