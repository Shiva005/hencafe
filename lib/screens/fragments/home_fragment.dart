import 'package:flutter/material.dart';
import 'package:hencafe/models/attachment_model.dart';
import 'package:hencafe/screens/fragments/company_list_fragment.dart';
import 'package:hencafe/screens/fragments/more_fragment.dart';
import 'package:hencafe/screens/fragments/sale_fragment.dart';
import 'package:hencafe/screens/fragments/sellers_list_fragment.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/services.dart';
import 'app_status_fragment.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: SaleFragment(),
          item: ItemConfig(
            activeForegroundColor: AppColors.primaryColor,
            icon: Icon(Icons.currency_rupee),
            title: "Price",
          ),
        ),
        PersistentTabConfig(
          screen: Home(),
          item: ItemConfig(
            activeForegroundColor: AppColors.primaryColor,
            icon: Icon(Icons.info_outline),
            title: "Info",
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
  bool isLoading = true;
  late List<AttachmentInfo> attachments = [];
  late final contactData;

  @override
  void initState() {
    super.initState();
    fetchStatusHistory();
  }

  Future<void> fetchStatusHistory() async {
    prefs = await SharedPreferences.getInstance();
    setState(() => isLoading = true);
    contactData = await AuthServices().getContactHistory(
      context,
      "APP_STATUS",
      "",
    );

    setState(() {
      attachments = contactData.apiResponse![0].attachmentInfo ?? [];

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primaryColor,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Status'),
                Tab(text: 'Company'),
                Tab(text: 'Sellers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AppStatusScreen(),
                  CompanyListFragment(pageType: "HomeFragment"),
                  SellerListFragment(pageType: "SellerFragment"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
