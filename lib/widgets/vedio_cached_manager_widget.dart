import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/widgets/video_cache_manager.dart';

class CachedVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CachedVideoPlayer({required this.videoUrl});

  @override
  _CachedVideoPlayerState createState() => _CachedVideoPlayerState();
}

class _CachedVideoPlayerState extends State<CachedVideoPlayer> {
  late final PodPlayerController controller;
  bool _isLoading = true;
  bool _isCached = false;
  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    // Get the cached video file
    final file = await VideoCacheManager().getSingleFile(widget.videoUrl);
    _isCached = await file.exists();
    // Initialize the video player controller
    controller = PodPlayerController(
        playVideoFrom: _isCached ? PlayVideoFrom.file(file) : PlayVideoFrom.network(widget.videoUrl),
        podPlayerConfig: PodPlayerConfig(
          isLooping: true,
        ))
      ..initialise().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            width: getWidth(context),
            height: getWidth(context),
            color: Colors.black,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ))) // Show a loader while the video is loading
        : PodVideoPlayer(
            controller: controller,
          );
  }
}
