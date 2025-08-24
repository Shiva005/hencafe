import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/widget/docs_preview_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/attachment_model.dart';
import '../screens/image_preview_screen.dart';
import '../screens/video_player_screen.dart';
import '../values/app_colors.dart';
import '../values/app_icons.dart';

class AttachmentWidget extends StatefulWidget {
  final List<AttachmentInfo> attachments;
  final String userId;
  final String currentUserId;
  final String referenceFrom;
  final String referenceUUID;
  final Function(int index) onDelete;
  final int index;
  final String pageType;

  const AttachmentWidget({
    super.key,
    required this.attachments,
    required this.userId,
    required this.currentUserId,
    required this.referenceFrom,
    required this.referenceUUID,
    required this.onDelete,
    required this.index,
    required this.pageType,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, ChewieController> _chewieControllers = {};
  final Set<int> _initializedVideos = {};

  @override
  void dispose() {
    for (var controller in _chewieControllers.values) {
      controller.dispose();
    }
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideo(int index, String url) async {
    if (_videoControllers.containsKey(index)) return; // Already initialized

    final videoController = VideoPlayerController.network(url);
    await videoController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: videoController,
      aspectRatio: videoController.value.aspectRatio,
      autoPlay: false,
      looping: false,
      showControls: false,
    );

    setState(() {
      _videoControllers[index] = videoController;
      _chewieControllers[index] = chewieController;
      _initializedVideos.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Images'),
                      Tab(text: 'Videos'),
                      Tab(text: 'Docs'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildGrid(context, widget.attachments),
                        _buildGrid(
                          context,
                          widget.attachments
                              .where((e) => e.attachmentType == 'image')
                              .toList(),
                        ),
                        _buildGrid(
                          context,
                          widget.attachments
                              .where((e) => e.attachmentType == 'video')
                              .toList(),
                        ),
                        _buildGrid(
                          context,
                          widget.attachments
                              .where(
                                (e) => [
                                  'pdf',
                                  'doc',
                                  'docx',
                                ].contains(e.attachmentType),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<AttachmentInfo> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final att = data[index];
        final path = att.attachmentPath ?? '';
        final fileName = att.attachmentName ?? '';
        index = index;
        Widget mediaWidget;
        switch (att.attachmentType) {
          case 'image':
            mediaWidget = ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                path,
                fit: BoxFit.cover,
                height: 140,
                width: double.infinity,
              ),
            );
            break;
          case 'video':
            if (!_initializedVideos.contains(index)) {
              _initializeVideo(index, path);
            }

            final chewie = _chewieControllers[index];
            mediaWidget = Container(
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              child: chewie != null
                  ? Stack(
                      children: [
                        Chewie(controller: chewie),
                        Center(
                          child: ClipOval(
                            child: Image.asset(
                              AppIconsData.play_gif,
                              fit: BoxFit.contain,
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
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
                      "https://img.youtube.com/vi/$videoId/0.jpg",
                      // YouTube thumbnail
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
                          height: 50,
                          width: 50, // add width for perfect circle
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
          case "pdf":
          case "doc":
          case "docx":
            mediaWidget = Container(
              height: 150,
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
          default:
            mediaWidget = Container(
              height: 150,
              alignment: Alignment.center,
              child: const Icon(Icons.insert_drive_file, color: Colors.blue),
            );
        }

        return GestureDetector(
          onTap: () {
            if (att.attachmentType == 'image') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImagePreviewScreen(
                    imageUrl: path,
                    pageType: "AttachmentWidget",
                  ),
                ),
              );
            } else if (att.attachmentType == 'youtube') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VideoPlayerScreen(videoUrl: path, pageType: "attachment"),
                ),
              );
            } else if (att.attachmentType == 'video') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(
                    videoUrl: path,
                    pageType: "AttachmentWidget",
                  ),
                ),
              );
            } else if (['pdf', 'doc', 'docx'].contains(att.attachmentType)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentPreviewScreen(
                    url: path,
                    pageType: "AttachmentWidget",
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unsupported file format")),
              );
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: mediaWidget,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        fileName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                if (widget.userId == widget.currentUserId)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: GestureDetector(
                      onTap: () => widget.onDelete(index),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.delete_forever,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
