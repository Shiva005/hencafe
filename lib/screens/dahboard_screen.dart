import 'package:flutter/material.dart';
import 'package:hencafe/screens/fragments/home_fragment2.dart';
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
  var getProfileRes;
  int _tabIndex = 1;
  var prefs;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  @override
  void initState() {
    pageController = PageController(initialPage: _tabIndex);
    loadProfile();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    prefs = await SharedPreferences.getInstance();
    getProfileRes = await AuthServices().getProfile(context);
    if (getProfileRes.errorCount == 0) {
      prefs.setString(AppStrings.prefFirstName,
          getProfileRes.apiResponse![0].userFirstName);
      prefs.setString(
          AppStrings.prefLastName, getProfileRes.apiResponse![0].userLastName);
      prefs.setString(AppStrings.prefIsUserVerified,
          getProfileRes.apiResponse![0].userIsVerfied);
      prefs.setInt(
          AppStrings.prefFavStateMaxCount,
          getProfileRes
              .apiResponse![0].userMembershipInfo[0].userFavStateMaxCount);
      if (getProfileRes.apiResponse![0].attachmentInfo!.length != 0) {
        prefs.setString(AppStrings.prefUserImage,
            getProfileRes.apiResponse![0].attachmentInfo![0].attachmentPath);
      }
      prefs.setString(
          AppStrings.prefEmail, getProfileRes.apiResponse![0].userEmail);
    }
    if (getProfileRes.apiResponse![0].userFavouriteStateInfo!.isEmpty) {
      NavigationHelper.pushNamed(
        AppRoutes.stateSelection,
      );
    }
    setState(() {});
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
                : "",
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
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                prefs.getString(AppStrings.prefUserImage) ??
                                    ''),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Home'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child: Icon(
                            Icons.home_sharp,
                            color: AppColors.primaryColor,
                          )),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                        NavigationHelper.pushNamed(
                          AppRoutes.myProfileScreen,
                        );
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('My Profile'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child: Icon(Icons.person,
                              color: AppColors.primaryColor)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Change Language'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child: Icon(Icons.language,
                              color: AppColors.primaryColor)),
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
                          child: Icon(Icons.location_pin,
                              color: AppColors.primaryColor)),
                    ),
                    ListTile(
                      onTap: () {
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: const Text('Share App'),
                      leading: SizedBox(
                          width: 23,
                          height: 23,
                          child:
                              Icon(Icons.share, color: AppColors.primaryColor)),
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
                          child: Icon(Icons.star_purple500,
                              color: AppColors.primaryColor)),
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
                          var language =
                              prefs.getString(AppStrings.prefLanguage);
                          var countryCode =
                              prefs.getString(AppStrings.prefCountryCode);
                          prefs.clear();
                          prefs.setString(AppStrings.prefLanguage, language);
                          prefs.setString(AppStrings.prefMobileNumber, mb);
                          prefs.setString(AppStrings.prefCountryCode, countryCode);
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
