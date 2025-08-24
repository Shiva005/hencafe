import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/contact_history_model.dart';
import 'package:hencafe/services/services.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/attachment_model.dart';
import '../../values/app_colors.dart';
import '../../values/app_icons.dart';
import '../../widget/docs_preview_widget.dart';
import '../image_preview_screen.dart';
import '../video_player_screen.dart';

class AppStatusScreen extends StatefulWidget {
  const AppStatusScreen({super.key});

  @override
  State<AppStatusScreen> createState() => _AppStatusScreenState();
}

class _AppStatusScreenState extends State<AppStatusScreen> {
  List<ApiResponse> complaintList = [];
  bool isLoading = true;
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    fetchContactHistory();
  }

  Future<void> fetchContactHistory() async {
    setState(() => isLoading = true);
    final contactData = await AuthServices().getContactHistory(
      context,
      "APP_STATUS",
      "",
    );

    setState(() {
      complaintList = contactData.apiResponse ?? [];
      isExpandedList = List.generate(complaintList.length, (_) => false);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaintList.isEmpty
          ? const Center(child: Text('No data available'))
          : RefreshIndicator(
              onRefresh: fetchContactHistory,
              child: ListView.builder(
                itemCount: complaintList.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = complaintList[index];
                  final isExpanded = isExpandedList[index];
                  final fullText = item.subjectLanguage ?? "No Subject";
                  final isLongText = fullText.length > 160;

                  return Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpanded || !isLongText
                              ? fullText
                              : "${fullText.substring(0, 160)}...",
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (isLongText) ...[
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpandedList[index] = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? "Show Less" : "Show More",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 15),
                        if (item.attachmentInfo != null &&
                            item.attachmentInfo!.isNotEmpty)
                          _buildList(context, item.attachmentInfo!),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildList(BuildContext context, List<AttachmentInfo> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final att = data[index];
        final path = att.attachmentPath ?? '';
        final fileName = att.attachmentName ?? '';

        Widget mediaWidget;
        switch (att.attachmentType) {
          case 'image':
            mediaWidget = SizedBox(
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
            break;

          case 'video':
            final videoController = VideoPlayerController.network(path);
            mediaWidget = SizedBox(
              height: 350,
              child: Stack(
                children: [
                  FutureBuilder(
                    future: videoController.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Chewie(
                            controller: ChewieController(
                              videoPlayerController: videoController,
                              aspectRatio: videoController.value.aspectRatio,
                              autoPlay: false,
                              looping: false,
                              showControls: false,
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Image.asset(
                        AppIconsData.play_gif,
                        fit: BoxFit.contain,
                        height: 70,
                        width: 70, // add width for perfect circle
                      ),
                    ),
                  ),
                ],
              ),
            );
            break;
          case "youtube":
            final videoId = YoutubePlayer.convertUrlToId(path);
            if (videoId != null) {
              mediaWidget = Container(
                height: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      "https://img.youtube.com/vi/$videoId/0.jpg", // YouTube thumbnail
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: Image.asset(
                          AppIconsData.play_gif,
                          fit: BoxFit.contain,
                          height: 70,
                          width: 70, // add width for perfect circle
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              mediaWidget = const Icon(Icons.error, color: Colors.red);
            }
            break;
          case 'pdf':
          case 'doc':
          case 'docx':
            mediaWidget = Container(
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: AbsorbPointer(
                absorbing: true,
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setBackgroundColor(Colors.transparent)
                    ..loadRequest(
                      Uri.parse(
                        "https://docs.google.com/gview?embedded=true&url=$path",
                      ),
                    ),
                ),
              ),
            );
            break;

          default:
            mediaWidget = Container(
              height: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.insert_drive_file, color: Colors.blue),
            );
        }
        return GestureDetector(
          onTap: () {
            if (att.attachmentType == 'image') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ImagePreviewScreen(imageUrl: path, pageType: "AppStatus"),
                ),
              );
            } else if (att.attachmentType == 'video') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VideoPlayerScreen(videoUrl: path, pageType: "AppStatus"),
                ),
              );
            } else if (att.attachmentType == 'youtube') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VideoPlayerScreen(videoUrl: path, pageType: "AppStatus"),
                ),
              );
            } else if (['pdf', 'doc', 'docx'].contains(att.attachmentType)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DocumentPreviewScreen(url: path, pageType: "AppStatus"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unsupported file format")),
              );
            }
          },
          child: Column(
            children: [
              SizedBox(width: double.maxFinite, child: mediaWidget),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
