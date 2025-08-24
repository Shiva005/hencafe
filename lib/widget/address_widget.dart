import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/address_details_model.dart';
import '../models/attachment_model.dart';
import '../services/services.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'attachment_widget.dart';

class AddressWidget extends StatelessWidget {
  final List<AddressDetails> addressList;
  final String pageType;

  const AddressWidget({
    super.key,
    required this.addressList,
    required this.pageType,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        return AddressWidgetData(
          address: addressList[index],
          pageType: pageType,
        );
      },
    );
  }
}

class AddressWidgetData extends StatefulWidget {
  final AddressDetails address;
  final String pageType;

  const AddressWidgetData({
    super.key,
    required this.address,
    required this.pageType,
  });

  @override
  State<AddressWidgetData> createState() => _AddressWidgetDataState();
}

class _AddressWidgetDataState extends State<AddressWidgetData> {
  int selectedTab = 0;
  final PageController _attachmentController = PageController();
  var prefs;
  String referenceFrom = "";

  @override
  void initState() {
    super.initState();
    _fetchPrefs();
  }

  Future<void> _fetchPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: 370,
      child: Card(
        color: Colors.white,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTabButtons(),
            const SizedBox(height: 10),
            selectedTab == 0
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildAddressCard(widget.address),
                  )
                : Expanded(child: _buildAttachmentsSection(widget.address)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("Address", 0),
        const SizedBox(width: 15),
        _tabButton("Attachments", 1),
      ],
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: () => setState(() => selectedTab = index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.indigo : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildAddressCard(AddressDetails address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRow(Icons.location_on, "Address Type", address.addressType ?? "-"),
        const SizedBox(height: 8),
        buildRow(Icons.home, "Address", address.addressAddress ?? "-"),
        const SizedBox(height: 8),
        buildRow(
          Icons.location_city,
          "City",
          address.locationInfo?.first.cityNameLanguage ?? "-",
        ),
        const SizedBox(height: 8),
        buildRow(
          Icons.map,
          "State",
          address.locationInfo?.first.stateNameLanguage ?? "-",
        ),
        const SizedBox(height: 8),
        buildRow(Icons.pin_drop, "Pincode", address.addressZipcode ?? "-"),
        const SizedBox(height: 30),

        if (address.userBasicInfo![0].userId ==
            prefs.getString(AppStrings.prefUserID))
          ElevatedButton(
            onPressed: () {
              NavigationHelper.pushNamed(
                AppRoutes.createAddressScreen,
                arguments: {
                  'addressModel': address,
                  'pageType': "UpdateAddressScreen",
                },
              )?.then((value) {
                NavigationHelper.pushReplacementNamed(
                  AppRoutes.myProfileScreen,
                  arguments: {
                    'pageType': AppRoutes.dashboardScreen,
                    'userID': prefs.getString(AppStrings.prefUserID),
                  },
                );
              });
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
                Text("Edit Address"),
                SizedBox(width: 8),
                Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
        if (address.userBasicInfo![0].userId ==
            prefs.getString(AppStrings.prefUserID))
          ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                animType: AnimType.bottomSlide,
                dialogType: DialogType.warning,
                dialogBackgroundColor: Colors.white,
                titleTextStyle: AppTheme.appBarText,
                title: 'Are you sure you want to delete this Address?',
                btnCancelOnPress: () {},
                btnCancelText: 'Cancel',
                btnOkOnPress: () async {
                  var deleteAddressRes = await AuthServices().deleteAddress(
                    context,
                    address.addressUuid!,
                  );
                  if (deleteAddressRes.apiResponse![0].responseStatus == true) {
                    NavigationHelper.pop(context);
                  }
                },
                btnOkText: 'Yes',
                btnOkColor: Colors.yellow.shade700,
              ).show();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.delete_forever, color: Colors.white),
                SizedBox(width: 8),
                Text("Delete"),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: () {
            NavigationHelper.pushNamed(
              AppRoutes.uploadFileScreen,
              arguments: {
                'reference_from': "ADDRESS",
                'reference_uuid': address.addressUuid,
                'pageType': AppRoutes.addressDetailsScreen,
              },
            )?.then((value) {
              if (widget.pageType == AppRoutes.companyDetailsScreen) {
                NavigationHelper.pushReplacementNamed(
                  AppRoutes.companyDetailsScreen,
                  arguments: {
                    'companyUUID': address.addressReferenceUuid,
                    'companyPromotionStatus': '',
                  },
                );
              }
              if (widget.pageType == AppRoutes.myProfileScreen) {
                NavigationHelper.pushReplacementNamed(
                  AppRoutes.myProfileScreen,
                  arguments: {
                    'pageType': AppRoutes.dashboardScreen,
                    'userID': prefs.getString(AppStrings.prefUserID),
                  },
                );
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Upload Attachment"),
              SizedBox(width: 8),
              Icon(Icons.file_upload_outlined, color: Colors.white),
            ],
          ),
        ),

        SizedBox(height: 20),
        if (address.userBasicInfo![0].userId ==
            prefs.getString(AppStrings.prefUserID))
          ElevatedButton(
            onPressed: () {
              NavigationHelper.pushNamed(
                AppRoutes.createAddressScreen,
                arguments: {
                  'addressModel': address,
                  'pageType': AppRoutes.createAddressScreen,
                },
              )?.then((value) {
                NavigationHelper.pushReplacementNamed(
                  AppRoutes.myProfileScreen,
                  arguments: {
                    'pageType': AppRoutes.dashboardScreen,
                    'userID': prefs.getString(AppStrings.prefUserID),
                  },
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Add New Address"),
                SizedBox(width: 8),
                Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentsSection(AddressDetails address) {
    final attachments = address.attachmentInfo;
    return PageView.builder(
      controller: _attachmentController,
      itemCount: attachments?.length,
      itemBuilder: (context, index) {
        return AttachmentWidget(
          attachments: address.attachmentInfo ?? [],
          userId: address.userBasicInfo![0].userId ?? '',
          currentUserId: prefs.getString(AppStrings.prefUserID) ?? '',
          referenceFrom: "ADDRESS",
          referenceUUID: widget.address.addressUuid!,
          onDelete: (index) {
            showDeleteAttachmentDialog(
              context: context,
              index: index,
              attachment: attachments![index],
              attachments: attachments,
              onUpdate: () => setState(() {}),
            );
          },
          index: index,
          pageType: "address_widget",
        );
      },
    );
  }

  void showDeleteAttachmentDialog({
    required BuildContext context,
    required int index,
    required AttachmentInfo attachment,
    required List<AttachmentInfo> attachments,
    required VoidCallback onUpdate,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.warning,
      dialogBackgroundColor: Colors.white,
      titleTextStyle: AppTheme.appBarText,
      title: 'Are you sure you want to delete this file?',
      btnCancelOnPress: () {},
      btnCancelText: 'Cancel',
      btnOkOnPress: () async {
        var attachmentDeleteRes = await AuthServices().attachmentDelete(
          context,
          attachment.attachmentId!,
          attachment.attachmentPath!,
        );

        if (attachmentDeleteRes.apiResponse![0].responseStatus == true) {
          attachments.removeAt(index);
          onUpdate();
        }
      },
      btnOkText: 'Yes',
      btnOkColor: Colors.yellow.shade700,
    ).show();
  }
}

Widget buildRow(IconData icon, String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(
            "$label:",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    ],
  );
}
