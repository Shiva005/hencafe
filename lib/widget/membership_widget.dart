import 'package:flutter/material.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:hencafe/values/app_colors.dart';

import '../models/membership_model.dart';

class MembershipWidget extends StatelessWidget {
  final List<UserMembershipInfo> membershipList;

  const MembershipWidget({
    super.key,
    required this.membershipList,
  });

  @override
  Widget build(BuildContext context) {
    if (membershipList.isEmpty) return const SizedBox();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            buildRow(Icons.card_giftcard, 'Type',
                membershipList[0].userMembershipType!.value ?? ''),
            buildRow(Icons.location_city_outlined, 'Maximum Favourites states',
                membershipList[0].userFavStateMaxCount ?? ''),
            buildRow(
                Icons.date_range,
                'Start Date',
                Utils.threeLetterDateFormatted(
                    membershipList[0].userMembershipValidFrom ?? '')),
            buildRow(
                Icons.calendar_month,
                'End Date',
                Utils.threeLetterDateFormatted(
                    membershipList[0].userMembershipValidTo ?? '')),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Expires in:  ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '${Utils.calculateTotalDays(membershipList[0].userMembershipValidTo!)} Days',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
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
