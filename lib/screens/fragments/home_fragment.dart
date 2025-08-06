import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/profile_model.dart';
import 'package:hencafe/screens/fragments/company_list_fragment.dart';
import 'package:hencafe/screens/fragments/more_fragment.dart';
import 'package:hencafe/screens/fragments/sale_fragment.dart';
import 'package:hencafe/screens/fragments/sellers_list_fragment.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/navigation_helper.dart';
import '../../models/company_providers_model.dart';
import '../../services/services.dart';
import '../../values/app_routes.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: Home(),
          item: ItemConfig(
            activeForegroundColor: AppColors.primaryColor,
            icon: Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: SaleFragment(),
          item: ItemConfig(
            activeForegroundColor: AppColors.primaryColor,
            icon: Icon(Icons.currency_rupee),
            title: "Sale",
          ),
        ),
        PersistentTabConfig(
          screen: MoreFragment(),
          item: ItemConfig(
            activeForegroundColor: AppColors.primaryColor,
            icon: Icon(Icons.format_list_bulleted_outlined),
            title: "More",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Colors.white, // <-- This sets the background color
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<Home>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;
  late Future<CompanyProvidersModel> companyListData;
  late Future<ProfileModel?> profileListData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primaryColor,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Company'),
                Tab(text: 'Sellers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CompanyListFragment(),
                  SellerListFragment(),
                ],
              ),
            ),
          ],
        ),
      ),

           /* Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text("Companies",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                SizedBox(
                  height: 170,
                  child: FutureBuilder<ProfileModel?>(
                    future: profileListData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}"));
                      }

                      final profiles = snapshot.data?.apiResponse ?? [];
                      return profiles.isNotEmpty
                          ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          return GestureDetector(
                              onTap: () {
                                NavigationHelper.pushNamed(
                                    AppRoutes.myProfileScreen);
                              },
                              child: Wrap(
                                children: [
                                  Container(
                                    width: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                          AppColors.primaryColor),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(8.0),
                                      child: StreamBuilder<Object>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return Column(
                                              children: [
                                                */
      /*Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (profile
                                                                        .attachmentInfo![
                                                                            0]
                                                                        .attachmentPath !=
                                                                    null) {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              ImagePreviewScreen(
                                                                        imageUrl: profile
                                                                            .attachmentInfo![0]
                                                                            .attachmentPath!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: profile.attachmentInfo![0].attachmentPath !=
                                                                            null &&
                                                                        profile
                                                                            .attachmentInfo![
                                                                                0]
                                                                            .attachmentPath!
                                                                            .isNotEmpty
                                                                    ? Image
                                                                        .network(
                                                                  profile
                                                                      .attachmentInfo![
                                                                  0]
                                                                      .attachmentPath!,
                                                                        width:
                                                                            70,
                                                                        height:
                                                                            70,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Image
                                                                        .asset(
                                                                        AppIconsData
                                                                            .noImage,
                                                                        width:
                                                                            70,
                                                                        height:
                                                                            70,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    profile
                                                                    .userFirstName ??
                                                                        'No Name',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .business_center_outlined,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                          size:
                                                                              18),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(profile
                                                                              .userLastName ??
                                                                          'No Details'),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .perm_phone_msg_outlined,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                          size:
                                                                              18),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(profile
                                                                              .userEmail ??
                                                                          'No Contact'),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Icon(
                                                                Icons
                                                                    .arrow_right_alt_outlined,
                                                                color: AppColors
                                                                    .primaryColor),
                                                          ],
                                                        ),*/
      /*
                                                const SizedBox(
                                                    height: 10),
                                                if (profile.supplyInfo !=
                                                    null &&
                                                    profile.supplyInfo!
                                                        .isNotEmpty)
                                                  SizedBox(
                                                    height: 40,
                                                    // Enough height for two rows with padding

                                                    child: ListView(
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      children: [
                                                        Wrap(
                                                          direction: Axis
                                                              .horizontal,
                                                          // vertical wrap to create 2 rows
                                                          runSpacing: 5,
                                                          children: profile
                                                              .supplyInfo!
                                                              .map((e) =>
                                                          e.supplytypeNameLanguage ??
                                                              '')
                                                              .where((name) =>
                                                          name
                                                              .isNotEmpty)
                                                              .map(
                                                                  (name) {
                                                                final bgColor =
                                                                _getRandomColor(
                                                                    name);
                                                                return Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                      8),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      10,
                                                                      vertical:
                                                                      6),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    bgColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(6),
                                                                  ),
                                                                  child:
                                                                  Text(
                                                                    name,
                                                                    style:
                                                                    const TextStyle(
                                                                      color:
                                                                      Colors.white,
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      )
                          : Center(child: Text("No companies available"));
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Users",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: FutureBuilder<CompanyProvidersModel>(
                    future: companyListData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}"));
                      }

                      final companies = snapshot.data?.apiResponse ?? [];
                      return companies.isNotEmpty
                          ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: companies.length,
                        itemBuilder: (context, index) {
                          final company = companies[index];
                          return GestureDetector(
                              onTap: () {
                                NavigationHelper.pushNamed(
                                    AppRoutes.companyDetailsScreen,
                                    arguments: {
                                      'companyUUID':
                                      company.companyUuid,
                                      'companyPromotionStatus': 'true'
                                    });
                              },
                              child: Wrap(
                                children: [
                                  Container(
                                    width: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                          AppColors.primaryColor),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(8.0),
                                      child: StreamBuilder<Object>(
                                          stream: null,
                                          builder: (context, snapshot) {
                                            return Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (company
                                                            .attachmentLogoInfo![
                                                        0]
                                                            .attachmentPath!
                                                            .isNotEmpty) {
                                                          Navigator
                                                              .push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (_) =>
                                                                  ImagePreviewScreen(
                                                                    imageUrl: company
                                                                        .attachmentLogoInfo![0]
                                                                        .attachmentPath!,
                                                                  ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            8),
                                                        child: company.attachmentLogoInfo !=
                                                            null &&
                                                            company
                                                                .attachmentLogoInfo!
                                                                .isNotEmpty
                                                            ? Image
                                                            .network(
                                                          company
                                                              .attachmentLogoInfo![0]
                                                              .attachmentPath!,
                                                          width:
                                                          70,
                                                          height:
                                                          70,
                                                          fit: BoxFit
                                                              .cover,
                                                        )
                                                            : Image
                                                            .asset(
                                                          AppIconsData
                                                              .noImage,
                                                          width:
                                                          70,
                                                          height:
                                                          70,
                                                          fit: BoxFit
                                                              .cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            company.companyName ??
                                                                'No Name',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .business_center_outlined,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  size:
                                                                  18),
                                                              const SizedBox(
                                                                  width:
                                                                  5),
                                                              Text(company
                                                                  .companyDetails ??
                                                                  'No Details'),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .perm_phone_msg_outlined,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  size:
                                                                  18),
                                                              const SizedBox(
                                                                  width:
                                                                  5),
                                                              Text(company
                                                                  .companyContactUserMobile ??
                                                                  'No Contact'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .arrow_right_alt_outlined,
                                                        color: AppColors
                                                            .primaryColor),
                                                  ],
                                                ),
                                                const SizedBox(
                                                    height: 10),
                                                if (company.supplyInfo !=
                                                    null &&
                                                    company.supplyInfo!
                                                        .isNotEmpty)
                                                  SizedBox(
                                                    height: 90,
                                                    // Enough height for two rows with padding

                                                    child: ListView(
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      children: [
                                                        Wrap(
                                                          direction: Axis
                                                              .vertical,
                                                          // vertical wrap to create 2 rows
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: company
                                                              .supplyInfo!
                                                              .map((e) =>
                                                          e.supplytypeNameLanguage ??
                                                              '')
                                                              .where((name) =>
                                                          name
                                                              .isNotEmpty)
                                                              .map(
                                                                  (name) {
                                                                final bgColor =
                                                                _getRandomColor(
                                                                    name);
                                                                return Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                      8),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      10,
                                                                      vertical:
                                                                      6),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                    bgColor,
                                                                    borderRadius:
                                                                    BorderRadius.circular(6),
                                                                  ),
                                                                  child:
                                                                  Text(
                                                                    name,
                                                                    style:
                                                                    const TextStyle(
                                                                      color:
                                                                      Colors.white,
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      )
                          : Center(child: Text("No Users available"));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),*/
      /*floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                  arguments: {
                    'pageType': AppRoutes.sellEggScreen,
                  },
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
                NavigationHelper.pushNamed(
                  AppRoutes.sellChickScreen,
                  arguments: {
                    'pageType': AppRoutes.sellChickScreen,
                  },
                );
              },
            ),
            Bubble(
              title: "Sell Chicken",
              iconColor: Colors.white,
              bubbleColor: AppColors.primaryColor,
              icon: Icons.currency_rupee_outlined,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                NavigationHelper.pushNamed(
                  AppRoutes.sellChickenScreen,
                  arguments: {
                    'pageType': AppRoutes.sellChickenScreen,
                  },
                );
              },
            ),
            Bubble(
              title: "Lifting Sale",
              iconColor: Colors.white,
              bubbleColor: AppColors.primaryColor,
              icon: Icons.currency_rupee_outlined,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                NavigationHelper.pushNamed(
                  AppRoutes.sellLiftingScreen,
                  arguments: {
                    'pageType': AppRoutes.sellLiftingScreen,
                  },
                );
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
      ),*/
    );
  }
}
