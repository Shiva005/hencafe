import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/appbar_widget.dart';
import '../values/app_strings.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({super.key});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  String _packageName = '';

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
        ], text: '${AppStrings.shareText}$_packageName}');
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
  void initState() {
    super.initState();
    getPackageName();
  }

  Future<void> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _packageName = packageInfo.packageName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String imageUrl = args['imageUrl'] ?? '';
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: MyAppBar(title: AppStrings.imagePreview)),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 30),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: captureAndShare,
                    icon: const Icon(Icons.share, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
