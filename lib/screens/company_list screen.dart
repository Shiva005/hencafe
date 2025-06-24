import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/company_providers_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: 'Company List'),
      ),
      body: FutureBuilder<CompanyProvidersModel>(
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
                              if (company.attachmentInfo != null &&
                                  company.attachmentInfo!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    company.attachmentInfo![0].attachmentPath!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.business,
                                            color: AppColors.primaryColor,
                                            size: 18),
                                        SizedBox(width: 5.0),
                                        Text(company.companyName ?? 'No Name'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.business_center_outlined,
                                            color: AppColors.primaryColor,
                                            size: 18),
                                        SizedBox(width: 5.0),
                                        Text(company.companyDetails ??
                                            'No Details'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.phone_android,
                                            color: AppColors.primaryColor,
                                            size: 18),
                                        SizedBox(width: 5.0),
                                        Text(company.companyContactUserMobile ??
                                            'No Contact'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.rice_bowl,
                                            color: AppColors.primaryColor,
                                            size: 18),
                                        SizedBox(width: 5.0),
                                        if (company.supplyInfo != null &&
                                            company.supplyInfo!.isNotEmpty)
                                          Text(
                                            company.supplyInfo!
                                                .map((e) =>
                                                    e.supplytypeNameLanguage ??
                                                    '')
                                                .where(
                                                    (name) => name.isNotEmpty)
                                                .join(', '),
                                          )
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
    );
  }
}
