import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:video_player/video_player.dart';

import '../utils/appbar_widget.dart';
import '../values/app_strings.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String pageType;

  const VideoPlayerScreen(
      {super.key, required this.videoUrl, required this.pageType});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      });
    });

    logger.d(widget.videoUrl);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.pageType == "AppStatus"
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: MyAppBar(title: AppStrings.videoPreview),
            ),
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
