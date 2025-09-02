import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../helpers/navigation_helper.dart';
import '../../models/company_providers_model.dart';
import '../../services/services.dart';
import '../../values/app_icons.dart';
import '../../values/app_routes.dart';

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
  List<ApiResponse> _allCompanies = []; // keep all companies
  List<ApiResponse> _filteredCompanies = []; // filtered companies
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    companyListData = _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<CompanyProvidersModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    CompanyProvidersModel result;
    if (widget.pageType == AppRoutes.companyListScreen) {
      result = await AuthServices().getCompanyProvidersList(
        context,
        '',
        'false',
      );
    } else {
      result = await AuthServices().getCompanyProvidersList(
        context,
        '',
        'true',
      );
    }

    if (result.apiResponse != null) {
      _allCompanies = result.apiResponse!
          .where((c) => c.companyId != "100")
          .toList();
      _filteredCompanies = _allCompanies;
    }

    return result;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCompanies = _allCompanies.where((company) {
        final name = company.companyName?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: widget.pageType == AppRoutes.companyListScreen
          ? MyAppBar(title: "Companies")
          : null,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Company by Name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Company List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  companyListData = _fetchData();
                  _searchController.text = "";
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

                  // Populate _allCompanies and _filteredCompanies if not already done
                  if (snapshot.hasData && _allCompanies.isEmpty) {
                    final companies = (snapshot.data?.apiResponse ?? [])
                        .where((c) => c.companyId != "100")
                        .toList();
                    _allCompanies = companies;
                    _filteredCompanies = companies;
                  }

                  if (_filteredCompanies.isEmpty) {
                    return const Center(child: Text("No companies available"));
                  }
                  return ListView.builder(
                    itemCount: _filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = _filteredCompanies[index];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GestureDetector(
                        onTap: () {
                          NavigationHelper.pushNamed(
                            AppRoutes.companyDetailsScreen,
                            arguments: {
                              'companyUUID': company.companyUuid,
                              'companyPromotionStatus': 'true',
                            },
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0.2,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Banner & Logo
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child:
                                        (company.attachmentBannerInfo != null &&
                                            company
                                                .attachmentBannerInfo!
                                                .isNotEmpty)
                                        ? Image.network(
                                            company
                                                .attachmentBannerInfo![0]
                                                .attachmentPath!,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            height: 100,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : Image.asset(
                                            AppIconsData.noImage,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    bottom: -50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Card(
                                          elevation: 3.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child:
                                                (company.attachmentLogoInfo !=
                                                        null &&
                                                    company
                                                        .attachmentLogoInfo!
                                                        .isNotEmpty)
                                                ? Image.network(
                                                    company
                                                        .attachmentLogoInfo![0]
                                                        .attachmentPath!,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    AppIconsData.noImage,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 15,
                                          ),
                                          width: 250,
                                          child: TextScroll(
                                            company.companyName ?? 'No Name',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                            intervalSpaces: 10,
                                            velocity: const Velocity(
                                              pixelsPerSecond: Offset(30, 0),
                                            ),
                                            fadedBorder: true,
                                            fadeBorderVisibility:
                                                FadeBorderVisibility.auto,
                                            fadeBorderSide: FadeBorderSide.both,
                                          ),
                                        ),
                                      ],
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
                                    // Supply Info
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: company.supplyInfo!
                                            .map(
                                              (e) =>
                                                  e.supplytypeNameLanguage ??
                                                  '',
                                            )
                                            .where((name) => name.isNotEmpty)
                                            .map((name) {
                                              final color =
                                                  Utils.getRandomColor(name);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                      color: color,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    name,
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Address Info
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: company.addressDetails!
                                            .asMap()
                                            .entries
                                            .expand((entry) {
                                              final address = entry.value;
                                              final addressAddress =
                                                  address.addressAddress ?? '';
                                              final zipCode =
                                                  address.addressZipcode ?? '';

                                              return address.locationInfo!.map((
                                                location,
                                              ) {
                                                final city =
                                                    location.cityNameLanguage ??
                                                    '';
                                                final state =
                                                    location
                                                        .stateNameLanguage ??
                                                    '';
                                                final addressText =
                                                    '$addressAddress, $city, $state, $zipCode'
                                                        .trim()
                                                        .replaceAll(
                                                          RegExp(r'^,|,$'),
                                                          '',
                                                        );

                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 18,
                                                        color: Colors.black54,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        addressText.isNotEmpty
                                                            ? addressText
                                                            : 'No Address',
                                                        style: const TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            })
                                            .toList(),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
