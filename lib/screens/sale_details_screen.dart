import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/screens/image_preview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/navigation_helper.dart';
import '../models/egg_price_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import 'video_player_screen.dart';

class SaleDetailsScreen extends StatefulWidget {
  const SaleDetailsScreen({super.key});

  @override
  State<SaleDetailsScreen> createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  late SharedPreferences prefs;
  late Future<EggPriceModel> eggPriceData;
  DateTime selectedDate = DateTime.now();
  String eggSaleID = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (eggSaleID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      eggSaleID = args['eggSaleID'] ?? '';
      eggPriceData = _fetchData(Utils.formatDate(selectedDate), eggSaleID);
    }
  }

  Future<EggPriceModel> _fetchData(
      String selectedDate, String eggSaleID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices()
        .getEggPriceList(context, eggSaleID, selectedDate, selectedDate, '');
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    eggPriceData = AuthServices().getEggPriceList(
      context,
      eggSaleID,
      Utils.formatDate(selectedDate),
      Utils.formatDate(selectedDate),
      '',
    );
    setState(() {}); // Refresh UI after loading data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: AppStrings.saleDetails),
      ),
      body: FutureBuilder<EggPriceModel>(
          future: eggPriceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found.'));
            }

            final eggPriceModel = snapshot.data!;
            final attachments =
                eggPriceModel.apiResponse![0].attachmentInfo ?? [];
            return Column(
              children: [
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  '${eggPriceModel.apiResponse![0].userBasicInfo![0].userLastName} ${eggPriceModel.apiResponse![0].userBasicInfo![0].userFirstName}',
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
                                  '${eggPriceModel.apiResponse![0].userBasicInfo![0].userMobile}',
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
                                  '${eggPriceModel.apiResponse![0].userBasicInfo![0].userEmail}',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        FloatingActionButton(
                          onPressed: () {
                            Utils.openDialPad(
                                '${eggPriceModel.apiResponse![0].userBasicInfo![0].userMobile}');
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.call,
                              color: AppColors.primaryColor),
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
                              visible: eggPriceModel.apiResponse![0]
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
                                    NavigationHelper.pushNamed(
                                      AppRoutes.sellEggScreen,
                                      arguments: {
                                        'eggPriceModel': eggPriceModel.apiResponse![0],
                                        'pageType': "eggSaleDetails",
                                      },
                                    )?.then((value) {
                                      loadData();
                                    });
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
                                        Icons.add_circle_outline,
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
                        const SizedBox(height: 6),
                        buildRow('Price',
                            '${eggPriceModel.apiResponse![0].eggsaleCost ?? ''} rs/egg',
                            isHighlight: true),
                        buildRow(
                            'Bird Breed',
                            eggPriceModel.apiResponse![0].birdBreedInfo?.first
                                    .birdbreedNameLanguage ??
                                ''),
                        buildRow(
                            'Company Name',
                            eggPriceModel.apiResponse![0].companyBasicInfo
                                    ?.first.companyNameLanguage ??
                                ''),
                        buildRow(
                            'Is Hatching Eggs?',
                            eggPriceModel.apiResponse![0].isHatchingEgg == 'Y'
                                ? 'Yes'
                                : 'No'),
                        buildRow(
                            'Is Special Sell?',
                            eggPriceModel.apiResponse![0].isSpecialSale == 'Y'
                                ? 'Yes'
                                : 'No'),
                        buildRow(
                            'Sale Start:',
                            Utils.threeLetterDateFormatted(eggPriceModel
                                    .apiResponse![0].eggsaleEffectFrom ??
                                '')),
                        buildRow(
                            'Sale End:',
                            Utils.threeLetterDateFormatted(
                                eggPriceModel.apiResponse![0].eggsaleEffectTo ??
                                    '')),
                        buildRow(
                          'Address',
                          '${eggPriceModel.apiResponse![0].addressDetails?.first.cityNameLanguage ?? ''}, ${eggPriceModel.apiResponse![0].addressDetails?.first.stateNameLanguage ?? ''}',
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
                                  visible: eggPriceModel.apiResponse![0]
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
                                        NavigationHelper.pushNamed(
                                          AppRoutes.uploadFileScreen,
                                          arguments: {
                                            'reference_from': 'EGG_SALE',
                                            'reference_uuid': eggPriceModel
                                                .apiResponse![0].eggsaleUuid,
                                            'pageType': AppRoutes.sellEggScreen,
                                          },
                                        )?.then((value) {
                                          loadData();
                                        });
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
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: attachments.length,
                                    itemBuilder: (context, index) {
                                      final attachment = attachments[index];
                                      final path =
                                          attachment.attachmentPath ?? '';
                                      final attType =
                                          attachment.attachmentType ?? '';
                                      final fileName =
                                          attachment.attachmentName ?? '';

                                      Widget leadingWidget;

                                      if (attType == 'image') {
                                        leadingWidget = ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(path,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover),
                                        );
                                      } else if (attType == 'video') {
                                        leadingWidget = Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.black12,
                                              ),
                                              child: const Icon(Icons.videocam,
                                                  color: Colors.grey),
                                            ),
                                            const Icon(Icons.play_circle_fill,
                                                size: 28, color: Colors.white),
                                          ],
                                        );
                                      } else if (attType == 'pdf') {
                                        leadingWidget = Container(
                                          width: 60,
                                          height: 60,
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
                                        leadingWidget = const Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.blue);
                                      }

                                      return Card(
                                        elevation: 0.0,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey.shade400,
                                              width: 1),
                                          // Change color here
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Optional: Adjust border radius
                                        ),
                                        child: ListTile(
                                          leading: leadingWidget,
                                          trailing: Visibility(
                                            visible: eggPriceModel
                                                    .apiResponse![0]
                                                    .userBasicInfo![0]
                                                    .userId ==
                                                prefs.getString(
                                                    AppStrings.prefUserID),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.delete_forever),
                                                  color: Colors.red,
                                                  onPressed: () async {
                                                    var attachmentDeleteRes =
                                                        await AuthServices()
                                                            .attachmentDelete(
                                                                context,
                                                                attachment
                                                                    .attachmentId!,
                                                                attachment
                                                                    .attachmentPath!);
                                                    if (attachmentDeleteRes
                                                            .apiResponse![0]
                                                            .responseStatus ==
                                                        true) {
                                                      setState(() {
                                                        attachments.removeAt(
                                                            index); // Remove the item directly
                                                      });
                                                    }
                                                    SnackbarHelper.showSnackBar(
                                                        attachmentDeleteRes
                                                            .apiResponse![0]
                                                            .responseDetails);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                            fileName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                              'Uploaded: ${attachment.attachmentCreatedon ?? "Unknown"}'),
                                          onTap: () {
                                            if (attType == 'image') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ImagePreviewScreen(
                                                            imageUrl: path),
                                                  ));
                                            } else if (attType == 'video') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        VideoPlayerScreen(
                                                            videoUrl: path),
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
