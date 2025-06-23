import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/address_model.dart';
import 'package:hencafe/screens/image_preview_screen.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'video_player_screen.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  late SharedPreferences prefs;
  late Future<AddressModel> addressData;
  DateTime selectedDate = DateTime.now();
  String referenceFrom = '';
  String referenceUUID = '';
  String addressID = '';
  String pageType = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (referenceUUID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      referenceFrom = args['referenceFrom'] ?? '';
      referenceUUID = args['referenceUUID'] ?? '';
      pageType = args['pageType'] ?? '';
      addressID = args['addressID'] ?? '';
      logger.w(referenceUUID);
      if (pageType == AppRoutes.myProfileScreen) {
        addressData =
            _fetchUserAddress(referenceFrom, referenceUUID, addressID);
      }
    }
  }

  Future<AddressModel> _fetchUserAddress(
      String referenceFrom, String referenceUUID, String addressID) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices()
        .getAddressList(context, referenceFrom, referenceUUID, addressID);
  }

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    if (pageType == AppRoutes.myProfileScreen) {
      addressData = AuthServices()
          .getAddressList(context, referenceFrom, referenceUUID, addressID);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(
            title: pageType == AppRoutes.myProfileScreen
                ? 'Address Details'
                : 'Address Details'),
      ),
      body: FutureBuilder<dynamic>(
          future:
              pageType == AppRoutes.myProfileScreen ? addressData : addressData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data found.'));
            }

            final detailsModel = snapshot.data!;
            final attachments =
                detailsModel.apiResponse![0].attachmentInfo ?? [];
            final userInfo = detailsModel.apiResponse![0].userBasicInfo ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.bottomSlide,
                        dialogType: DialogType.warning,
                        dialogBackgroundColor: Colors.white,
                        titleTextStyle: AppTheme.appBarText,
                        title: 'Are you sure you want to delete this Address?',
                        btnCancelOnPress: () {},
                        btnCancelText: 'Cancel',
                        btnOkOnPress: () async {
                          var deleteAddressRes =
                              await AuthServices().deleteAddress(
                            context,
                            detailsModel.apiResponse![0].addressUuid,
                          );
                          if (deleteAddressRes.apiResponse![0].responseStatus ==
                              true) {
                            NavigationHelper.pop(context);
                          }
                        },
                        btnOkText: 'Yes',
                        btnOkColor: Colors.yellow.shade700,
                      ).show();
                    },
                    child: Container(
                        width: 145,
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
                              'Delete Address',
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
                              'Address Information',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Visibility(
                              visible: userInfo![0].userId ==
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
                                    if (pageType == AppRoutes.myProfileScreen) {
                                      NavigationHelper.pushNamed(
                                        AppRoutes.createAddressScreen,
                                        arguments: {
                                          'addressModel': detailsModel,
                                          'pageType': "UpdateAddressScreen",
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
                        buildRow('Address Type',
                            '${detailsModel.apiResponse![0].addressType ?? ''}'),
                        buildRow('Address',
                            '${detailsModel.apiResponse![0].addressAddress ?? ''}'),
                        buildRow('ZipCode',
                            '${detailsModel.apiResponse![0].addressZipcode ?? ''}'),
                        buildRow('City',
                            '${detailsModel.apiResponse![0].locationInfo![0].cityNameLanguage ?? ''}'),
                        buildRow('State',
                            '${detailsModel.apiResponse![0].locationInfo![0].stateNameLanguage ?? ''}'),
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
                                  visible: detailsModel.apiResponse![0]
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
                                              'reference_uuid': detailsModel
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
                                              'reference_uuid': detailsModel
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
                                              'reference_uuid': detailsModel
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
                                              'reference_uuid': detailsModel
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
                                            visible: detailsModel
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
                                                      },
                                                      btnOkText: 'Yes',
                                                      btnOkColor: Colors
                                                          .yellow.shade700,
                                                    ).show();
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
