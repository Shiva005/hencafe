import 'package:flutter/material.dart';
import 'package:hencafe/helpers/navigation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';
import '../utils/utils.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

class UserDetailsWidget extends StatefulWidget {
  final ProfileModel detailsModel;

  const UserDetailsWidget({super.key, required this.detailsModel});

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {}); // rebuild once prefs is loaded
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return const CircularProgressIndicator(); // loading state
    }
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          buildRow(
            Icons.person,
            'Full Name',
            '${widget.detailsModel.apiResponse![0].userFirstName ?? ''} ${widget.detailsModel.apiResponse![0].userLastName ?? ''}',
          ),
          buildRow(
            Icons.phone,
            'Mobile',
            widget.detailsModel.apiResponse![0].userMobile ?? '',
          ),
          buildRow(
            Icons.email,
            'Email',
            widget.detailsModel.apiResponse![0].userEmail ?? '',
          ),
          buildRow(
            Icons.calendar_month,
            'Date of Birth',
            '${Utils.threeLetterDateFormatted(widget.detailsModel.apiResponse![0].userDob.toString())} '
                '(${Utils.calculateAge(widget.detailsModel.apiResponse![0].userDob!)} Years)',
          ),
          buildRow(
            Icons.verified,
            'Verified ? ',
            Utils.getVerifiedEnum(
              widget.detailsModel.apiResponse![0].userIsVerfied ?? '',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildTag(
                    "Role: ",
                    Utils.getUserRoleName(
                      widget.detailsModel.apiResponse![0].userRoleType,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTag(
                    "Work: ",
                    '${widget.detailsModel.apiResponse![0].userWorkType!.value}',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // WhatsApp button
                ElevatedButton.icon(
                  onPressed: () {
                    Utils.openLink(
                      "https://wa.me/${widget.detailsModel.apiResponse![0].userMobile}/?text=Hello",
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
                            "mailto:${widget.detailsModel.apiResponse![0].userEmail}",
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
                            widget.detailsModel.apiResponse![0].userMobile!,
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
                if (prefs!.getString(AppStrings.prefUserID) ==
                    widget.detailsModel.apiResponse![0].userId)
                  ElevatedButton.icon(
                    onPressed: () {
                      NavigationHelper.pushNamed(
                        AppRoutes.uploadFileScreen,
                        arguments: {
                          'reference_from': "USER_BANNER",
                          'reference_uuid':
                          widget.detailsModel.apiResponse![0].userUuid,
                          'isSingleFilePick': true,
                        },
                      )?.then((value) {
                        NavigationHelper.pushReplacementNamed(
                          AppRoutes.myProfileScreen,
                          arguments: {
                            'pageType': AppRoutes.dashboardScreen,
                            'userID':
                            widget.detailsModel.apiResponse![0].userId,
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
                      backgroundColor: Colors.red.shade200,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                // Change Profile Image
                if (prefs!.getString(AppStrings.prefUserID) ==
                    widget.detailsModel.apiResponse![0].userId)
                  ElevatedButton.icon(
                    onPressed: () {
                      NavigationHelper.pushNamed(
                        AppRoutes.uploadFileScreen,
                        arguments: {
                          'reference_from': "USER_PROFILE",
                          'reference_uuid':
                              widget.detailsModel.apiResponse![0].userUuid,
                          'isSingleFilePick': true,
                        },
                      )?.then((value) {
                        NavigationHelper.pushReplacementNamed(
                          AppRoutes.myProfileScreen,
                          arguments: {
                            'pageType': AppRoutes.dashboardScreen,
                            'userID':
                                widget.detailsModel.apiResponse![0].userId,
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
                      backgroundColor: Colors.pink.shade200,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Update button with arrow
                if (prefs!.getString(AppStrings.prefUserID) ==
                    widget.detailsModel.apiResponse![0].userId)
                  ElevatedButton(
                    onPressed: () {
                      NavigationHelper.pushNamed(
                        AppRoutes.uploadFileScreen,
                        arguments: {
                          'reference_from': "USER",
                          'reference_uuid':
                              widget.detailsModel.apiResponse![0].userUuid,
                          'pageType': AppRoutes.addressDetailsScreen,
                        },
                      )?.then((value) {
                        NavigationHelper.pushReplacementNamed(
                          AppRoutes.myProfileScreen,
                          arguments: {
                            'pageType': AppRoutes.dashboardScreen,
                            'userID':
                                widget.detailsModel.apiResponse![0].userId,
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
                if (prefs!.getString(AppStrings.prefUserID) ==
                    widget.detailsModel.apiResponse![0].userId)
                  ElevatedButton(
                    onPressed: () {
                      NavigationHelper.pushNamed(
                        AppRoutes.registerBasicDetails,
                        arguments: {
                          'mobileNumber':
                              widget.detailsModel.apiResponse![0].userMobile,
                          'pageType': AppRoutes.myProfileScreen,
                          'profileModel': widget.detailsModel.apiResponse![0],
                        },
                      );
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
                        Text("Edit Details"),
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
    );
  }

  Widget _buildTag(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            key,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}
