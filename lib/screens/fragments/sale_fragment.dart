import 'package:flutter/material.dart';

import '../../helpers/navigation_helper.dart';
import '../../values/app_icons.dart';
import '../../values/app_routes.dart';

class SaleFragment extends StatefulWidget {
  const SaleFragment({super.key});

  @override
  State<SaleFragment> createState() => _SaleFragmentState();
}

class _SaleFragmentState extends State<SaleFragment>
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
                    child: _buildDashboardCard(AppIconsData.colorEgg,
                        "Egg Price", "Egg price info and sell your eggs")),
                SizedBox(width: 20),
                Expanded(
                    child: _buildDashboardCard(AppIconsData.colorChick,
                        "Chick Price", "Chick price info and sell your chick")),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                      AppIconsData.colorChicken,
                      "Chicken Price",
                      "Chicken price info and sell your chicken"),
                ),
                SizedBox(width: 20),
                Expanded(
                    child: _buildDashboardCard(
                        AppIconsData.colorLiftingSale,
                        "Lifting Sale",
                        "Lifting sale info and sell your Farm")),
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
        // Removes extra margin from the card
        child: InkWell(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            }
            if (label == 'Egg Price') {
              NavigationHelper.pushNamed(
                AppRoutes.eggPriceScreen,
              );
            } else if (label == 'Chick Price') {
              NavigationHelper.pushNamed(
                AppRoutes.chickPriceScreen,
              );
            } else if (label == 'Chicken Price') {
              NavigationHelper.pushNamed(
                AppRoutes.chickenPriceScreen,
              );
            } else if (label == 'Lifting Sale') {
              NavigationHelper.pushNamed(
                AppRoutes.liftingPriceScreen,
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
