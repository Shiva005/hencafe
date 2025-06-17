import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/supplies_model.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_theme.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  var getProfileRes, getAddressRes, getSuppliesRes;
  var prefs;
  var name = "",
      email = "",
      phone = "",
      userImage = "",
      userVerified = "",
      memberShipType = "",
      maxFavState = "",
      memberShipValidFrom = Utils.formatDate(DateTime.now()),
      memberShipValidTo = Utils.formatDate(DateTime.now()),
      workType = "";

  var selectedIds = '';
  var favStateList = [];
  var suppliesList = [];
  List<ApiResponse> _allSupplies = [];
  List<ApiResponse> _filteredSupplies = [];
  List<String> _selectedSupplyIDs = [];

  @override
  void initState() {
    loadProfile();
    _fetchSupplies();
    super.initState();
  }

  Future<List<ApiResponse>> _fetchSupplies() async {
    final res = await AuthServices()
        .getSupplies(context); // Replace with your actual call
    if (res.errorCount == 0 && res.apiResponse != null) {
      setState(() {
        _allSupplies = res.apiResponse!;
        _filteredSupplies = _allSupplies;
      });
      return _allSupplies;
    }
    return [];
  }

  Future<void> loadProfile() async {
    prefs = await SharedPreferences.getInstance();
    LoadingDialogHelper.showLoadingDialog(context);
    getProfileRes = await AuthServices().getProfile(context);
    getAddressRes = await AuthServices().getAddress(context);
    getSuppliesRes = await AuthServices().getSupplies(context);
    if (getProfileRes.errorCount == 0) {
      LoadingDialogHelper.dismissLoadingDialog(context);
      setState(() {
        name = getProfileRes.apiResponse![0].userFirstName +
                " " +
                getProfileRes.apiResponse![0].userLastName ??
            "";
        email = getProfileRes.apiResponse![0].userEmail ?? "";
        phone = getProfileRes.apiResponse![0].userMobile ?? "";
        userVerified = getProfileRes.apiResponse![0].userIsVerfied ?? "";
        memberShipType = getProfileRes.apiResponse![0].userMembershipInfo![0]
                .userMembershipType.value ??
            "";
        memberShipValidFrom = getProfileRes.apiResponse![0]
                .userMembershipInfo![0].userMembershipValidFrom ??
            "";
        maxFavState = getProfileRes
                .apiResponse![0].userMembershipInfo![0].userFavStateMaxCount
                .toString() ??
            "";
        memberShipValidTo = getProfileRes
                .apiResponse![0].userMembershipInfo![0].userMembershipValidTo ??
            "";
        workType = getProfileRes.apiResponse![0].userWorkType.value ?? "";
        if (getProfileRes.apiResponse![0].attachmentInfo!.length != 0) {
          userImage =
              getProfileRes.apiResponse![0].attachmentInfo![0].attachmentPath ??
                  "";
        }
        for (int i = 0;
            i < getProfileRes.apiResponse![0].userFavouriteStateInfo!.length;
            i++) {
          favStateList.add(getProfileRes.apiResponse![0]
              .userFavouriteStateInfo![i].stateInfo![0].stateNameLanguage);
        }
        for (int i = 0;
            i < getProfileRes.apiResponse![0].supplyInfo.length;
            i++) {
          suppliesList.add(getProfileRes
              .apiResponse![0].supplyInfo![i].supplytypeNameLanguage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primaryColor,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Text(
            "My Profile",
            style: AppTheme.primaryHeadingDrawer,
          ),
          centerTitle: false,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              _card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(userImage),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Icon(
                                userVerified == "Y"
                                    ? Icons.verified_sharp
                                    : Icons.not_interested_outlined,
                                color: userVerified == "Y"
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          userVerified == "Y" ? "VERIFIED" : "NOT VERIFIED",
                          style: TextStyle(
                              color: userVerified == "Y"
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outlined, size: 18),
                              SizedBox(width: 5),
                              Text(name),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16),
                              SizedBox(width: 5),
                              Text(phone),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(Icons.email_outlined, size: 16),
                              SizedBox(width: 5),
                              Text(email),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildChip(memberShipType),
                              _buildChip(workType),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Column(
                    children: [
                      _sectionHeader("Favorite states", onEdit: () {
                        NavigationHelper.pushNamed(
                          AppRoutes.stateSelection,
                        );
                      }),
                      SizedBox(
                        height: 25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: favStateList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildChip(favStateList[index]),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Membership Info
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, bottom: 10.0),
                      child: Text(
                        "Membership Details",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Membership Type : ",
                              style: TextStyle(color: Colors.grey.shade700)),
                          Text(memberShipType),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Maximum Favourite State : ",
                              style: TextStyle(color: Colors.grey.shade700)),
                          Text(maxFavState),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Start Date :",
                              style: TextStyle(color: Colors.grey.shade700)),
                          Text(Utils.threeLetterDateFormatted(
                              memberShipValidFrom)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("End Date :",
                              style: TextStyle(color: Colors.grey.shade700)),
                          Text(Utils.threeLetterDateFormatted(
                              memberShipValidTo)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Supplies
              Visibility(
                visible: suppliesList.isNotEmpty,
                child: _card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        _sectionHeader("Supplies", onEdit: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                  top: 20,
                                  left: 16,
                                  right: 16,
                                ),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setModalState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Select Supply Types",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          // Important for wrapping
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: _filteredSupplies.length,
                                          itemBuilder: (context, index) {
                                            final supply =
                                                _filteredSupplies[index];
                                            final supplyId =
                                                supply.supplytypeId.toString();
                                            return CheckboxListTile(
                                              title: Text(
                                                  supply.supplytypeName ?? ''),
                                              value: _selectedSupplyIDs
                                                  .contains(supplyId),
                                              activeColor:
                                                  AppColors.primaryColor,
                                              onChanged: (checked) {
                                                setModalState(() {
                                                  setState(() {
                                                    if (checked == true) {
                                                      _selectedSupplyIDs
                                                          .add(supplyId);
                                                    } else {
                                                      _selectedSupplyIDs
                                                          .remove(supplyId);
                                                    }
                                                    SnackbarHelper.showSnackBar(
                                                        _selectedSupplyIDs
                                                            .toString());
                                                  });
                                                });
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // or submit logic
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                          ),
                                          child: const Text(
                                            "Save",
                                            style:
                                                TextStyle(color: Colors.white),
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
                        }),
                        SizedBox(
                          height: 25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: suppliesList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildChip(suppliesList[index]),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Saved Addresses",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (getAddressRes?.apiResponse != null &&
                        getAddressRes!.apiResponse!.isNotEmpty)
                      SizedBox(
                        height: 115,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: getAddressRes!.apiResponse!.length,
                          itemBuilder: (context, index) {
                            final address = getAddressRes!.apiResponse![index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              width: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      _buildChip(
                                          address.addressType ?? "Other"),
                                      _buildChip("View More"),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(address.addressAddress ?? "No Address"),
                                  Text(
                                    "${address.locationInfo?[0].cityNameLanguage ?? "City"}, "
                                    "${address.locationInfo?[0].stateNameLanguage ?? "State"}, "
                                    "${address.locationInfo?[0].countryNameLanguage ?? "Country"} - "
                                    "${address.addressZipcode ?? "Zipcode"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Text("No addresses found")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (onEdit != null)
          IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryColor),
              onPressed: onEdit),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 3,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}
