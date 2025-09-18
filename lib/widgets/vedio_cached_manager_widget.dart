import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pod_player/pod_player.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/widgets/video_cache_manager.dart';

class CachedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;
  final bool showCacheButton;

  const CachedVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.autoPlay = true,
    this.showControls = true,
    this.showCacheButton = true,
  }) : super(key: key);

  @override
  _CachedVideoPlayerState createState() => _CachedVideoPlayerState();
}

class _CachedVideoPlayerState extends State<CachedVideoPlayer> {
  late final PodPlayerController controller;
  bool _isLoading = true;
  bool _isCached = false;
  bool _hasError = false;
  double? _cacheProgress = 0;
  bool _showProgress = false;
  Stream<FileResponse>? _downloadStream;
  String _loadingMessage = 'جاري تحميل الفيديو';
  bool _isCachingManually = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // التحقق من وجود نسخة مخبأة أولاً
      final fileInfo = await VideoCacheManager().getFileFromCache(widget.videoUrl);
      
      if (fileInfo != null && fileInfo.file.existsSync()) {
        // استخدام النسخة المخبأة
        _setupController(PlayVideoFrom.file(fileInfo.file));
        setState(() {
          _isCached = true;
          _isLoading = false;
        });
      } else {
        // التشغيل من الإنترنت
        _setupController(PlayVideoFrom.network(widget.videoUrl));
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _setupController(PlayVideoFrom videoSource) {
    controller = PodPlayerController(
      playVideoFrom: videoSource,
      podPlayerConfig: PodPlayerConfig(
        autoPlay: widget.autoPlay,
        isLooping: false,
        videoQualityPriority: [720, 480, 360],
      ),
    )..initialise().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        print('Controller initialization error: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      });
  }

  void _startCaching({bool isManual = false}) {
    if (isManual) {
      setState(() {
        _isCachingManually = true;
        _showProgress = true;
        _loadingMessage = 'جاري تخزين الفيديو';
      });
    }
    
    _downloadStream = VideoCacheManager().getFileStream(
      widget.videoUrl,
      withProgress: true,
    );
    
    _downloadStream?.listen(
      (FileResponse response) {
        if (response is DownloadProgress) {
          if (mounted) {
            setState(() {
              _cacheProgress = response.progress;
              _showProgress = true;
            });
          }
        } else if (response is FileInfo) {
          if (mounted) {
            setState(() {
              _isCached = true;
              _showProgress = false;
              _isCachingManually = false;
            });
            
            // إعادة تحميل الفيديو من الذاكرة المؤقتة بعد التخزين
            if (isManual) {
              _reloadVideoFromCache();
            }
          }
        }
      },
      onError: (error) {
        print('Cache error: $error');
        if (mounted) {
          setState(() {
            _showProgress = false;
            _isCachingManually = false;
          });
        }
      },
      cancelOnError: true,
    );
  }

  Future<void> _reloadVideoFromCache() async {
    try {
      final fileInfo = await VideoCacheManager().getFileFromCache(widget.videoUrl);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        await controller.changeVideo(playVideoFrom:  PlayVideoFrom.file(fileInfo.file));
      }
    } catch (e) {
      print('Error reloading from cache: $e');
    }
  }

  Future<void> _clearCache() async {
    try {
      await VideoCacheManager().removeFile(widget.videoUrl);
      setState(() {
        _isCached = false;
      });
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _showProgress = false;
    });
    _initializeVideo();
  }

  @override
  void dispose() {
    _downloadStream = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    return Column(
    //  alignment: Alignment.bottomCenter,
      children: [
        PodVideoPlayer(
          controller: controller,
          podPlayerLabels: const PodPlayerLabels(
            play: "تشغيل",
            pause: "إيقاف",
            error: "خطأ في تحميل الفيديو",
            playbackSpeed: "سرعة التشغيل",
          //  setting: "الإعدادات",
          ),
        ),
        
        // زر التخزين اليدوي
        if (widget.showCacheButton && !_isCached && !_isCachingManually)
          GestureDetector(
            onTap: () => _startCaching(isManual: true),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

        // زر مسح الذاكرة المؤقتة
        if (widget.showCacheButton && _isCached)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _clearCache,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

        // شريط تقدم التخزين
        if (_showProgress)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _loadingMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: _cacheProgress,
                  backgroundColor: Colors.grey[800],
                  color: Colors.blue,
                  minHeight: 4,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(_cacheProgress! * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              
                  
              ],
            ),
          ),

        // مؤشر الذاكرة المؤقتة
        if (_isCached && !_showProgress)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'مخزن',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: getWidth(context),
      height: getWidth(context) * 9 / 16,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            _loadingMessage,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: getWidth(context),
      height: getWidth(context) * 9 / 16,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'فشل تحميل الفيديو',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryLoading,
            child: const Text('إعادة المحاولة'),
          ),
          const SizedBox(height: 8),
          if (!_isCached)
            ElevatedButton(
              onPressed: () => _startCaching(isManual: true),
              child: const Text('محاولة التخزين فقط'),
            ),
        ],
      ),
    );
  }
}