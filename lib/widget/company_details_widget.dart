import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

class CompanyDetailsWidget extends StatelessWidget {
  final dynamic detailsModel;
  final List<dynamic> userInfo;
  final dynamic prefs;

  const CompanyDetailsWidget({
    super.key,
    required this.detailsModel,
    required this.userInfo,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner =
        userInfo[0].userId == prefs.getString(AppStrings.prefUserID);

    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isOwner)
                  Visibility(
                    visible: false, // set to true if needed
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          NavigationHelper.pushNamed(
                            AppRoutes.createAddressScreen,
                            arguments: {
                              'addressModel': detailsModel,
                              'pageType': "UpdateAddressScreen",
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Edit Info',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.edit, color: Colors.white, size: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            buildRow(
              Icons.business,
              'Name',
              detailsModel.apiResponse![0].companyNameLanguage ?? '',
            ),
            buildRow(
              Icons.description_outlined,
              'Details',
              detailsModel.apiResponse![0].companyDetails ?? '',
            ),
            buildRow(
              Icons.person_2_outlined,
              'Contact Name',
              detailsModel.apiResponse![0].companyContactUserName ?? '',
            ),
            buildRow(
              Icons.phone_android,
              'Contact Mobile',
              detailsModel.apiResponse![0].companyContactUserMobile ?? '',
            ),
            buildRow(
              Icons.email_outlined,
              'Contact Email',
              detailsModel.apiResponse![0].companyContactUserEmail ?? '',
            ),
            buildRow(
              Icons.web_outlined,
              'Website Url',
              detailsModel.apiResponse![0].companyWebsite ?? '',
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // WhatsApp button
                  ElevatedButton.icon(
                    onPressed: () {
                      Utils.openLink(
                        "https://wa.me/${detailsModel.apiResponse![0].companyContactUserMobile}/?text=Hello",
                      );
                    },
                    icon: Icon(Icons.message_outlined, color: Colors.white),
                    label: const Text("Whatsapp"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Utils.openLink(
                              "mailto:${detailsModel.apiResponse![0].companyContactUserEmail}",
                            );
                          },
                          icon: const Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                          label: const Text("Mail"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Utils.openDialPad(
                              detailsModel
                                  .apiResponse![0]
                                  .companyContactUserMobile,
                            );
                          },
                          icon: const Icon(Icons.call, color: Colors.white),
                          label: const Text("Call"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Change Banner Image
                  if (detailsModel.apiResponse![0].userBasicInfo![0].userId ==
                      prefs.getString(AppStrings.prefUserID))
                    ElevatedButton.icon(
                      onPressed: () {
                        NavigationHelper.pushNamed(
                          AppRoutes.uploadFileScreen,
                          arguments: {
                            'reference_from': "COMPANY_BANNER",
                            'reference_uuid':
                                detailsModel.apiResponse![0].companyUuid,
                            'isSingleFilePick': true,
                          },
                        )?.then((value) {
                          NavigationHelper.pushReplacementNamed(
                            AppRoutes.companyDetailsScreen,
                            arguments: {
                              'companyUUID':
                                  detailsModel.apiResponse![0].companyUuid,
                              'companyPromotionStatus': 'true',
                            },
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                      label: const Text("Change Banner Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade300,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                  // Change Profile Image
                  if (detailsModel.apiResponse![0].userBasicInfo![0].userId ==
                      prefs.getString(AppStrings.prefUserID))
                    ElevatedButton.icon(
                      onPressed: () {
                        NavigationHelper.pushNamed(
                          AppRoutes.uploadFileScreen,
                          arguments: {
                            'reference_from': "COMPANY_LOGO",
                            'reference_uuid':
                                detailsModel.apiResponse![0].companyUuid,
                            'isSingleFilePick': true,
                          },
                        )?.then((value) {
                          NavigationHelper.pushReplacementNamed(
                            AppRoutes.companyDetailsScreen,
                            arguments: {
                              'companyUUID':
                                  detailsModel.apiResponse![0].companyUuid,
                              'companyPromotionStatus': 'true',
                            },
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                      label: const Text("Change Profile Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade300,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (detailsModel.apiResponse![0].userBasicInfo![0].userId ==
                      prefs.getString(AppStrings.prefUserID))
                    ElevatedButton(
                      onPressed: () {
                        NavigationHelper.pushNamed(
                          AppRoutes.uploadFileScreen,
                          arguments: {
                            'reference_from': "COMPANY",
                            'reference_uuid':
                                detailsModel.apiResponse![0].companyUuid,
                            'pageType': AppRoutes.addressDetailsScreen,
                            'isSingleFilePick': false,
                          },
                        )?.then((value) {
                          NavigationHelper.pushNamed(
                            AppRoutes.companyDetailsScreen,
                            arguments: {
                              'companyUUID':
                                  detailsModel.apiResponse![0].companyUuid,
                              'companyPromotionStatus': 'true',
                            },
                          );
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
                  // Update button with arrow
                  if (detailsModel.apiResponse![0].userBasicInfo![0].userId ==
                      prefs.getString(AppStrings.prefUserID))
                    ElevatedButton(
                      onPressed: () {
                        NavigationHelper.pushNamed(
                          AppRoutes.updateCompanyDetailsScreen,
                          arguments: {
                            'companyUUID':
                                detailsModel.apiResponse![0].companyUuid,
                            'companyPromotionStatus': 'true',
                          },
                        )?.then((result) {
                          NavigationHelper.pushReplacementNamed(
                            AppRoutes.companyDetailsScreen,
                            arguments: {
                              'companyUUID':
                                  detailsModel.apiResponse![0].companyUuid,
                              'companyPromotionStatus': 'true',
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
                          Text("Update"),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_right_alt, color: Colors.white),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            SizedBox(width: 5),
            Text(
              "$label:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        SizedBox(width: 5),
        Expanded(
          child: label == "Website Url"
              ? GestureDetector(
                  onTap: () => Utils.openLink(value),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                )
              : Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
        ),
      ],
    ),
  );
}
