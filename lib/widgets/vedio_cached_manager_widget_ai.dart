import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:teach/data/consts/app_const.dart';
import 'package:uuid/uuid.dart';

class FixedCacheVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? videoId;
  final Widget? offlinePlaceholder;
  final int segmentDuration;

  const FixedCacheVideoPlayer({
    required this.videoUrl,
    this.videoId,
    this.offlinePlaceholder,
    this.segmentDuration = 5,
    Key? key,
  }) : super(key: key);

  @override
  _FixedCacheVideoPlayerState createState() => _FixedCacheVideoPlayerState();
}

class _FixedCacheVideoPlayerState extends State<FixedCacheVideoPlayer> {
  late final String _videoId;
  PodPlayerController? _controller;
  bool _isLoading = true;
  bool _isOffline = false;
  bool _hasCachedContent = false;
  final List<File> _cachedSegments = [];
  Timer? _cacheTimer;
  int _lastCachedSecond = 0;
  double _cachingProgress = 0;
  Duration? _videoDuration;

  @override
  void initState() {
    super.initState();
    _videoId = widget.videoId ?? const Uuid().v8();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _isOffline = !await checkConnection();
      await _loadCachedSegments();

      if (_isOffline) {
        await _initializeOffline();
      } else {
        await _initializeOnline();
        _startCachingTimer();
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _checkNetworkConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadCachedSegments() async {
    final cacheDir = await _getCacheDirectory();
    final segments = await cacheDir
        .list()
        .where((entity) => p.basename(entity.path).startsWith('${_videoId}_'))
        .where((entity) => p.extension(entity.path) == '.mp4')
        .map((entity) => File(entity.path))
        .toList();

    segments.sort((a, b) {
      final aSec = int.parse(p.basename(a.path).split('_')[1].split('.')[0]);
      final bSec = int.parse(p.basename(b.path).split('_')[1].split('.')[0]);
      return aSec.compareTo(bSec);
    });

    if (mounted) {
      setState(() {
        _cachedSegments.addAll(segments);
        _hasCachedContent = segments.isNotEmpty;
        if (segments.isNotEmpty) {
          final lastSegment = p.basename(segments.last.path);
          _lastCachedSecond =
              int.parse(lastSegment.split('_')[1].split('.')[0]);
          _cachingProgress =
              _lastCachedSecond / (_lastCachedSecond + widget.segmentDuration);
        }
      });
    }
  }

  Future<void> _initializeOffline() async {
    print(_cachedSegments);
    print("+++++++++++++++++++");
    if (_cachedSegments.isEmpty) {
      throw Exception('No cached content available for offline playback');
    }

    final virtualFile = await _createVirtualFile();

    if (!await virtualFile.exists() || await virtualFile.length() == 0) {
      throw Exception('Cached file is corrupted');
    }

    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.file(virtualFile),
      podPlayerConfig: _getPlayerConfig(),
    );

    await _controller!.initialise();
  }

  Future<void> _initializeOnline() async {
    _controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(widget.videoUrl),
      podPlayerConfig: _getPlayerConfig(),
    );

    await _controller!.initialise();

    // Listen for video duration when metadata is available
    _controller!.addListener(() {
      final duration = _controller!.videoPlayerValue?.duration;
      if (duration != null && duration.inSeconds > 0) {
        setState(() => _videoDuration = duration);
      }
    });
  }

  PodPlayerConfig _getPlayerConfig() => PodPlayerConfig(
        autoPlay: false,
        isLooping: false,
        videoQualityPriority: [720, 480, 360],
      );

  void _startCachingTimer() {
    _cacheTimer =
        Timer.periodic(Duration(seconds: widget.segmentDuration), (_) async {
      if (_controller == null || !_controller!.isVideoPlaying) return;

      try {
        final position = _controller!.currentVideoPosition;
        final currentSecond = position.inSeconds;

        if (currentSecond >= _lastCachedSecond) {
          await _cacheVideoSegment(currentSecond);
        }
      } catch (e) {
        print('Error during caching: $e');
      }
    });
  }

  Future<void> _cacheVideoSegment(int currentSecond) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final segmentFile =
          File(p.join(cacheDir.path, '${_videoId}_${currentSecond}.mp4'));

      if (!await segmentFile.exists()) {
        // Estimate content length if we don't have duration
        final estimatedBytesPerSecond =
            200000; // Conservative estimate (adjust as needed)
        final startByte = currentSecond * estimatedBytesPerSecond;
        final endByte =
            startByte + (widget.segmentDuration * estimatedBytesPerSecond);

        final response = await http.get(
          Uri.parse(widget.videoUrl),
          headers: {'Range': 'bytes=$startByte-$endByte'},
        );

        if (response.statusCode == 206) {
          await segmentFile.writeAsBytes(response.bodyBytes);

          if (mounted) {
            setState(() {
              _cachedSegments.add(segmentFile);
              print(_cachedSegments);
              print("+++++++++++++++++++");
              _lastCachedSecond = currentSecond;
              _hasCachedContent = true;
              _cachingProgress = _lastCachedSecond /
                  (_lastCachedSecond + widget.segmentDuration);
            });
          }
        }
      }
    } catch (e) {
      print('Error caching segment: $e');
    }
  }

  Future<File> _createVirtualFile() async {
    final cacheDir = await _getCacheDirectory();
    final outputFile = File(p.join(cacheDir.path, '${_videoId}_full.mp4'));

    if (await outputFile.exists() && await outputFile.length() > 0) {
      return outputFile;
    }

    final sink = await outputFile.open(mode: FileMode.write);

    try {
      for (final segment in _cachedSegments) {
        if (await segment.exists()) {
          final bytes = await segment.readAsBytes();
          await sink.writeFrom(bytes);
        }
      }
    } finally {
      await sink.close();
    }

    return outputFile;
  }

  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(p.join(appDir.path, 'video_cache'));
    if (!await cacheDir.exists()) await cacheDir.create();
    return cacheDir;
  }

  void _handleError(dynamic error) {
    print('Player error: $error');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              _isOffline
                  ? 'Offline: ${error.toString()}'
                  : 'Error: ${error.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cacheTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          width: getWidth(context),
          height: getWidth(context) * .5,
          color: Colors.black,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    }

    if (_controller == null) {
      return widget.offlinePlaceholder ?? _buildDefaultOfflinePlaceholder();
    }

    return Stack(
      children: [
        PodVideoPlayer(
          controller: _controller!,
          podPlayerLabels: PodPlayerLabels(
            play: 'Play',
            pause: 'Pause',
            error: 'Error',
            playbackSpeed: 'Speed',
            settings: 'Settings',
          ),
        ),
        // if (!_isOffline && _cachingProgress < 1.0)
        //   Positioned(
        //     bottom: 20,
        //     left: 20,
        //     right: 20,
        //     child: LinearProgressIndicator(
        //       value: _cachingProgress,
        //       backgroundColor: Colors.grey[300],
        //       color: Colors.blue,
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildDefaultOfflinePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_off, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            _hasCachedContent
                ? 'Cached content available (${_lastCachedSecond}s)'
                : 'No cached content available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          if (_hasCachedContent)
            ElevatedButton(
              onPressed: () => _initializeOffline(),
              child: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  'Play Cached Content'),
            ),
          if (!_hasCachedContent)
            AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              'Please play this video online first to cache it',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
