import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/appbar_widget.dart';
import '../values/app_strings.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String pageType;

  const ImagePreviewScreen(
      {super.key, required this.imageUrl, required this.pageType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: pageType == "AppStatus"
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: MyAppBar(title: AppStrings.imagePreview),
            ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
