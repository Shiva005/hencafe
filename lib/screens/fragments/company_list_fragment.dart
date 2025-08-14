import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/navigation_helper.dart';
import '../../models/company_providers_model.dart';
import '../../services/services.dart';
import '../../values/app_icons.dart';
import '../../values/app_routes.dart';
import '../image_preview_screen.dart';

class CompanyListFragment extends StatefulWidget {
  final String pageType;

  const CompanyListFragment({Key? key, required this.pageType})
      : super(key: key);

  @override
  State<CompanyListFragment> createState() => _CompanyListFragmentState();
}

class _CompanyListFragmentState extends State<CompanyListFragment> {
  late SharedPreferences prefs;
  late Future<CompanyProvidersModel> companyListData;

  @override
  void initState() {
    super.initState();
    companyListData = _fetchData();
  }

  Future<CompanyProvidersModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.pageType == AppRoutes.companyListScreen) {
      return await AuthServices().getCompanyProvidersList(context, '', 'false');
    } else {
      return await AuthServices().getCompanyProvidersList(context, '', 'true');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: widget.pageType == AppRoutes.companyListScreen
          ? MyAppBar(title: "Companies")
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            companyListData = _fetchData();
          });
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

            final companies = (snapshot.data?.apiResponse ?? [])
                .where((c) => c.companyId != "100")
                .toList();

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
                            },
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          shape: RoundedRectangleBorder(
                            //side: BorderSide(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0.2,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                    ),
                                    alignment: Alignment.center,
                                    child:
                                        (company.attachmentBannerInfo != null &&
                                                company.attachmentBannerInfo!
                                                    .isNotEmpty)
                                            ? Image.network(
                                                company.attachmentBannerInfo![0]
                                                    .attachmentPath!,
                                                fit: BoxFit.fitWidth,
                                              )
                                            : Image.asset(
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                AppIconsData.noImage),
                                  ),
                                  if (company.attachmentLogoInfo != null &&
                                      company.attachmentLogoInfo!.isNotEmpty)
                                    Positioned(
                                      left: 16,
                                      bottom: -50,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (company.attachmentLogoInfo![0]
                                              .attachmentPath!.isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ImagePreviewScreen(
                                                  imageUrl: company
                                                      .attachmentLogoInfo![0]
                                                      .attachmentPath!,
                                                  pageType:
                                                      'CompanyListFragment',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Card(
                                              elevation: 3.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  company.attachmentLogoInfo![0]
                                                      .attachmentPath!,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, bottom: 15),
                                              child: Text(
                                                company.companyName ??
                                                    'No Name',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: company.supplyInfo!
                                            .map((e) =>
                                                e.supplytypeNameLanguage ?? '')
                                            .where((name) => name.isNotEmpty)
                                            .map((name) {
                                          final color =
                                              Utils.getRandomColor(name);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border:
                                                    Border.all(color: color),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: company.addressDetails!
                                            .expand((address) =>
                                                address.locationInfo!)
                                            .map((location) {
                                          var addressAddress = '', zipCode = '';
                                          try {
                                            addressAddress = company
                                                    .addressDetails![index]
                                                    .addressAddress ??
                                                '';
                                            zipCode = company
                                                    .addressDetails![index]
                                                    .addressZipcode ??
                                                '';
                                          } catch (e) {
                                            addressAddress = '';
                                            zipCode = '';
                                          }
                                          final city =
                                              location.cityNameLanguage ?? '';
                                          final state =
                                              location.stateNameLanguage ?? '';
                                          final addressText =
                                              '$addressAddress, $city, $state, $zipCode'
                                                  .trim()
                                                  .replaceAll(
                                                      RegExp(r'^,|,$'), '');

                                          return Container(
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_on_outlined,
                                                    size: 18,
                                                    color: Colors.black54),
                                                SizedBox(width: 5),
                                                Text(
                                                  addressText.isNotEmpty
                                                      ? addressText
                                                      : 'No Address',
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text("No companies available"));
          },
        ),
      ),
    );
  }
}
