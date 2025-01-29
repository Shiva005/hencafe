import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:hencafe/screens/fragments/home_fragment2.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController pageController;
  final _advancedDrawerController = AdvancedDrawerController();
  int _tabIndex = 1;
  var prefs;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
    loadProfile();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    prefs = await SharedPreferences.getInstance();
    bool favStateMaxCount = prefs.containsKey(AppStrings.prefFavStateMaxCount);
    if (!favStateMaxCount) {
      var getProfileRes = await AuthServices().getProfile(context);
      if (getProfileRes.errorCount == 0) {
        setState(() {
          prefs.setString(AppStrings.prefFirstName,
              getProfileRes.apiResponse![0].userFirstName);
          prefs.setString(AppStrings.prefLastName,
              getProfileRes.apiResponse![0].userLastName);
          prefs.setString(AppStrings.prefFavStateMaxCount,
              getProfileRes.apiResponse![0].userFavStateMaxCount);
          prefs.setString(AppStrings.prefUserImage,
              getProfileRes.apiResponse![0].userProfileImg![0].attachmentPath);
          prefs.setString(
              AppStrings.prefEmail, getProfileRes.apiResponse![0].userEmail);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Text(
            prefs != null
                ? '${prefs.getString(AppStrings.prefLastName)} ${prefs.getString(AppStrings.prefFirstName)}'
                : '',
            style: AppTheme.primaryHeadingDrawer,
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.format_align_left,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade100,
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1000)),
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40.0),
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
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              prefs.getString(AppStrings.prefUserImage) ?? '',
                              // Provide a default empty string
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      AppIconsData.logo), // Fallback icon
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${prefs.getString(AppStrings.prefLastName)} ${prefs.getString(AppStrings.prefFirstName)}',
                                  style: AppTheme.primaryColorTExtStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  prefs.getString(AppStrings.prefMobileNumber),
                                  style: AppTheme.secondaryHeadingDrawer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Home'),
                      leading: SizedBox(
                          width: 23, height: 23, child: Icon(Icons.home_sharp)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Profile'),
                      leading: SizedBox(
                          width: 23, height: 23, child: Icon(Icons.person)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Change Language'),
                      leading: SizedBox(
                          width: 23, height: 23, child: Icon(Icons.language)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                        NavigationHelper.pushNamed(
                          AppRoutes.stateSelection,
                        );
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Favourite States'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child: Icon(Icons.location_pin)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Share App'),
                      leading: SizedBox(
                          width: 23, height: 23, child: Icon(Icons.share)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Rate App'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child: Icon(Icons.star_purple500)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.closeDrawer();
                        showLogoutDialog(context);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.0),
                            bottom: Radius.circular(30.0),
                          ),
                        ),
                        side: BorderSide(
                          color: Colors.red, // Black border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppStrings.logout,
                            style: AppTheme.rejectedTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: HomeFragment2(),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logout Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade50, // Light red background
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 15),
                // Logout Text
                Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Description Text
                Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                // Buttons
                Column(
                  children: [
                    // Yes, Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          var mb = prefs.getString(AppStrings.prefMobileNumber);
                          prefs.clear();
                          prefs.setString(AppStrings.prefMobileNumber, mb!);
                          NavigationHelper.pushReplacementNamedUntil(
                              AppRoutes.loginMobile);
                        },
                        child: Text("Yes, Logout"),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
