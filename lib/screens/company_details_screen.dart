import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/company_providers_model.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:hencafe/widget/address_widget.dart';
import 'package:hencafe/widget/company_details_widget.dart';
import 'package:hencafe/widget/supplies_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/attachment_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_icons.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import '../widget/attachment_widget.dart';
import 'image_preview_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late SharedPreferences prefs;
  late Future<CompanyProvidersModel> companyData;
  DateTime selectedDate = DateTime.now();
  String referenceUUID = '';
  String companyPromotionStatus = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (referenceUUID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      referenceUUID = args['companyUUID'] ?? '';
      companyPromotionStatus = args['companyPromotionStatus'] ?? '';
      companyData = _fetchCompanyDetails(referenceUUID, companyPromotionStatus);
    }
  }

  Future<CompanyProvidersModel> _fetchCompanyDetails(
    String referenceUUID,
    String companyPromotionStatus,
  ) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getCompanyProvidersList(
      context,
      referenceUUID,
      companyPromotionStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: 'Company Details'),
      ),
      body: FutureBuilder<dynamic>(
        future: companyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          }

          final detailsModel = snapshot.data!;
          final company = detailsModel.apiResponse![0] ?? [];
          final userInfo = detailsModel.apiResponse![0].userBasicInfo ?? [];
          List<AttachmentInfo> attachments = company.attachmentInfo ?? [];

          for (var address
              in detailsModel.apiResponse![0].addressDetails ?? []) {
            if (address.attachmentInfo != null &&
                address.attachmentInfo!.isNotEmpty) {
              attachments.addAll(address.attachmentInfo!);
            }
          }

          // Wrap everything in DefaultTabController & NestedScrollView to enable sticky tabs
          return DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Your header card inside a sliver
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
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
                                    (company.attachmentBannerInfo != null &&
                                        company
                                            .attachmentBannerInfo!
                                            .isNotEmpty)
                                    ? Image.network(
                                        company
                                            .attachmentBannerInfo![0]
                                            .attachmentPath!,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Image.asset(
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        AppIconsData.noImage,
                                      ),
                              ),
                              if (company.attachmentLogoInfo != null &&
                                  company.attachmentLogoInfo!.isNotEmpty)
                                Positioned(
                                  left: 16,
                                  bottom: -50,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (company
                                          .attachmentLogoInfo![0]
                                          .attachmentPath!
                                          .isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ImagePreviewScreen(
                                              imageUrl: company
                                                  .attachmentLogoInfo![0]
                                                  .attachmentPath!,
                                              pageType: AppRoutes
                                                  .companyDetailsScreen,
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
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: Image.network(
                                              company
                                                  .attachmentLogoInfo![0]
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
                                            left: 5.0,
                                            bottom: 15,
                                          ),
                                          child: Text(
                                            company.companyName ?? 'No Name',
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
                        ],
                      ),
                    ),
                  ),
                ),

                // Pinned TabBar inside SliverPersistentHeader
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
                        Tab(text: 'Supplies'),
                        Tab(text: 'Addresses'),
                        Tab(text: 'Attachments'),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  CompanyDetailsWidget(
                    detailsModel: detailsModel,
                    userInfo: userInfo,
                    prefs: prefs,
                  ),

                  SuppliesWidget(
                    supplyList: detailsModel.apiResponse![0].supplyInfo ?? [],
                    pageType: AppRoutes.companyDetailsScreen,
                    userCompanyUUID: referenceUUID,
                  ),

                  AddressWidget(
                    addressList: detailsModel.apiResponse![0].addressDetails!
                        .toList(),
                  ),

                  AttachmentWidget(
                    attachments: attachments,
                    userId:
                        detailsModel.apiResponse![0].userBasicInfo![0].userId ??
                        '',
                    currentUserId: prefs.getString(AppStrings.prefUserID) ?? '',
                    referenceFrom: "COMPANY",
                    referenceUUID: referenceUUID,
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
                    pageType: AppRoutes.companyDetailsScreen,
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
        var attachmentDeleteRes = await AuthServices().attachmentDelete(
          context,
          attachment.attachmentId!,
          attachment.attachmentPath!,
        );

        if (attachmentDeleteRes.apiResponse![0].responseStatus == true) {
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
    return Container(
      color: Colors.white, // background color for tab bar
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
