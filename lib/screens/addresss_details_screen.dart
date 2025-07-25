import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/address_model.dart';
import 'package:hencafe/screens/video_player_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'image_preview_screen.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  late SharedPreferences prefs;
  Future<AddressModel>? addressData;
  DateTime selectedDate = DateTime.now();
  String referenceFrom = '';
  String referenceUUID = '';
  String addressID = '';
  String pageType = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      referenceFrom = args['referenceFrom'] ?? '';
      referenceUUID = args['referenceUUID'] ?? '';
      pageType = args['pageType'] ?? '';
      addressID = args['addressID'] ?? '';
      setState(() {
        addressData =
            _fetchUserAddress(referenceFrom, referenceUUID, addressID);
      });
    });
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
      body: addressData != null
          ? FutureBuilder<dynamic>(
              future: pageType == AppRoutes.myProfileScreen
                  ? addressData
                  : addressData,
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
                final userInfo =
                    detailsModel.apiResponse![0].userBasicInfo ?? [];
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
                            title:
                                'Are you sure you want to delete this Address?',
                            btnCancelOnPress: () {},
                            btnCancelText: 'Cancel',
                            btnOkOnPress: () async {
                              var deleteAddressRes =
                                  await AuthServices().deleteAddress(
                                context,
                                detailsModel.apiResponse![0].addressUuid,
                              );
                              if (deleteAddressRes
                                      .apiResponse![0].responseStatus ==
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
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
                        side:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6),
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                if (userInfo[0].userId ==
                                    prefs.getString(AppStrings.prefUserID))
                                  Container(
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
                                          AppRoutes.createAddressScreen,
                                          arguments: {
                                            'addressModel': detailsModel,
                                            'pageType': "UpdateAddressScreen",
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
                                                color: Colors.white,
                                                fontSize: 13),
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: Adjust border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Attachments',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                    if (userInfo[0].userId ==
                                        prefs.getString(AppStrings.prefUserID))
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          border: Border.all(
                                              color: AppColors.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            NavigationHelper.pushNamed(
                                              AppRoutes.uploadFileScreen,
                                              arguments: {
                                                'reference_from': 'ADDRESS',
                                                'reference_uuid': detailsModel
                                                    .apiResponse![0]
                                                    .addressUuid,
                                                'pageType': AppRoutes
                                                    .addressDetailsScreen,
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
                                      )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: attachments.isNotEmpty
                                    ? GridView.builder(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
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
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.black12,
                                                  ),
                                                  child: const Icon(
                                                      Icons.videocam,
                                                      color: Colors.grey),
                                                ),
                                                const Icon(Icons.videocam,
                                                    size: 28,
                                                    color:
                                                        AppColors.primaryColor),
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
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        12)),
                                                        child: mediaWidget,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6),
                                                        child: Text(
                                                          fileName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
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
                                                  if (detailsModel
                                                          .apiResponse![0]
                                                          .userBasicInfo![0]
                                                          .userId ==
                                                      prefs.getString(AppStrings
                                                          .prefUserID))
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
                                                                DialogType
                                                                    .warning,
                                                            dialogBackgroundColor:
                                                                Colors.white,
                                                            titleTextStyle:
                                                                AppTheme
                                                                    .appBarText,
                                                            title:
                                                                'Are you sure you want to delete this file?',
                                                            btnCancelOnPress:
                                                                () {},
                                                            btnCancelText:
                                                                'Cancel',
                                                            btnOkOnPress:
                                                                () async {
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
                                                                .yellow
                                                                .shade700,
                                                          ).show();
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              Colors.red,
                                                          child: Icon(
                                                              Icons
                                                                  .delete_forever,
                                                              size: 16,
                                                              color:
                                                                  Colors.white),
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
              })
          : Center(child: CircularProgressIndicator()),
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
