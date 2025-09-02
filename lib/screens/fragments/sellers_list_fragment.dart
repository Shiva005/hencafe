import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../helpers/navigation_helper.dart';
import '../../models/profile_model.dart';
import '../../services/services.dart';
import '../../utils/appbar_widget.dart';
import '../../utils/utils.dart';
import '../../values/app_routes.dart';

class SellerListFragment extends StatefulWidget {
  final String pageType;

  const SellerListFragment({Key? key, required this.pageType})
    : super(key: key);

  @override
  State<SellerListFragment> createState() => _SellerListFragmentState();
}

class _SellerListFragmentState extends State<SellerListFragment> {
  late SharedPreferences prefs;
  late Future<ProfileModel?> profileListData;

  final TextEditingController _searchController = TextEditingController();
  List<ApiResponse> _allSellers = []; // keep all sellers
  List<ApiResponse> _filteredSellers = []; // filtered sellers

  @override
  void initState() {
    super.initState();
    profileListData = _fetchData();

    _searchController.addListener(_onSearchChanged);
  }

  Future<ProfileModel?> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    ProfileModel? result;
    if (widget.pageType == AppRoutes.sellersListScreen) {
      result = await AuthServices().getUsers(context, 'false');
    } else {
      result = await AuthServices().getUsers(context, 'true');
    }

    if (result != null && result.apiResponse != null) {
      _allSellers = result.apiResponse!;
      _filteredSellers = _allSellers; // default all
    }

    return result;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSellers = _allSellers.where((seller) {
        final fullName =
            "${seller.userFirstName ?? ''} ${seller.userLastName ?? ''}"
                .toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: widget.pageType == AppRoutes.sellersListScreen
          ? MyAppBar(title: "Sellers")
          : null,
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Seller by Name...",
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _fetchData();
                setState(() {
                  _searchController.text = "";
                });
                return;
              },
              child: FutureBuilder<ProfileModel?>(
                future: profileListData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  return _filteredSellers.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filteredSellers.length,
                          itemBuilder: (context, index) {
                            final seller = _filteredSellers[index];
                            // ✅ your seller card code here
                            return _buildSellerCard(seller, context);
                          },
                        )
                      : const Center(child: Text("No Sellers available"));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(ApiResponse seller, BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.pushNamed(
          AppRoutes.myProfileScreen,
          arguments: {
            'pageType': AppRoutes.saleDetailsScreen,
            'userID': seller.userId.toString(),
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.2,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 3, color: Colors.white),
                  ),
                  alignment: Alignment.center,
                  child:
                      (seller.userBannerImg != null &&
                          seller.userBannerImg!.isNotEmpty)
                      ? Image.network(
                          seller.userBannerImg![0].attachmentPath!,
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(AppIconsData.noImage, fit: BoxFit.fitWidth),
                ),

                // Profile + Name
                Positioned(
                  left: 16,
                  bottom: -50,
                  child: Row(
                    children: [
                      Card(
                        elevation: 3.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child:
                              (seller.userProfileImg != null &&
                                  seller.userProfileImg!.isNotEmpty)
                              ? Image.network(
                                  seller.userProfileImg![0].attachmentPath!,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 200,
                          child: TextScroll(
                            "${seller.userFirstName ?? ''} ${seller.userLastName ?? ''}",
                            style: const TextStyle(fontSize: 18),
                            intervalSpaces: 10,
                            velocity: const Velocity(
                              pixelsPerSecond: Offset(30, 0),
                            ),
                            fadedBorder: true,
                            fadeBorderVisibility: FadeBorderVisibility.auto,
                            fadeBorderSide: FadeBorderSide.both,
                          ),
                        ),
                      ),
                      if (seller.userIsVerfied == "Y")
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 20.0),
                          child: Icon(
                            Icons.verified_outlined,
                            size: 18,
                            color: Colors.green.shade700,
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
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: seller.supplyInfo!
                          .map((e) => e.supplytypeNameLanguage ?? '')
                          .where((name) => name.isNotEmpty)
                          .map((name) {
                            final color = Utils.getRandomColor(name);
                            return Container(
                              margin: const EdgeInsets.only(left: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: color),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Address
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: seller.addressDetails!.expand((address) {
                        final addressAddress = address.addressAddress ?? '';
                        final zipCode = address.addressZipcode ?? '';

                        return address.locationInfo!.map((location) {
                          final city = location.cityNameLanguage ?? '';
                          final state = location.stateNameLanguage ?? '';
                          final addressText =
                              '$addressAddress, $city, $state, $zipCode'
                                  .replaceAll(RegExp(r'^,|,$'), '');

                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  addressText.isNotEmpty
                                      ? addressText
                                      : 'No Address',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          );
                        });
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
  }
}
