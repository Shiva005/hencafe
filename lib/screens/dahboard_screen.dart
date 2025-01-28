import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:hencafe/screens/fragments/home_fragment2.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../values/app_routes.dart';
import '../values/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _animationController;
  final _advancedDrawerController = AdvancedDrawerController();
  int _tabIndex = 1;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    // Curved animation
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1000)),
          builder: (context, snapshot) {
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              minLeadingWidth: 20,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70.0,
                              height: 70.0,
                              margin: const EdgeInsets.only(
                                top: 23.0,
                                bottom: 23.0,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                AppIconsData.logo,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hen Cafe',
                                    //'${AppStrings.pre} ${AppStrings.firstName}',
                                    style: AppTheme.primaryHeadingDrawer,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    AppStrings.prefMobileNumber,
                                    style: AppTheme.secondaryHeadingDrawer,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          _advancedDrawerController.hideDrawer();
                        },
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        title: const Text('Home'),
                        leading: SizedBox(
                            width: 23,
                            height: 23,
                            child: Image.asset('assets/vectors/home.png')),
                      ),
                      ListTile(
                        onTap: () {
                          _advancedDrawerController.hideDrawer();
                          showLoadingDialog(context, 'Logout',
                              'Are you sure you want to logout?');
                        },
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        leading: SizedBox(
                            width: 23,
                            height: 23,
                            child: Image.asset('assets/vectors/logout.png')),
                        title: const Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('User Name'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: HomeFragment2(),
      ),
    );
  }

  void showLoadingDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: AppTheme.informationString,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(horizontal: 20)),
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20)),
                    onPressed: () async {
                      var prefs = await SharedPreferences.getInstance();
                      var mb = prefs.getString(AppStrings.prefMobileNumber);
                      prefs.clear();
                      prefs.setString(AppStrings.prefMobileNumber, mb!);
                      NavigationHelper.pushReplacementNamedUntil(
                          AppRoutes.loginMobile);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
