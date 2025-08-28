import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/navigation_helper.dart';
import 'package:hencafe/models/attachment_model.dart';
import 'package:hencafe/services/services.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:hencafe/values/app_theme.dart';
import 'package:hencafe/widget/address_widget.dart';
import 'package:hencafe/widget/attachment_widget.dart';
import 'package:hencafe/widget/favstate_widget.dart';
import 'package:hencafe/widget/membership_widget.dart';
import 'package:hencafe/widget/supplies_widget.dart';
import 'package:hencafe/widget/user_details_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late SharedPreferences prefs;
  late Future<dynamic> profileData;
  String userID = '';
  String pageType = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      pageType = args['pageType'] ?? '';

      SharedPreferences.getInstance().then((sp) {
        prefs = sp;
        if (pageType == AppRoutes.dashboardScreen) {
          userID = prefs.getString(AppStrings.prefUserID) ?? '';
        } else if (pageType == AppRoutes.saleDetailsScreen) {
          userID = args['userID'] ?? '';
        }
        setState(() {
          profileData = _fetchProfile(userID);
        });
      });
    }
  }

  Future<dynamic> _fetchProfile(String userId) async {
    return await AuthServices().getProfile(context, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(
          title: userID == prefs.getString(AppStrings.prefUserID)
              ? "My Profile"
              : "Seller Details",
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          }

          final detailsModel = snapshot.data!;
          final user = detailsModel.apiResponse!.first;

          List<AttachmentInfo> attachments = user.attachmentInfo ?? [];

          return DefaultTabController(
            length: 6,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                /// Profile header
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 150,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(width: 0, color: Colors.white),
                            ),
                            alignment: Alignment.center,
                            child:
                                (user.userBannerImg != null &&
                                    user.userBannerImg!.isNotEmpty)
                                ? GestureDetector(
                                    onTap: () {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.imagePreviewScreen,
                                        arguments: {
                                          'imageUrl': user
                                              .userBannerImg![0]
                                              .attachmentPath!,
                                          'pageType': AppRoutes.myProfileScreen,
                                        },
                                      );
                                    },
                                    child: Image.network(
                                      user.userBannerImg![0].attachmentPath!,
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    AppIconsData.noImage,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        // Profile image + name
                        Positioned(
                          left: 16,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              NavigationHelper.pushNamed(
                                AppRoutes.imagePreviewScreen,
                                arguments: {
                                  'imageUrl':
                                      user.userProfileImg![0].attachmentPath!,
                                  'pageType': AppRoutes.myProfileScreen,
                                },
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Card(
                                  elevation: 3.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: user.userProfileImg!.isNotEmpty
                                        ? Image.network(
                                            user
                                                .userProfileImg![0]
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    user.userFirstName ?? 'No Name',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Tabs
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      isScrollable: true,
                      labelColor: AppColors.primaryColor,
                      indicatorColor: AppColors.primaryColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      tabs: [
                        Tab(text: 'Details'),
                        Tab(text: 'Membership'),
                        Tab(text: 'Supplies'),
                        Tab(text: 'Fav States'),
                        Tab(text: 'Addresses'),
                        Tab(text: 'Attachments'),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  UserDetailsWidget(detailsModel: detailsModel),
                  MembershipWidget(
                    membershipList: user.userMembershipInfo ?? [],
                  ),
                  SuppliesWidget(
                    supplyList: detailsModel.apiResponse![0].supplyInfo ?? [],
                    pageType: AppRoutes.myProfileScreen,
                    userCompanyUUID: user.userUuid,
                    createdByUserID: user.userId,
                  ),
                  FavouriteStateWidget(
                    favStateList: user.userFavouriteStateInfo ?? [],
                    userID: user.userId ?? '',
                  ),
                  AddressWidget(
                    addressList: user.addressDetails ?? [],
                    pageType: AppRoutes.myProfileScreen,
                  ),
                  AttachmentWidget(
                    attachments: attachments,
                    userId: user.userId ?? '',
                    currentUserId: prefs.getString(AppStrings.prefUserID) ?? '',
                    referenceFrom: "USER",
                    referenceUUID: user.userUuid ?? '',
                    onDelete: (index) {
                      showDeleteAttachmentDialog(
                        context: context,
                        index: index,
                        attachment: attachments[index],
                        attachments: attachments,
                        onUpdate: () => setState(() {}),
                      );
                    },
                    index: 0,
                    pageType: AppRoutes.myProfileScreen,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteAttachmentDialog({
    required BuildContext context,
    required int index,
    required AttachmentInfo attachment,
    required List<AttachmentInfo> attachments,
    required VoidCallback onUpdate,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.warning,
      dialogBackgroundColor: Colors.white,
      titleTextStyle: AppTheme.appBarText,
      title: 'Are you sure you want to delete this file?',
      btnCancelOnPress: () {},
      btnCancelText: 'Cancel',
      btnOkOnPress: () async {
        var res = await AuthServices().attachmentDelete(
          context,
          attachment.attachmentId!,
          attachment.attachmentPath!,
        );
        if (res.apiResponse![0].responseStatus == true) {
          attachments.removeAt(index);
          onUpdate();
        }
      },
      btnOkText: 'Yes',
      btnOkColor: Colors.yellow.shade700,
    ).show();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}
