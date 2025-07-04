import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/services/service_name.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UploadFileScreen(),
  ));
}

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
        files.add(_UploadFile(file: File(file.path!), name: file.name));
      }
      setState(() {});
    }
  }

  Future<void> uploadFile(_UploadFile fileData) async {
    final dio = Dio();
    final file = fileData.file;
    final fileName = basename(file.path);
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString(AppStrings.prefUserID) ?? '';
    final userUUID = prefs.getString(AppStrings.prefUserUUID) ?? '';
    final authUUID = prefs.getString(AppStrings.prefAuthID) ?? '';
    final language = prefs.getString(AppStrings.prefLanguage) ?? 'en';

    logger.d("Uploading file: $fileName");
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
          filename: fileName,
          contentType: contentType,
        ),
        "reference_from": "CHICKEN_SALE",
        "reference_uuid": uuid.v1(),
        "attachment_type": _getAttachmentType(file.path),
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
        SnackbarHelper.showSnackBar(e.response?.statusMessage);
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
        return 'application/octet-stream'; // fallback
    }
  }

  String _getAttachmentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    SnackbarHelper.showSnackBar(extension);

    if (['jpg', 'jpeg', 'png'].contains(extension)) return 'image';
    if (['pdf'].contains(extension)) return 'pdf';
    if (['mp4', 'mov', 'avi'].contains(extension)) return 'video';
    if (['doc', 'docx'].contains(extension)) return 'document';

    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: file.status == UploadStatus.initial
                        ? () => uploadFile(file)
                        : null,
                    child: Card(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.primaryColor, width: 1),
                        // Change color here
                        borderRadius:
                        BorderRadius.circular(8.0), // Optional: Adjust border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 10.0, right: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // File Info
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
                                  else if (file.status ==
                                      UploadStatus.uploading)
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
                                file.status == UploadStatus.uploading)
                              IconButton(
                                icon: Icon(
                                  Icons.upload,
                                  color: AppColors.primaryColor,
                                  size: 30,
                                ),
                                onPressed: () => uploadFile(file),
                              )
                            else if (file.status == UploadStatus.failed)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.refresh, color: Colors.orange),
                                    onPressed: () => uploadFile(file),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever,
                                        color: Colors.red),
                                    onPressed: () =>
                                        setState(() => files.removeAt(index)),
                                  ),
                                ],
                              ),


                            if (file.status == UploadStatus.initial)
                              IconButton(
                                icon: Icon(Icons.delete_forever,
                                    color: Colors.red),
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

enum UploadStatus { initial, uploading, success, failed }

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
