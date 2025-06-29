import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/navigation_helper.dart';
import '../../models/company_providers_model.dart';
import '../../services/services.dart';
import '../../values/app_routes.dart';
import '../image_preview_screen.dart';

class HomeFragment2 extends StatefulWidget {
  const HomeFragment2({super.key});

  @override
  State<HomeFragment2> createState() => _HomeFragment2State();
}

class _HomeFragment2State extends State<HomeFragment2>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late SharedPreferences prefs;
  late Future<CompanyProvidersModel> companyListData;

  Future<CompanyProvidersModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getCompanyProvidersList(context, '', 'true');
  }

  Color _getRandomColor(String key) {
    final colors = [
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.brown,
    ];
    int index = key.hashCode % colors.length;
    return colors[index];
  }

  @override
  void initState() {
    companyListData = _fetchData();
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
      body: GestureDetector(
        onTap: () {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          }
        },
        behavior: HitTestBehavior.opaque,
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
                          AppIconsData.colorLiftingSale, "Lifting Sale")),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildDashboardCard(
                          AppIconsData.colorCompanies, "Companies")),
                  SizedBox(width: 20),
                  Expanded(
                      child:
                          _buildDashboardCard(AppIconsData.medicine, "FAQ's")),
                ],
              ),
              SizedBox(height: 20),
              _buildDashboardCard(AppIconsData.colorContact, "Contact Us"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text("Companies",
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
                            : Center(child: Text("No companies available"));
                      },
                    ),
                  ),
                ],
              ),
            ],
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
            } else if (label == 'Companies') {
              NavigationHelper.pushNamed(
                AppRoutes.companyListScreen,
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
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30, width: 30.0, child: Image.asset(icon)),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
