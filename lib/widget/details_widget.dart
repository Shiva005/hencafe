import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

class DetailsWidget extends StatelessWidget {
  final dynamic detailsModel;
  final List<dynamic> userInfo;
  final dynamic prefs;

  const DetailsWidget({
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
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Company Information',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                if (isOwner)
                  Visibility(
                    visible: false, // set to true if needed
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 3),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
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
            buildRow(Icons.business, 'Name',
                detailsModel.apiResponse![0].companyNameLanguage ?? ''),
            buildRow(Icons.description_outlined, 'Details',
                detailsModel.apiResponse![0].companyDetails ?? ''),
            buildRow(Icons.person_2_outlined, 'Contact Name',
                detailsModel.apiResponse![0].companyContactUserName ?? ''),
            buildRow(Icons.phone_android, 'Contact Mobile',
                detailsModel.apiResponse![0].companyContactUserMobile ?? ''),
            buildRow(Icons.email_outlined, 'Contact Email',
                detailsModel.apiResponse![0].companyContactUserEmail ?? ''),
            buildRow(Icons.web_outlined, 'Website Url',
                detailsModel.apiResponse![0].companyWebsite ?? ''),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // WhatsApp button
                  ElevatedButton.icon(
                    onPressed: () {
                      Utils.openLink(
                          "https://wa.me/${detailsModel.apiResponse![0].companyContactUserMobile}/?text=Hello");
                    },
                    icon: Icon(Icons.message_outlined, color: Colors.white),
                    label: const Text("Whatsapp"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Utils.openLink(
                                "mailto:${detailsModel.apiResponse![0].companyContactUserEmail}");
                          },
                          icon: const Icon(Icons.email_outlined,
                              color: Colors.white),
                          label: const Text("Mail"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Utils.openDialPad(detailsModel
                                .apiResponse![0].companyContactUserMobile);
                          },
                          icon: const Icon(Icons.call, color: Colors.white),
                          label: const Text("Call"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Change Banner Image
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white),
                    label: const Text("Change Banner Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade200,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  // Change Profile Image
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white),
                    label: const Text("Change Profile Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade200,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Update button with arrow
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Update"),
                        SizedBox(width: 8),
                        Icon(Icons.double_arrow_rounded, color: Colors.white),
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
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 5),
            Text(
              "$label:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
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
