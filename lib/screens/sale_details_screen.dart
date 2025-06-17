import 'package:flutter/material.dart';
import 'package:hencafe/screens/image_preview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/egg_price_model.dart';
import '../utils/appbar_widget.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_strings.dart';
import 'video_player_screen.dart'; // Your existing video player screen

class SaleDetailsScreen extends StatelessWidget {
  const SaleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ApiResponse eggPriceModel = arguments['eggPriceModel'];
    final attachments = eggPriceModel.attachmentInfo ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: AppStrings.saleDetails),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryColor, width: 1),
              borderRadius:
                  BorderRadius.circular(10.0), // Optional: Adjust border radius
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seller Information',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          const Icon(Icons.person_outlined,
                              size: 20, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            '${eggPriceModel.userBasicInfo![0].userLastName} ${eggPriceModel.userBasicInfo![0].userFirstName}',
                            style: TextStyle(fontSize: 17, color: Colors.black),
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
                            '${eggPriceModel.userBasicInfo![0].userMobile}',
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
                            '${eggPriceModel.userBasicInfo![0].userEmail}',
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
                          '${eggPriceModel.userBasicInfo![0].userMobile}');
                    },
                    backgroundColor: Colors.white,
                    child:
                        const Icon(Icons.call, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryColor, width: 1),
              borderRadius:
                  BorderRadius.circular(10.0), // Optional: Adjust border radius
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Information',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price ',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            eggPriceModel.eggsaleCost ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const Text(
                            ' rs/egg',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bird Breed ',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(eggPriceModel
                              .birdBreedInfo![0].birdbreedNameLanguage ??
                          ''),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Company Name ',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(eggPriceModel
                          .companyBasicInfo![0].companyNameLanguage!),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Is Hatching Eggs?',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(eggPriceModel.isHatchingEgg == "Y" ? "Yes" : "No"),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Is Special Sell?',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(eggPriceModel.isSpecialSale == "Y" ? "Yes" : "No"),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sale Start:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(Utils.threeLetterDateFormatted(
                          eggPriceModel.eggsaleEffectFrom.toString())),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sale End:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(Utils.threeLetterDateFormatted(
                          eggPriceModel.eggsaleEffectTo.toString())),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                      Text(
                        '${eggPriceModel.addressDetails![0].cityNameLanguage!}, ${eggPriceModel.addressDetails![0].stateNameLanguage!}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Attachments',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: attachments.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: attachments.length,
                              itemBuilder: (context, index) {
                                final attachment = attachments[index];
                                final path = attachment.attachmentPath ?? '';
                                final attType = attachment.attachmentType ?? '';
                                final fileName =
                                    attachment.attachmentName ?? '';

                                Widget leadingWidget;

                                if (attType == 'image') {
                                  leadingWidget = ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.picture_as_pdf,
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
                                        color: Colors.grey.shade400, width: 1),
                                    // Change color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Adjust border radius
                                  ),
                                  child: ListTile(
                                    leading: leadingWidget,
                                    title: Text(fileName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
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
                                              builder: (_) => VideoPlayerScreen(
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
                          : const Center(child: Text("No attachments found.")),
                    ),
                  ],
                ),
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
}
