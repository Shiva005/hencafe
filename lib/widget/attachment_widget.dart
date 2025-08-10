import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/widget/docs_preview_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/attachment_model.dart';
import '../screens/image_preview_screen.dart';
import '../screens/video_player_screen.dart';
import '../values/app_colors.dart';

class AttachmentWidget extends StatefulWidget {
  final List<AttachmentInfo> attachments;
  final String userId;
  final String currentUserId;
  final Function(int index) onDelete;
  final int index;

  const AttachmentWidget({
    super.key,
    required this.attachments,
    required this.userId,
    required this.currentUserId,
    required this.onDelete,
    required this.index,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        widget.attachments[widget.index].attachmentPath!);
    _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        showControls: false,
      );
      setState(() {
        _isVideoInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
                          .toList()),
                  _buildGrid(
                      context,
                      widget.attachments
                          .where((e) => e.attachmentType == 'video')
                          .toList()),
                  _buildGrid(
                      context,
                      widget.attachments
                          .where((e) =>
                              ['pdf', 'doc', 'docx'].contains(e.attachmentType))
                          .toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<AttachmentInfo> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No attachments found."));
    }

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
              child: Image.network(path,
                  fit: BoxFit.cover, height: 150, width: double.infinity),
            );
            break;
          case 'video':
            mediaWidget = Container(
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              child: _isVideoInitialized && _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(),
            );
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
                    ..loadRequest(Uri.parse(
                        "https://docs.google.com/gview?embedded=true&url=$path")),
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
                    builder: (_) => ImagePreviewScreen(imageUrl: path),
                  ));
            } else if (att.attachmentType == 'video') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(videoUrl: path),
                  ));
            } else if (['pdf', 'doc', 'docx'].contains(att.attachmentType)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentPreviewScreen(url: path),
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
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
                        child: Icon(Icons.delete_forever,
                            size: 16, color: Colors.white),
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
