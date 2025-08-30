import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    profileListData = _fetchData();
  }

  Future<ProfileModel?> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.pageType == AppRoutes.sellersListScreen) {
      return await AuthServices().getUsers(context, 'false');
    } else {
      return await AuthServices().getUsers(context, 'true');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: widget.pageType == AppRoutes.sellersListScreen
          ? MyAppBar(title: "Sellers")
          : null,
      body: RefreshIndicator(
        onRefresh: () {
          return _fetchData();
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

            final profiles = snapshot.data?.apiResponse ?? [];
            return profiles.isNotEmpty
                ? ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final seller = profiles[index];
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
                                        (seller.userBannerImg != null &&
                                            seller.userBannerImg!.isNotEmpty)
                                        ? Image.network(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            height: 100,
                                            seller
                                                .userBannerImg![0]
                                                .attachmentPath!,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : Image.asset(
                                            fit: BoxFit.fitWidth,
                                            AppIconsData.noImage,
                                          ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    bottom: -50,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (seller
                                            .userProfileImg![0]
                                            .attachmentPath!
                                            .isNotEmpty) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.imagePreviewScreen,
                                            arguments: {
                                              'imageUrl': seller
                                                  .userProfileImg![0]
                                                  .attachmentPath!,
                                              'pageType': 'SellerListFragment',
                                            },
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
                                              child:
                                                  (seller.userProfileImg !=
                                                          null &&
                                                      seller
                                                          .userProfileImg!
                                                          .isNotEmpty)
                                                  ? Image.network(
                                                      seller
                                                          .userProfileImg![0]
                                                          .attachmentPath!,
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                      AppIconsData.noImage,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5.0,
                                              bottom: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${seller.userFirstName} ${seller.userLastName}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                if (seller.userIsVerfied == "Y")
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        size: 18,
                                                        Icons.verified_outlined,
                                                        color: Colors
                                                            .green
                                                            .shade700,
                                                      ),
                                                    ],
                                                  ),
                                              ],
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
                                        children: seller.supplyInfo!
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
                                                    style: TextStyle(
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: seller.addressDetails!
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
                  )
                : const Center(child: Text("No Sellers available"));
          },
        ),
      ),
    );
  }
}
