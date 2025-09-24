import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/attachment_model.dart';
import 'package:hencafe/models/chicken_price_model.dart';
import 'package:hencafe/models/lifting_price_model.dart';
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/widget/attachment_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/chick_price_model.dart';
import '../models/egg_price_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class SaleDetailsScreen extends StatefulWidget {
  const SaleDetailsScreen({super.key});

  @override
  State<SaleDetailsScreen> createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  late SharedPreferences prefs;
  late Future<EggPriceModel> eggPriceData;
  late Future<ChickPriceModel> chickPriceData;
  late Future<ChickenPriceModel> chickenPriceData;
  late Future<LiftingPriceModel> liftingSaleData;
  DateTime selectedDate = DateTime.now();
  String saleID = '';
  String pageType = '';
  String _packageName = '';
  String referenceUUID = "", referenceFrom = "";

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> captureAndShare() async {
    try {
      Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/screenshot.png';
        File imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        await Share.shareXFiles([
          XFile(imagePath),
        ], text: '${AppStrings.shareText}$_packageName');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture screenshot')),
        );
      }
    } catch (e) {
      print("Error capturing or sharing: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (saleID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      saleID = args['saleID'] ?? '';
      pageType = args['pageType'] ?? '';
      loadDataPackageName();
      if (pageType == AppRoutes.eggPriceScreen) {
        eggPriceData = _fetchEggData(Utils.formatDate(selectedDate), saleID);
      } else if (pageType == AppRoutes.chickPriceScreen) {
        chickPriceData = _fetchChickData(
          Utils.formatDate(selectedDate),
          saleID,
        );
      } else if (pageType == AppRoutes.chickenPriceScreen) {
        chickenPriceData = _fetchChickenData(
          Utils.formatDate(selectedDate),
          saleID,
        );
      } else if (pageType == AppRoutes.liftingPriceScreen) {
        liftingSaleData = _fetchLiftingSaleData(
          Utils.formatDate(selectedDate),
          saleID,
        );
      }
    }
  }

  Future<LiftingPriceModel> _fetchLiftingSaleData(
    String selectedDate,
    String eggSaleID,
  ) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getLiftingPriceList(
      context,
      eggSaleID,
      selectedDate,
      selectedDate,
      '',
    );
  }

  Future<EggPriceModel> _fetchEggData(
    String selectedDate,
    String eggSaleID,
  ) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getEggPriceList(
      context,
      eggSaleID,
      selectedDate,
      selectedDate,
      '',
    );
  }

  Future<ChickPriceModel> _fetchChickData(
    String selectedDate,
    String eggSaleID,
  ) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getChickPriceList(
      context,
      eggSaleID,
      selectedDate,
      selectedDate,
      '',
    );
  }

  Future<ChickenPriceModel> _fetchChickenData(
    String selectedDate,
    String eggSaleID,
  ) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getChickenPriceList(
      context,
      eggSaleID,
      selectedDate,
      selectedDate,
      '',
    );
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    if (pageType == AppRoutes.eggPriceScreen) {
      eggPriceData = AuthServices().getEggPriceList(
        context,
        saleID,
        Utils.formatDate(selectedDate),
        Utils.formatDate(selectedDate),
        '',
      );
    } else if (pageType == AppRoutes.chickPriceScreen) {
      chickPriceData = AuthServices().getChickPriceList(
        context,
        saleID,
        Utils.formatDate(selectedDate),
        Utils.formatDate(selectedDate),
        '',
      );
    } else if (pageType == AppRoutes.chickenPriceScreen) {
      chickenPriceData = AuthServices().getChickenPriceList(
        context,
        saleID,
        Utils.formatDate(selectedDate),
        Utils.formatDate(selectedDate),
        '',
      );
    } else if (pageType == AppRoutes.liftingPriceScreen) {
      liftingSaleData = AuthServices().getLiftingPriceList(
        context,
        saleID,
        Utils.formatDate(selectedDate),
        Utils.formatDate(selectedDate),
        '',
      );
    }
    setState(() {}); // Refresh UI after loading data
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: MyAppBar(
                    title: pageType == AppRoutes.eggPriceScreen
                        ? 'Egg Sale Details'
                        : pageType == AppRoutes.chickPriceScreen
                        ? 'Chick Sale Details'
                        : pageType == AppRoutes.liftingPriceScreen
                        ? 'Lifting Sale Details'
                        : 'Chicken Sale Details',
                  ),
                ),
                GestureDetector(
                  onTap: captureAndShare,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0, top: 20),
                    child: Icon(Icons.share, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: pageType == AppRoutes.eggPriceScreen
              ? eggPriceData
              : pageType == AppRoutes.chickPriceScreen
              ? chickPriceData
              : pageType == AppRoutes.liftingPriceScreen
              ? liftingSaleData
              : chickenPriceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found.'));
            }

            final priceModel = snapshot.data!;
            if (pageType == AppRoutes.eggPriceScreen) {
              referenceUUID = priceModel.apiResponse![0].eggsaleUuid.toString();
              referenceFrom = "EGG_SALE";
            } else if (pageType == AppRoutes.chickPriceScreen) {
              referenceUUID = priceModel.apiResponse![0].chicksaleUuid
                  .toString();
              referenceFrom = "CHICK_SALE";
            } else if (pageType == AppRoutes.chickenPriceScreen) {
              referenceUUID = priceModel.apiResponse![0].chickensaleUuid
                  .toString();
              referenceFrom = "CHICKEN_SALE";
            } else if (pageType == AppRoutes.liftingPriceScreen) {
              referenceUUID = priceModel.apiResponse![0].liftingsaleUuid
                  .toString();
              referenceFrom = "LIFTING_SALE";
            }

            final List<AttachmentInfo> attachments =
                priceModel.apiResponse![0].attachmentInfo ?? [];
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      labelColor: AppColors.primaryColor,
                      indicatorColor: AppColors.primaryColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      tabs: [
                        Tab(text: 'Details'),
                        Tab(text: 'Attachments'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 6,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.tag,
                                        'Sale ID',
                                        '#${priceModel.apiResponse![0].eggsaleId ?? ''}',
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.tag,
                                        'Sale ID',
                                        '#${priceModel.apiResponse![0].chicksaleId ?? ''}',
                                      ),
                                    if (pageType ==
                                        AppRoutes.chickenPriceScreen)
                                      buildRow(
                                        Icons.tag,
                                        'Sale ID',
                                        '#${priceModel.apiResponse![0].chickensaleId ?? ''}',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.tag,
                                        'Sale ID',
                                        '#${priceModel.apiResponse![0].liftingsaleId ?? ''}',
                                      ),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.currency_rupee,
                                        'Price',
                                        '${priceModel.apiResponse![0].eggsaleCost ?? ''} rs/egg',
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.currency_rupee,
                                        'Price',
                                        '${priceModel.apiResponse![0].chicksaleCost ?? ''} rs/chick',
                                      ),
                                    if (pageType ==
                                        AppRoutes.chickenPriceScreen)
                                      buildRow(
                                        Icons.currency_rupee,
                                        'Price',
                                        '${priceModel.apiResponse![0].farmLiveBirdCost ?? ''} Rs/kg',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.currency_rupee,
                                        'Price',
                                        '${priceModel.apiResponse![0].liftingsaleCostPerKg ?? ''} Rs/kg',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.cabin,
                                        'Total Birds',
                                        '${priceModel.apiResponse![0].liftingsaleTotalBirds ?? ''} Total Birds',
                                      ),
                                    buildRow(
                                      Icons.cabin,
                                      'Bird Breed',
                                      priceModel
                                              .apiResponse![0]
                                              .birdBreedInfo
                                              ?.first
                                              .birdbreedNameLanguage ??
                                          '',
                                    ),
                                    if (pageType !=
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.business,
                                        'Company Name',
                                        priceModel
                                                .apiResponse![0]
                                                .companyBasicInfo
                                                ?.first
                                                .companyNameLanguage ??
                                            '',
                                      ),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.egg,
                                        'Is Hatching Eggs?',
                                        priceModel
                                                    .apiResponse![0]
                                                    .isHatchingEgg ==
                                                'Y'
                                            ? 'Yes'
                                            : 'No',
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.vaccines,
                                        'Is Vaccinated?',
                                        priceModel
                                                    .apiResponse![0]
                                                    .isVaccinated ==
                                                'Y'
                                            ? 'Yes'
                                            : 'No',
                                      ),
                                    if (pageType ==
                                            AppRoutes.chickPriceScreen ||
                                        pageType ==
                                            AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.cake,
                                        pageType == AppRoutes.liftingPriceScreen
                                            ? 'Bird Age'
                                            : 'Chick age',
                                        '${priceModel.apiResponse![0].birdAgeInDays ?? ''} Days',
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.monitor_weight_outlined,
                                        'Chick weight',
                                        '${priceModel.apiResponse![0].birdWeightInGrams ?? ''} Grams',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.monitor_weight_outlined,
                                        'Bird weight',
                                        '${priceModel.apiResponse![0].birdWeightInKg ?? ''} Kg',
                                      ),
                                    if (pageType !=
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.card_giftcard,
                                        'Is Special Sell?',
                                        priceModel
                                                    .apiResponse![0]
                                                    .isSpecialSale ==
                                                'Y'
                                            ? 'Yes'
                                            : 'No',
                                      ),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.calendar_today_outlined,
                                        'Sale Start',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .eggsaleEffectFrom ??
                                              '',
                                        ),
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.calendar_today_outlined,
                                        'Sale Start',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .chicksaleEffectFrom ??
                                              '',
                                        ),
                                      ),
                                    if (pageType ==
                                        AppRoutes.chickenPriceScreen)
                                      buildRow(
                                        Icons.calendar_today_outlined,
                                        'Sale Start',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .chickensaleEffectFrom ??
                                              '',
                                        ),
                                      ),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.calendar_month,
                                        'Sale End',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .eggsaleEffectTo ??
                                              '',
                                        ),
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.calendar_month,
                                        'Sale End',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .chickaleEffectTo ??
                                              '',
                                        ),
                                      ),
                                    if (pageType ==
                                        AppRoutes.chickenPriceScreen)
                                      buildRow(
                                        Icons.calendar_month,
                                        'Sale End',
                                        Utils.threeLetterDateFormatted(
                                          priceModel
                                                  .apiResponse![0]
                                                  .chickensaleEffectTo ??
                                              '',
                                        ),
                                      ),
                                    if (pageType !=
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.pin_drop,
                                        'Address',
                                        '${priceModel.apiResponse![0].addressDetails?.first.cityNameLanguage ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.stateNameLanguage ?? ''}',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.pin_drop,
                                        'Address',
                                        '${priceModel.apiResponse![0].liftingsaleAddress ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.cityNameLanguage ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.stateNameLanguage ?? ''}',
                                      ),
                                    if (pageType == AppRoutes.eggPriceScreen)
                                      buildRow(
                                        Icons.message_outlined,
                                        'Comment',
                                        '${priceModel.apiResponse![0].eggsaleComment ?? ''}',
                                      ),
                                    if (pageType == AppRoutes.chickPriceScreen)
                                      buildRow(
                                        Icons.message_outlined,
                                        'Comment',
                                        '${priceModel.apiResponse![0].chicksaleComment ?? ''}',
                                      ),
                                    if (pageType ==
                                        AppRoutes.chickenPriceScreen)
                                      buildRow(
                                        Icons.message_outlined,
                                        'Comment',
                                        '${priceModel.apiResponse![0].chickensaleComment ?? ''}',
                                      ),
                                    if (pageType ==
                                        AppRoutes.liftingPriceScreen)
                                      buildRow(
                                        Icons.message_outlined,
                                        'Comment',
                                        '${priceModel.apiResponse![0].liftingsaleComment ?? ''}',
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          // Change Banner Image
                                          if (pageType !=
                                              AppRoutes.liftingPriceScreen)
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              NavigationHelper.pushNamed(
                                                AppRoutes.companyDetailsScreen,
                                                arguments: {
                                                  'companyUUID': priceModel
                                                      .apiResponse![0]
                                                      .companyBasicInfo![0]
                                                      .companyUuid,
                                                  'companyPromotionStatus':
                                                      'false',
                                                },
                                              );
                                            },
                                            label: const Text(
                                              "View Company Details",
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.pink,
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(
                                                double.infinity,
                                                35,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),

                                          // Change Profile Image
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              NavigationHelper.pushNamed(
                                                AppRoutes.myProfileScreen,
                                                arguments: {
                                                  'pageType': AppRoutes
                                                      .saleDetailsScreen,
                                                  'userID': priceModel
                                                      .apiResponse![0]
                                                      .userBasicInfo![0]
                                                      .userId
                                                      .toString(),
                                                },
                                              );
                                            },
                                            label: const Text(
                                              "View Seller Details",
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(
                                                double.infinity,
                                                35,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          if (priceModel
                                                  .apiResponse![0]
                                                  .userBasicInfo![0]
                                                  .userId ==
                                              prefs.getString(
                                                AppStrings.prefUserID,
                                              ))
                                            ElevatedButton(
                                              onPressed: () {
                                                if (pageType ==
                                                    AppRoutes.eggPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.uploadFileScreen,
                                                    arguments: {
                                                      'reference_from':
                                                          'EGG_SALE',
                                                      'reference_uuid':
                                                          referenceUUID,
                                                      'isSingleFilePick': false,
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .chickPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.uploadFileScreen,
                                                    arguments: {
                                                      'reference_from':
                                                          'CHICK_SALE',
                                                      'reference_uuid':
                                                          referenceUUID,
                                                      'isSingleFilePick': false,
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .chickenPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.uploadFileScreen,
                                                    arguments: {
                                                      'reference_from':
                                                          'CHICKEN_SALE',
                                                      'reference_uuid':
                                                          referenceUUID,
                                                      'isSingleFilePick': false,
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .liftingPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.uploadFileScreen,
                                                    arguments: {
                                                      'reference_from':
                                                          'LIFTING_SALE',
                                                      'reference_uuid':
                                                          referenceUUID,
                                                      'isSingleFilePick': false,
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  35,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text("Add Attachment"),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.arrow_right_alt,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (priceModel
                                                  .apiResponse![0]
                                                  .userBasicInfo![0]
                                                  .userId ==
                                              prefs.getString(
                                                AppStrings.prefUserID,
                                              ))
                                            ElevatedButton(
                                              onPressed: () {
                                                if (pageType ==
                                                    AppRoutes.eggPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.sellEggScreen,
                                                    arguments: {
                                                      'eggPriceModel':
                                                          priceModel
                                                              .apiResponse![0],
                                                      'pageType':
                                                          "eggSaleDetails",
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .chickPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.sellChickScreen,
                                                    arguments: {
                                                      'chickPriceModel':
                                                          priceModel
                                                              .apiResponse![0],
                                                      'pageType':
                                                          "chickSaleDetails",
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .chickenPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.sellChickenScreen,
                                                    arguments: {
                                                      'chickenPriceModel':
                                                          priceModel
                                                              .apiResponse![0],
                                                      'pageType':
                                                          "chickenSaleDetails",
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                } else if (pageType ==
                                                    AppRoutes
                                                        .liftingPriceScreen) {
                                                  NavigationHelper.pushNamed(
                                                    AppRoutes.sellLiftingScreen,
                                                    arguments: {
                                                      'liftingPriceModel':
                                                          priceModel
                                                              .apiResponse![0],
                                                      'pageType':
                                                          "liftingSaleDetails",
                                                    },
                                                  )?.then((value) {
                                                    loadData();
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  35,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text("Update Sale details"),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.arrow_right_alt,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (priceModel
                                                      .apiResponse![0]
                                                      .userBasicInfo![0]
                                                      .userId ==
                                                  prefs.getString(
                                                    AppStrings.prefUserID,
                                                  ) ||
                                              prefs.getString(
                                                    AppStrings.prefRole,
                                                  ) ==
                                                  "SA")
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                AwesomeDialog(
                                                  context: context,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  dialogType:
                                                      DialogType.warning,
                                                  dialogBackgroundColor:
                                                      Colors.white,
                                                  titleTextStyle:
                                                      AppTheme.appBarText,
                                                  title:
                                                      'Are you sure you want to delete this Sale?',
                                                  btnCancelOnPress: () {},
                                                  btnCancelText: 'Cancel',
                                                  btnOkOnPress: () async {
                                                    LoadingDialogHelper.showLoadingDialog(context);
                                                    if (pageType ==
                                                        AppRoutes
                                                            .eggPriceScreen) {
                                                      var deleteEggSaleRes =
                                                          await AuthServices()
                                                              .deleteEggSaleRecord(
                                                                context,
                                                                priceModel
                                                                    .apiResponse![0]
                                                                    .eggsaleUuid,
                                                              );
                                                      if (deleteEggSaleRes
                                                              .apiResponse![0]
                                                              .responseStatus ==
                                                          true) {
                                                        NavigationHelper.pushReplacementNamed(
                                                          AppRoutes
                                                              .eggPriceScreen,
                                                        );
                                                      }
                                                    } else if (pageType ==
                                                        AppRoutes
                                                            .chickPriceScreen) {
                                                      var deleteChickSaleRes =
                                                          await AuthServices()
                                                              .deleteChickSaleRecord(
                                                                context,
                                                                priceModel
                                                                    .apiResponse![0]
                                                                    .chicksaleUuid,
                                                              );
                                                      if (deleteChickSaleRes
                                                              .apiResponse![0]
                                                              .responseStatus ==
                                                          true) {
                                                        NavigationHelper.pushReplacementNamed(
                                                          AppRoutes
                                                              .chickPriceScreen,
                                                        );
                                                      }
                                                    } else if (pageType ==
                                                        AppRoutes
                                                            .chickenPriceScreen) {
                                                      var deleteChickenSaleRes =
                                                          await AuthServices()
                                                              .deleteChickenSaleRecord(
                                                                context,
                                                                priceModel
                                                                    .apiResponse![0]
                                                                    .chickensaleUuid,
                                                              );
                                                      if (deleteChickenSaleRes
                                                              .apiResponse![0]
                                                              .responseStatus ==
                                                          true) {
                                                        NavigationHelper.pushReplacementNamed(
                                                          AppRoutes
                                                              .chickenPriceScreen,
                                                        );
                                                      }
                                                    } else if (pageType ==
                                                        AppRoutes
                                                            .liftingPriceScreen) {
                                                      var deleteLiftingSaleRes =
                                                          await AuthServices()
                                                              .deleteLiftingSaleRecord(
                                                                context,
                                                                priceModel
                                                                    .apiResponse![0]
                                                                    .liftingsaleUuid,
                                                              );
                                                      if (deleteLiftingSaleRes
                                                              .apiResponse![0]
                                                              .responseStatus ==
                                                          true) {
                                                        NavigationHelper.pushReplacementNamed(
                                                          AppRoutes
                                                              .liftingPriceScreen,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  btnOkText: 'Yes',
                                                  btnOkColor:
                                                      Colors.yellow.shade700,
                                                ).show();
                                              },
                                              icon: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                              ),
                                              label: const Text("Delete Sale"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                minimumSize: const Size(
                                                  double.infinity,
                                                  35,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
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
                        AttachmentWidget(
                          attachments: attachments,
                          userId: priceModel
                              .apiResponse![0]
                              .userBasicInfo![0]
                              .userId,
                          currentUserId:
                              prefs.getString(AppStrings.prefUserID) ?? '',
                          referenceFrom: referenceFrom,
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
                          pageType: pageType,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadDataPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _packageName = packageInfo.packageName;
  }
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

Widget buildRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            SizedBox(width: 5),
            Text(
              "$label:",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        Expanded(
          child: label == "Website Url"
              ? GestureDetector(
                  onTap: () => Utils.openLink(value),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
        ),
      ],
    ),
  );
}
