import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/company_providers_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import 'image_preview_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  late SharedPreferences prefs;
  late Future<CompanyProvidersModel> companyListData;

  @override
  void initState() {
    super.initState();
    companyListData = _fetchData();
  }

  Future<CompanyProvidersModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getCompanyProvidersList(context, '', '');
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
    // Pick based on hash to keep color consistent per item
    int index = key.hashCode % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: 'Company List'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _fetchData();
        },
        child: FutureBuilder<CompanyProvidersModel>(
          future: companyListData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final companies = snapshot.data?.apiResponse ?? [];
            return companies.isNotEmpty
                ? ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return GestureDetector(
                        onTap: () {
                          NavigationHelper.pushNamed(
                              AppRoutes.companyDetailsScreen,
                              arguments: {
                                'companyUUID': company.companyUuid,
                                'companyPromotionStatus': 'true'
                              });
                        },
                        child: Card(
                          elevation: 0.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppColors.primaryColor, width: 1),
                            // Change color here
                            borderRadius: BorderRadius.circular(
                                8.0), // Optional: Adjust border radius
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (company.attachmentLogoInfo![0]
                                        .attachmentPath!.isNotEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ImagePreviewScreen(
                                                imageUrl: company
                                                    .attachmentLogoInfo![0]
                                                    .attachmentPath!),
                                          ));
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: company.attachmentLogoInfo != null &&
                                            company
                                                .attachmentLogoInfo!.isNotEmpty
                                        ? Image.network(
                                            company.attachmentLogoInfo![0]
                                                .attachmentPath!,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            AppIconsData
                                                .noImage, // your fallback asset image
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.companyName ?? 'No Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.business_center_outlined,
                                              color: Colors.grey.shade600,
                                              size: 18),
                                          SizedBox(width: 5.0),
                                          Text(company.companyDetails ??
                                              'No Details'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.perm_phone_msg_outlined,
                                              color: Colors.grey.shade600,
                                              size: 18),
                                          SizedBox(width: 5.0),
                                          Text(company
                                                  .companyContactUserMobile ??
                                              'No Contact'),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (company.supplyInfo != null &&
                                              company.supplyInfo!.isNotEmpty)
                                            Expanded(
                                              child: Wrap(
                                                spacing: 8.0,
                                                runSpacing: 6.0,
                                                children: company.supplyInfo!
                                                    .map((e) =>
                                                        e.supplytypeNameLanguage ??
                                                        '')
                                                    .where((name) =>
                                                        name.isNotEmpty)
                                                    .map((name) {
                                                  final bgColor =
                                                      _getRandomColor(name);
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: bgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      name,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_right_alt_outlined,
                                    color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No companies available"));
          },
        ),
      ),
    );
  }
}
