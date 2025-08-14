import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/chicken_price_model.dart';
import 'package:hencafe/models/lifting_price_model.dart';
import 'package:hencafe/screens/image_preview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
import 'video_player_screen.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (saleID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      saleID = args['saleID'] ?? '';
      pageType = args['pageType'] ?? '';
      if (pageType == AppRoutes.eggPriceScreen) {
        eggPriceData = _fetchEggData(Utils.formatDate(selectedDate), saleID);
      } else if (pageType == AppRoutes.chickPriceScreen) {
        chickPriceData =
            _fetchChickData(Utils.formatDate(selectedDate), saleID);
      } else if (pageType == AppRoutes.chickenPriceScreen) {
        chickenPriceData =
            _fetchChickenData(Utils.formatDate(selectedDate), saleID);
      } else if (pageType == AppRoutes.liftingPriceScreen) {
        liftingSaleData =
            _fetchLiftingSaleData(Utils.formatDate(selectedDate), saleID);
      }
    }
  }

  Future<LiftingPriceModel> _fetchLiftingSaleData(
      String selectedDate, String eggSaleID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getLiftingPriceList(
        context, eggSaleID, selectedDate, selectedDate, '');
  }

  Future<EggPriceModel> _fetchEggData(
      String selectedDate, String eggSaleID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices()
        .getEggPriceList(context, eggSaleID, selectedDate, selectedDate, '');
  }

  Future<ChickPriceModel> _fetchChickData(
      String selectedDate, String eggSaleID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices()
        .getChickPriceList(context, eggSaleID, selectedDate, selectedDate, '');
  }

  Future<ChickenPriceModel> _fetchChickenData(
      String selectedDate, String eggSaleID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getChickenPriceList(
        context, eggSaleID, selectedDate, selectedDate, '');
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(
            title: pageType == AppRoutes.eggPriceScreen
                ? 'Egg Sale Details'
                : pageType == AppRoutes.chickPriceScreen
                    ? 'Chick Sale Details'
                    : pageType == AppRoutes.liftingPriceScreen
                        ? 'Lifting Sale Details'
                        : 'Chicken Sale Details'),
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
            final attachments = priceModel.apiResponse![0].attachmentInfo ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (priceModel.apiResponse![0].userBasicInfo![0].userId ==
                    prefs.getString(AppStrings.prefUserID))
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.warning,
                          dialogBackgroundColor: Colors.white,
                          titleTextStyle: AppTheme.appBarText,
                          title: 'Are you sure you want to delete this Sale?',
                          btnCancelOnPress: () {},
                          btnCancelText: 'Cancel',
                          btnOkOnPress: () async {
                            if (pageType == AppRoutes.eggPriceScreen) {
                              var deleteEggSaleRes =
                                  await AuthServices().deleteEggSaleRecord(
                                context,
                                priceModel.apiResponse![0].eggsaleUuid,
                              );
                              if (deleteEggSaleRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                NavigationHelper.pushReplacementNamed(
                                  AppRoutes.eggPriceScreen,
                                );
                              }
                            } else if (pageType == AppRoutes.chickPriceScreen) {
                              var deleteChickSaleRes =
                                  await AuthServices().deleteChickSaleRecord(
                                context,
                                priceModel.apiResponse![0].chicksaleUuid,
                              );
                              if (deleteChickSaleRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                NavigationHelper.pushReplacementNamed(
                                  AppRoutes.chickPriceScreen,
                                );
                              }
                            } else if (pageType ==
                                AppRoutes.chickenPriceScreen) {
                              var deleteChickenSaleRes =
                                  await AuthServices().deleteChickenSaleRecord(
                                context,
                                priceModel.apiResponse![0].chickensaleUuid,
                              );
                              if (deleteChickenSaleRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                NavigationHelper.pushReplacementNamed(
                                  AppRoutes.chickenPriceScreen,
                                );
                              }
                            } else if (pageType ==
                                AppRoutes.liftingPriceScreen) {
                              var deleteLiftingSaleRes =
                                  await AuthServices().deleteLiftingSaleRecord(
                                context,
                                priceModel.apiResponse![0].liftingsaleUuid,
                              );
                              if (deleteLiftingSaleRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                NavigationHelper.pushReplacementNamed(
                                  AppRoutes.liftingPriceScreen,
                                );
                              }
                            }
                          },
                          btnOkText: 'Yes',
                          btnOkColor: Colors.yellow.shade700,
                        ).show();
                      },
                      child: Container(
                          width: 135,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Delete Sale',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                                size: 18,
                              ),
                            ],
                          )),
                    ),
                  ),
                SizedBox(height: 5),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: Adjust border radius
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seller Information',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                const Icon(Icons.person_outlined,
                                    size: 20, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text(
                                  '${priceModel.apiResponse![0].userBasicInfo![0].userLastName} ${priceModel.apiResponse![0].userBasicInfo![0].userFirstName}',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.call_outlined,
                                    size: 20, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text(
                                  '${priceModel.apiResponse![0].userBasicInfo![0].userMobile}',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined,
                                    size: 20, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text(
                                  '${priceModel.apiResponse![0].userBasicInfo![0].userEmail}',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                NavigationHelper.pushNamed(
                                  AppRoutes.myProfileScreen,
                                  arguments: {
                                    'pageType': AppRoutes.saleDetailsScreen,
                                    'userID': priceModel.apiResponse![0]
                                        .userBasicInfo![0].userId
                                        .toString(),
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'View full Profile',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            FloatingActionButton(
                              onPressed: () {
                                Utils.openDialPad(
                                    '${priceModel.apiResponse![0].userBasicInfo![0].userMobile}');
                              },
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.call,
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sales Information',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Visibility(
                              visible: priceModel.apiResponse![0]
                                      .userBasicInfo![0].userId ==
                                  prefs.getString(AppStrings.prefUserID),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (pageType == AppRoutes.eggPriceScreen) {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.sellEggScreen,
                                        arguments: {
                                          'eggPriceModel':
                                              priceModel.apiResponse![0],
                                          'pageType': "eggSaleDetails",
                                        },
                                      )?.then((value) {
                                        loadData();
                                      });
                                    } else if (pageType ==
                                        AppRoutes.chickPriceScreen) {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.sellChickScreen,
                                        arguments: {
                                          'chickPriceModel':
                                              priceModel.apiResponse![0],
                                          'pageType': "chickSaleDetails",
                                        },
                                      )?.then((value) {
                                        loadData();
                                      });
                                    } else if (pageType ==
                                        AppRoutes.chickenPriceScreen) {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.sellChickenScreen,
                                        arguments: {
                                          'chickenPriceModel':
                                              priceModel.apiResponse![0],
                                          'pageType': "chickenSaleDetails",
                                        },
                                      )?.then((value) {
                                        loadData();
                                      });
                                    } else if (pageType ==
                                        AppRoutes.liftingPriceScreen) {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.sellLiftingScreen,
                                        arguments: {
                                          'liftingPriceModel':
                                              priceModel.apiResponse![0],
                                          'pageType': "liftingSaleDetails",
                                        },
                                      )?.then((value) {
                                        loadData();
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Edit Info',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (pageType == AppRoutes.eggPriceScreen)
                          buildRow('Price',
                              '${priceModel.apiResponse![0].eggsaleCost ?? ''} rs/egg',
                              isHighlight: true),
                        if (pageType == AppRoutes.chickPriceScreen)
                          buildRow('Price',
                              '${priceModel.apiResponse![0].chicksaleCost ?? ''} rs/chick',
                              isHighlight: true),
                        if (pageType == AppRoutes.chickenPriceScreen)
                          buildRow('Price',
                              '${priceModel.apiResponse![0].farmLiveBirdCost ?? ''} Rs/kg',
                              isHighlight: true),
                        if (pageType == AppRoutes.liftingPriceScreen)
                          buildRow('Price',
                              '${priceModel.apiResponse![0].liftingsaleCostPerKg ?? ''} Rs/kg',
                              isHighlight: true),
                        if (pageType == AppRoutes.liftingPriceScreen)
                          buildRow('Total Birds',
                              '${priceModel.apiResponse![0].liftingsaleTotalBirds ?? ''} Total Birds'),
                        buildRow(
                            'Bird Breed',
                            priceModel.apiResponse![0].birdBreedInfo?.first
                                    .birdbreedNameLanguage ??
                                ''),
                        if (pageType != AppRoutes.liftingPriceScreen)
                          buildRow(
                              'Company Name',
                              priceModel.apiResponse![0].companyBasicInfo?.first
                                      .companyNameLanguage ??
                                  ''),
                        if (pageType == AppRoutes.eggPriceScreen)
                          buildRow(
                              'Is Hatching Eggs?',
                              priceModel.apiResponse![0].isHatchingEgg == 'Y'
                                  ? 'Yes'
                                  : 'No'),
                        if (pageType == AppRoutes.chickPriceScreen ||
                            pageType == AppRoutes.liftingPriceScreen)
                          buildRow(
                              pageType == AppRoutes.liftingPriceScreen
                                  ? 'Bird Age'
                                  : 'Chick age',
                              '${priceModel.apiResponse![0].birdAgeInDays ?? ''} Days'),
                        if (pageType == AppRoutes.chickPriceScreen)
                          buildRow('Chick weight',
                              '${priceModel.apiResponse![0].birdWeightInGrams ?? ''} Grams'),
                        if (pageType == AppRoutes.liftingPriceScreen)
                          buildRow('Bird weight',
                              '${priceModel.apiResponse![0].birdWeightInKg ?? ''} Kg'),
                        if (pageType != AppRoutes.liftingPriceScreen)
                          buildRow(
                              'Is Special Sell?',
                              priceModel.apiResponse![0].isSpecialSale == 'Y'
                                  ? 'Yes'
                                  : 'No'),
                        if (pageType == AppRoutes.eggPriceScreen)
                          buildRow(
                              'Sale Start:',
                              Utils.threeLetterDateFormatted(priceModel
                                      .apiResponse![0].eggsaleEffectFrom ??
                                  '')),
                        if (pageType == AppRoutes.chickPriceScreen)
                          buildRow(
                              'Sale Start:',
                              Utils.threeLetterDateFormatted(priceModel
                                      .apiResponse![0].chicksaleEffectFrom ??
                                  '')),
                        if (pageType == AppRoutes.chickenPriceScreen)
                          buildRow(
                              'Sale Start:',
                              Utils.threeLetterDateFormatted(priceModel
                                      .apiResponse![0].chickensaleEffectFrom ??
                                  '')),
                        if (pageType == AppRoutes.eggPriceScreen)
                          buildRow(
                              'Sale End:',
                              Utils.threeLetterDateFormatted(
                                  priceModel.apiResponse![0].eggsaleEffectTo ??
                                      '')),
                        if (pageType == AppRoutes.chickPriceScreen)
                          buildRow(
                              'Sale End:',
                              Utils.threeLetterDateFormatted(
                                  priceModel.apiResponse![0].chickaleEffectTo ??
                                      '')),
                        if (pageType == AppRoutes.chickenPriceScreen)
                          buildRow(
                              'Sale End:',
                              Utils.threeLetterDateFormatted(priceModel
                                      .apiResponse![0].chickensaleEffectTo ??
                                  '')),
                        if (pageType != AppRoutes.liftingPriceScreen)
                          buildRow(
                            'Address',
                            '${priceModel.apiResponse![0].addressDetails?.first.cityNameLanguage ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.stateNameLanguage ?? ''}',
                            isMultiline: true,
                          ),
                        if (pageType == AppRoutes.liftingPriceScreen)
                          buildRow(
                            'Address',
                            '${priceModel.apiResponse![0].liftingsaleAddress ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.cityNameLanguage ?? ''}, ${priceModel.apiResponse![0].addressDetails?.first.stateNameLanguage ?? ''}',
                            isMultiline: true,
                          ),
                        if (pageType == AppRoutes.eggPriceScreen)
                          buildRow(
                            'Comment',
                            '${priceModel.apiResponse![0].eggsaleComment ?? ''}',
                            isMultiline: true,
                          ),
                        if (pageType == AppRoutes.chickPriceScreen)
                          buildRow(
                            'Comment',
                            '${priceModel.apiResponse![0].chicksaleComment ?? ''}',
                            isMultiline: true,
                          ),
                        if (pageType == AppRoutes.chickenPriceScreen)
                          buildRow(
                            'Comment',
                            '${priceModel.apiResponse![0].chickensaleComment ?? ''}',
                            isMultiline: true,
                          ),
                        if (pageType == AppRoutes.liftingPriceScreen)
                          buildRow(
                            'Comment',
                            '${priceModel.apiResponse![0].liftingsaleComment ?? ''}',
                            isMultiline: true,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(
                          10.0), // Optional: Adjust border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Attachments',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Visibility(
                                  visible: priceModel.apiResponse![0]
                                          .userBasicInfo![0].userId ==
                                      prefs.getString(AppStrings.prefUserID),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      border: Border.all(
                                          color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (pageType ==
                                            AppRoutes.eggPriceScreen) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.uploadFileScreen,
                                            arguments: {
                                              'reference_from': 'EGG_SALE',
                                              'reference_uuid': priceModel
                                                  .apiResponse![0].eggsaleUuid,
                                              'pageType':
                                                  AppRoutes.sellEggScreen,
                                            },
                                          )?.then((value) {
                                            loadData();
                                          });
                                        } else if (pageType ==
                                            AppRoutes.chickPriceScreen) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.uploadFileScreen,
                                            arguments: {
                                              'reference_from': 'CHICK_SALE',
                                              'reference_uuid': priceModel
                                                  .apiResponse![0]
                                                  .chicksaleUuid,
                                              'pageType':
                                                  AppRoutes.sellChickScreen,
                                            },
                                          )?.then((value) {
                                            loadData();
                                          });
                                        } else if (pageType ==
                                            AppRoutes.chickenPriceScreen) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.uploadFileScreen,
                                            arguments: {
                                              'reference_from': 'CHICKEN_SALE',
                                              'reference_uuid': priceModel
                                                  .apiResponse![0]
                                                  .chickensaleUuid,
                                              'pageType':
                                                  AppRoutes.sellChickenScreen,
                                            },
                                          )?.then((value) {
                                            loadData();
                                          });
                                        } else if (pageType ==
                                            AppRoutes.liftingPriceScreen) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.uploadFileScreen,
                                            arguments: {
                                              'reference_from': 'LIFTING_SALE',
                                              'reference_uuid': priceModel
                                                  .apiResponse![0]
                                                  .liftingsaleUuid,
                                              'pageType':
                                                  AppRoutes.sellLiftingScreen,
                                            },
                                          )?.then((value) {
                                            loadData();
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Upload',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.file_upload_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: attachments.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(10),
                                    itemCount: attachments.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.88,
                                    ),
                                    itemBuilder: (context, index) {
                                      final attachment = attachments[index];
                                      final path =
                                          attachment.attachmentPath ?? '';
                                      final attType =
                                          attachment.attachmentType ?? '';
                                      final fileName =
                                          attachment.attachmentName ?? '';

                                      Widget mediaWidget;

                                      if (attType == 'image') {
                                        mediaWidget = ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            path,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      } else if (attType == 'video') {
                                        mediaWidget = Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: double.maxFinite,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.black12,
                                              ),
                                              child: const Icon(Icons.videocam,
                                                  color: Colors.grey),
                                            ),
                                            const Icon(Icons.videocam,
                                                size: 28,
                                                color: AppColors.primaryColor),
                                          ],
                                        );
                                      } else if (attType == 'pdf') {
                                        mediaWidget = Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.red[50],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.red),
                                        );
                                      } else {
                                        mediaWidget = Container(
                                          width: 150,
                                          height: 150,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                              Icons.insert_drive_file,
                                              color: Colors.blue),
                                        );
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          if (attType == 'image') {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ImagePreviewScreen(
                                                          imageUrl: path, pageType: AppRoutes.saleDetailsScreen,),
                                                ));
                                          } else if (attType == 'video') {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      VideoPlayerScreen(
                                                          videoUrl: path, pageType: AppRoutes.saleDetailsScreen,),
                                                ));
                                          } else if (attType == 'pdf') {
                                            _openExternalApp(path);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Unsupported file format")),
                                            );
                                          }
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    12)),
                                                    child: mediaWidget,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Text(
                                                      fileName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  /*Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    child: Text(overflow:
                                                    TextOverflow.ellipsis,
                                                      'Date: ${attachment.attachmentCreatedon ?? "Unknown"}',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                  ),*/
                                                ],
                                              ),

                                              // Delete button
                                              if (priceModel
                                                      .apiResponse![0]
                                                      .userBasicInfo![0]
                                                      .userId ==
                                                  prefs.getString(
                                                      AppStrings.prefUserID))
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      AwesomeDialog(
                                                        context: context,
                                                        animType: AnimType
                                                            .bottomSlide,
                                                        dialogType:
                                                            DialogType.warning,
                                                        dialogBackgroundColor:
                                                            Colors.white,
                                                        titleTextStyle:
                                                            AppTheme.appBarText,
                                                        title:
                                                            'Are you sure you want to delete this file?',
                                                        btnCancelOnPress: () {},
                                                        btnCancelText: 'Cancel',
                                                        btnOkOnPress: () async {
                                                          var attachmentDeleteRes =
                                                              await AuthServices()
                                                                  .attachmentDelete(
                                                            context,
                                                            attachment
                                                                .attachmentId!,
                                                            attachment
                                                                .attachmentPath!,
                                                          );
                                                          if (attachmentDeleteRes
                                                                  .apiResponse![
                                                                      0]
                                                                  .responseStatus ==
                                                              true) {
                                                            setState(() {
                                                              attachments
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          }
                                                        },
                                                        btnOkText: 'Yes',
                                                        btnOkColor: Colors
                                                            .yellow.shade700,
                                                      ).show();
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(
                                                          Icons.delete_forever,
                                                          size: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text("No attachments found.")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

Widget buildRow(String title, String value,
    {bool isHighlight = false, bool isMultiline = false}) {
  return Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isHighlight ? 16 : 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

void _openExternalApp(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
