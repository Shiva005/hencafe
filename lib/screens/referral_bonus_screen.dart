import 'package:flutter/material.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/referral_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';

class ReferralBonusScreen extends StatefulWidget {
  const ReferralBonusScreen({super.key});

  @override
  State<ReferralBonusScreen> createState() => _ReferralBonusScreenState();
}

class _ReferralBonusScreenState extends State<ReferralBonusScreen> {
  late SharedPreferences prefs;
  late Future<ReferralModel> referralModel;

  @override
  void initState() {
    super.initState();
    referralModel = _fetchData();
  }

  Future<ReferralModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getReferralsList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: MyAppBar(title: 'Referral Info'),
      body: FutureBuilder<ReferralModel>(
        future: referralModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Something went wrong.'));
          }

          final model = snapshot.data!;
          final summary = model.pointsSummaryByStatus;
          final referrals = model.apiResponse ?? [];

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text('Referral Code',
                    style: TextStyle(color: Colors.grey.shade800)),
                Text(
                  prefs.getString(AppStrings.prefMobileNumber) ?? 'N/A',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Referral Bonus: ',
                        style: TextStyle(color: Colors.grey.shade800)),
                    Text('${summary?.total}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                // Summary Boxes
                Wrap(
                  spacing: 10,
                  children: [
                    _summaryBox(
                        summary?.available ?? 0, 'Available', Colors.green),
                    _summaryBox(
                        summary?.pending ?? 0, 'Pending', Colors.orange),
                    _summaryBox(summary?.used ?? 0, 'Used', Colors.blue),
                    _summaryBox(summary?.expired ?? 0, 'Expired', Colors.red),
                  ],
                ),

                const Divider(height: 20, thickness: 1),

                // Referral List
                Expanded(
                  child: ListView.builder(
                    itemCount: referrals.length,
                    itemBuilder: (_, index) {
                      final item = referrals[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${item.earnedPoints ?? 0}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: _getStatusTextColor(
                                                    '${item.status!.value}')),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '/10',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${item.status!.value}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: _getStatusTextColor(
                                                '${item.status!.value}')),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      item.dipalyText ?? 'Display text here',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              if (item.comments!.isNotEmpty)
                                Text(
                                  item.comments ?? 'Comments displaying here',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Earned: ${Utils.threeLetterDateFormatted(item.createdon!)}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (item.pointsChargedDate != "2000-01-01")
                                    Text(
                                      'Updated: ${Utils.threeLetterDateFormatted(item.pointsChargedDate!)}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'used':
        return Colors.blue;
      case 'expired':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  Widget _summaryBox(int value, String label, Color bgColor) {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
