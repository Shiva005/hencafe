import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../utils/utils.dart';

class UserDetailsWidget extends StatelessWidget {
  final ProfileModel detailsModel;

  const UserDetailsWidget({super.key, required this.detailsModel});

  @override
  Widget build(BuildContext context) {
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
          buildRow(Icons.person, 'Full Name',
              '${detailsModel.apiResponse![0].userFirstName ?? ''} ${detailsModel.apiResponse![0].userLastName ?? ''}'),
          buildRow(Icons.phone, 'Mobile',
              detailsModel.apiResponse![0].userMobile ?? ''),
          buildRow(Icons.email, 'Email',
              detailsModel.apiResponse![0].userEmail ?? ''),
          buildRow(
              Icons.calendar_month,
              'Date of Birth',
              '${Utils.threeLetterDateFormatted(detailsModel.apiResponse![0].userDob.toString())} '
                  '(${Utils.calculateAge(detailsModel.apiResponse![0].userDob!)} Years)'),
          buildRow(
              Icons.verified,
              'Verified ? ',
              Utils.getVerifiedEnum(
                  detailsModel.apiResponse![0].userIsVerfied ?? '')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildTag(
                      "Role: ",
                      Utils.getUserRoleName(
                          detailsModel.apiResponse![0].userRoleType)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTag("Work: ",
                      '${detailsModel.apiResponse![0].userWorkType!.value}'),
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
                        "https://wa.me/${detailsModel.apiResponse![0].userMobile}/?text=Hello");
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
                              "mailto:${detailsModel.apiResponse![0].userEmail}");
                        },
                        icon: const Icon(Icons.email_outlined,
                            color: Colors.white),
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
                              detailsModel.apiResponse![0].userMobile!);
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
                      borderRadius: BorderRadius.circular(30),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Update button with arrow
                ElevatedButton(
                  onPressed: () {},
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
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
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
}
