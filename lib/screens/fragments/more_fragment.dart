import 'package:flutter/material.dart';

import '../../helpers/navigation_helper.dart';
import '../../values/app_icons.dart';
import '../../values/app_routes.dart';

class MoreFragment extends StatefulWidget {
  const MoreFragment({super.key});

  @override
  State<MoreFragment> createState() => _MoreFragmentState();
}

class _MoreFragmentState extends State<MoreFragment>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildDashboardCard(
                        AppIconsData.colorCompanies,
                        "Companies",
                        "Everything Your Chickens Need, All in One Place.")),
                SizedBox(width: 20),
                Expanded(
                    child: _buildDashboardCard(
                        AppIconsData.colorSellers,
                        "Sellers",
                        "Start and grow your farm easily with us!")),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _buildDashboardCard(AppIconsData.colorMedicine,
                        "FAQ's", "Got Questions? We’ve Got Answers.")),
                SizedBox(width: 20),
                Expanded(
                  child: _buildDashboardCard(AppIconsData.colorContact,
                      "Contact Us", "Need Help? We're Just a Message Away."),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String icon, String label, String desc) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
        // Orange border
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            }
            if (label == 'Companies') {
              NavigationHelper.pushNamed(
                AppRoutes.companyListScreen,
              );
            } else if (label == 'Sellers') {
              NavigationHelper.pushNamed(
                AppRoutes.medicineScreen,
              );
            } else if (label == 'FAQ\'s') {
              NavigationHelper.pushNamed(
                AppRoutes.medicineScreen,
              );
            } else if (label == 'Contact Us') {
              NavigationHelper.pushNamed(
                AppRoutes.contactUsScreen,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40, width: 40.0, child: Image.asset(icon)),
                const SizedBox(height: 12),
                Text(label,
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 3),
                Text(desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
