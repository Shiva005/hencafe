import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/services/service_name.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

class UploadFileScreen extends StatefulWidget {
  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  List<_UploadFile> files = [];
  final uuid = Uuid();

  void pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'docx', 'jpg', 'png'],
    );

    if (result != null) {
      for (var file in result.files) {
        File selectedFile = File(file.path!);
        files.add(_UploadFile(file: selectedFile, name: file.name));
      }
      setState(() {});
    }
  }

  bool _isImageFile(String path) {
    final ext = extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png'].contains(ext);
  }

  /// Compress image and return compressed File
  Future<File> _compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return file;

    final resized = img.copyResize(originalImage,
        width: (originalImage.width * 0.5).toInt(),
        height: (originalImage.height * 0.5).toInt());

    final compressedPath = file.path.replaceFirst(
        RegExp(r'(.jpg|.jpeg|.png)$'), '_compressed.jpg');
    final compressedFile = File(compressedPath)
      ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));

    return compressedFile;
  }

  Future<void> uploadFile(_UploadFile fileData, String referenceFrom,
      String referenceUUID, String fileName) async {
    final dio = Dio();
    File file = fileData.file;

    // Compress image here, if applicable
    if (_isImageFile(file.path)) {
      try {
        fileData.status = UploadStatus.compressing;
        setState(() {});
        file = await _compressImage(file);
      } catch (e) {
        logger.e('Image compression failed: $e');
        // fallback to original file if compression fails
      }
    }

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString(AppStrings.prefUserID) ?? '';
    final userUUID = prefs.getString(AppStrings.prefUserUUID) ?? '';
    final authUUID = prefs.getString(AppStrings.prefAuthID) ?? '';
    final language = prefs.getString(AppStrings.prefLanguage) ?? 'en';
    final sessionID = prefs.getString(AppStrings.prefSessionID) ?? '';

    logger.d("Uploading file: ${basename(file.path)}");
    logger.d("User ID: $userId, UUID: $userUUID, Auth UUID: $authUUID");
    logger.d("attachment: ${_getAttachmentType(file.path)}");

    try {
      fileData.status = UploadStatus.uploading;
      setState(() {});

      final mimeType = _getMimeType(file.path);
      final contentType = MediaType.parse(mimeType);

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path),
          contentType: contentType,
        ),
        "reference_from": referenceFrom,
        "reference_uuid": referenceUUID,
        "attachment_type": _getAttachmentType(file.path),
        "attachment_name": basename(file.path),
      });

      final response = await dio.post(
        ServiceNames.ATTACHMENT_UPLOAD,
        data: formData,
        options: Options(
          headers: {
            'language': language,
            'user-id': userId,
            'user-uuid': userUUID,
            'auth-uuid': authUUID,
            'session-id': sessionID,
          },
        ),
        onSendProgress: (sent, total) {
          setState(() {
            fileData.progress = sent / total;
          });
        },
      );

      logger.d('TAG Upload File Payload: $formData');
      logger.d('TAG Upload File Response: ${response.data}');

      fileData.status = UploadStatus.success;
    } catch (e) {
      if (e is DioException) {
        logger.e('TAG Upload File Dio Error: ${e.response?.statusMessage}');
        logger.e('TAG Upload File Headers: ${e.response?.headers}');
        logger.e('TAG Upload File Status Code: ${e.response?.statusCode}');
        logger.d("Sending upload with:");
        logger.d("user-id: $userId");
        logger.d("user-uuid: $userUUID");
        logger.d("auth-uuid: $authUUID");
        logger.d("attachment-type: ${_getAttachmentType(file.path)}");
      } else {
        logger.e('TAG Upload Unexpected Error: $e');
      }
      fileData.status = UploadStatus.failed;
    }

    setState(() {});
  }

  String _getMimeType(String path) {
    final ext = extension(path).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      case '.mp4':
        return 'video/mp4';
      default:
        return 'application/octet-stream';
    }
  }

  String _getAttachmentType(String path) {
    final extension = path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) return 'image';
    if (['pdf'].contains(extension)) return 'pdf';
    if (['mp4', 'mov', 'avi'].contains(extension)) return 'video';
    if (['doc', 'docx'].contains(extension)) return 'document';

    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String referenceUUID = args?['reference_uuid'] ?? '';
    final String referenceFrom = args?['reference_from'] ?? '';
    final String pageType = args?['pageType'] ?? '';

    logger.e('$referenceFrom $referenceUUID');
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.uploadFile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DottedBorderBox(onTap: pickFiles),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (_, index) {
                  final file = files[index];
                  return GestureDetector(
                    onTap: (file.status == UploadStatus.initial ||
                        file.status == UploadStatus.failed)
                        ? () => uploadFile(
                        file, referenceFrom, referenceUUID, file.name)
                        : null,
                    child: Card(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side:
                        BorderSide(color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 10.0, right: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.0),
                                  Text(file.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(_formatFileSize(file.file.lengthSync())),
                                  SizedBox(height: 5),
                                  if (file.status == UploadStatus.initial)
                                    Text(
                                      "Upload pending, Click to upload",
                                      style: TextStyle(
                                        color: Colors.orange,
                                      ),
                                    )
                                  else if (file.status == UploadStatus.compressing)
                                    Text(
                                      "File upload in progress...",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    )
                                  else if (file.status == UploadStatus.uploading)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, top: 5.0, bottom: 5.0),
                                        child: LinearProgressIndicator(
                                          value: file.progress,
                                          color: Colors.green.shade600,
                                        ),
                                      )
                                    else if (file.status == UploadStatus.success)
                                        Text("File Uploaded Successfully!!",
                                            style: TextStyle(color: Colors.green))
                                      else if (file.status == UploadStatus.failed)
                                          Text("Upload failed",
                                              style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                            if (file.status == UploadStatus.initial ||
                                file.status == UploadStatus.failed)
                              IconButton(
                                icon: Icon(
                                  Icons.upload,
                                  color: AppColors.primaryColor,
                                  size: 30,
                                ),
                                onPressed: () => uploadFile(
                                    file, referenceFrom, referenceUUID, file.name),
                              ),
                            if (file.status == UploadStatus.failed)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.refresh, color: Colors.orange),
                                    onPressed: () => uploadFile(
                                        file, referenceFrom, referenceUUID, file.name),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever, color: Colors.red),
                                    onPressed: () =>
                                        setState(() => files.removeAt(index)),
                                  ),
                                ],
                              ),
                            if (file.status == UploadStatus.initial)
                              IconButton(
                                icon: Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: () =>
                                    setState(() => files.removeAt(index)),
                              ),
                            if (file.status == UploadStatus.success)
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    setState(() => files.removeAt(index)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

class DottedBorderBox extends StatelessWidget {
  final VoidCallback onTap;

  const DottedBorderBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.primaryColor,
        strokeWidth: 2,
        dashPattern: [6, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        child: Container(
          height: 150,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined,
                  size: 40, color: AppColors.primaryColor),
              SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    "Click to choose files",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "(Maximum file size is 20MB)".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum UploadStatus { initial, compressing, uploading, success, failed }

class _UploadFile {
  final File file;
  final String name;
  double progress;
  UploadStatus status;

  _UploadFile({
    required this.file,
    required this.name,
    this.progress = 0.0,
    this.status = UploadStatus.initial,
  });
}
