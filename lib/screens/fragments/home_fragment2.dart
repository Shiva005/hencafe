import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_icons.dart';

import '../../helpers/navigation_helper.dart';
import '../../values/app_routes.dart';

class HomeFragment2 extends StatefulWidget {
  const HomeFragment2({super.key});

  @override
  State<HomeFragment2> createState() => _HomeFragment2State();
}

class _HomeFragment2State extends State<HomeFragment2>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 3.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildDashboardCard(
                            AppIconsData.colorEgg, "Egg Price")),
                    SizedBox(width: 20),
                    Expanded(
                        child: _buildDashboardCard(
                            AppIconsData.colorChick, "Chick Price")),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                          AppIconsData.colorChicken, "Chicken Price"),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: _buildDashboardCard(
                            AppIconsData.colorFeed, "Feed Price")),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: _buildDashboardCard(
                            AppIconsData.colorVideo, "Sale Videos")),
                    SizedBox(width: 20),
                    Expanded(
                        child: _buildDashboardCard(
                            AppIconsData.colorContact, "Contact")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //Init Floating Action Bubble
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionBubble(
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Sell Egg",
              iconColor: Colors.white,
              bubbleColor: AppColors.primaryColor,
              icon: Icons.currency_rupee_outlined,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                NavigationHelper.pushNamed(
                  AppRoutes.sellEggScreen,
                );
              },
            ),
            // Floating action menu item
            Bubble(
              title: "Sell Chick",
              iconColor: Colors.white,
              bubbleColor: AppColors.primaryColor,
              icon: Icons.currency_rupee_outlined,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Sell Chicken",
              iconColor: Colors.white,
              bubbleColor: AppColors.primaryColor,
              icon: Icons.currency_rupee_outlined,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.white,
          iconData: Icons.add,
          backGroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String icon, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor100, width: 2),
        // Orange border
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        margin: EdgeInsets.zero,
        // Removes extra margin from the card
        child: InkWell(
          onTap: () {
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
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50, width: 50.0, child: Image.asset(icon)),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
