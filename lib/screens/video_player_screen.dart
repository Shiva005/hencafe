import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/appbar_widget.dart';
import '../values/app_strings.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  YoutubePlayerController? _youtubeController;
  bool isShorts = false;

  String? videoUrl;
  String? pageType;

  bool get isYoutube =>
      videoUrl != null &&
      (videoUrl!.contains("youtube.com") || videoUrl!.contains("youtu.be"));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    videoUrl = args['videoUrl'] ?? '';
    pageType = args['pageType'] ?? '';

    _initializePlayer();
  }

  void _initializePlayer() {
    if (videoUrl == null || videoUrl!.isEmpty) return;

    if (isYoutube) {
      isShorts = videoUrl!.contains("shorts");
      String? videoId = YoutubePlayer.convertUrlToId(videoUrl!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );
      }
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl!),
      );

      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
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
    }

    logger.d("Video URL: $videoUrl");
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: MyAppBar(title: AppStrings.videoPreview),
      ),
      body: Center(
        child: isYoutube
            ? (_youtubeController != null
                  ? AspectRatio(
                      aspectRatio: isShorts ? 9 / 16 : 16 / 9,
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        bottomActions: const [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          FullScreenButton(),
                        ],
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent,
                        ),
                      ),
                    )
                  : const CircularProgressIndicator())
            : (_chewieController != null &&
                      _chewieController!
                          .videoPlayerController
                          .value
                          .isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator()),
      ),
    );
  }
}
