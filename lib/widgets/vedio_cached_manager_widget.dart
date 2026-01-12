import 'package:flutter/foundation.dart';
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
  final bool autoCache; // إضافة خاصية التخزين التلقائي

  const CachedVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
    this.showControls = true,
    this.showCacheButton = true,
    this.autoCache = true, // التخزين التلقائي مفعل افتراضياً
  });

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
  bool _autoCacheStarted = false;

  @override
  void initState() {
    super.initState();
    _checkCacheStatus();
    _initializeVideo();
  }

  Future<void> _checkCacheStatus() async {
    try {
      final fileInfo =
          await VideoCacheManager().getFileFromCache(widget.videoUrl);
      if (fileInfo != null && await fileInfo.file.exists()) {
        if (mounted) {
          print("+++++cached+++++");
          setState(() {
            _isCached = true;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking cache status: $e');
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      final fileInfo =
          await VideoCacheManager().getFileFromCache(widget.videoUrl);

      if (fileInfo != null && fileInfo.file.existsSync()) {
        _setupController(PlayVideoFrom.file(fileInfo.file));
        setState(() {
          _isCached = true;
          _isLoading = false;
        });
      } else {
        _setupController(PlayVideoFrom.network(widget.videoUrl));
        setState(() => _isLoading = false);

        // بدء التخزين التلقائي بعد تحميل الفيديو مباشرة
        if (widget.autoCache && !_autoCacheStarted) {
          _startAutoCaching();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
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
        if (kDebugMode) {
          print('Controller initialization error: $error');
        }
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      });
  }

  void _startAutoCaching() {
    if (_autoCacheStarted || _isCached) return;

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isCached) {
        _startCaching(isManual: false);
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
    } else {
      setState(() {
        _showProgress = true;
        _loadingMessage = getDeviceLocale() == "ar"
            ? "تحميل الفيديو ..."
            : "Download video...";
      });
    }

    _downloadStream = VideoCacheManager().getFileStream(
      widget.videoUrl,
      withProgress: true,
    );

    _downloadStream?.listen(
      (FileResponse response) async {
        if (response is DownloadProgress) {
          if (mounted) {
            setState(() {
              _cacheProgress = response.progress;
              _showProgress = true;
            });
          }
        } else if (response is FileInfo) {
          // تأكيد حفظ الملف بشكل دائم
          try {
            final file = response.file;
            if (await file.exists()) {
              // حفظ معلومات الملف في الكاش بشكل دائم
              await VideoCacheManager()
                  .putFile(widget.videoUrl, file.readAsBytesSync());

              if (mounted) {
                setState(() {
                  _isCached = true;
                  _showProgress = false;
                  _isCachingManually = false;
                  _cacheProgress = 1.0;
                });
              }

              if (isManual) {
                _reloadVideoFromCache();
              }

              if (kDebugMode) {
                print('Video cached successfully: ${file.path}');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error confirming cache: $e');
            }
          }
          // إشعار المستخدم باكتمال التخزين
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                getDeviceLocale() == "ar"
                    ? 'تم تخزين الفيديو بنجاح'
                    : 'Video saved successfully',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          // if (mounted) {
          //   setState(() {
          //     _isCached = true;
          //     _showProgress = false;
          //     _isCachingManually = false;
          //   });

          //   if (isManual) {
          //     _reloadVideoFromCache();
          //   }
          // }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Cache error: $error');
        }
        if (mounted) {
          setState(() {
            _showProgress = false;
            _isCachingManually = false;
            _autoCacheStarted = false;
          });
        }
      },
      cancelOnError: true,
    );
  }

  Future<void> _reloadVideoFromCache() async {
    try {
      final fileInfo =
          await VideoCacheManager().getFileFromCache(widget.videoUrl);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        await controller.changeVideo(
            playVideoFrom: PlayVideoFrom.file(fileInfo.file));
        if (mounted) {
          setState(() {
            _isCached = true;
          });
        }
      } else {
        // إذا لم يوجد الملف في الذاكرة، نعيد تحميله من الشبكة
        setState(() {
          _isCached = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reloading from cache: $e');
      }
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _showProgress = false;
      _autoCacheStarted = false;
    });
    _initializeVideo();
  }

  @override
  void dispose() {
    _downloadStream = null;
    controller.dispose();
    super.dispose();
  }

  Future<void> _verifyCacheStatus() async {
    if (!_isCached && !_showProgress) {
      final fileInfo =
          await VideoCacheManager().getFileFromCache(widget.videoUrl);
      if (fileInfo != null && await fileInfo.file.exists() && mounted) {
        setState(() {
          _isCached = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحقق إضافي من حالة الذاكرة المؤقتة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyCacheStatus();
    });
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // حاوية الفيديو مع العناصر العلوية
        SizedBox(
          width: getWidth(context),
          height: getWidth(context) * 9 / 16,
          child: Stack(
            children: [
              PodVideoPlayer(
                controller: controller,
                podPlayerLabels: const PodPlayerLabels(
                  play: "تشغيل",
                  pause: "إيقاف",
                  error: "خطأ في تحميل الفيديو",
                  playbackSpeed: "سرعة التشغيل",
                ),
              ),

              // مؤشر "مخزن" في أعلى اليمين
              if (_isCached && !_showProgress)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      getDeviceLocale() == "ar" ? 'مخزن' : "stored",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              // مؤشر التخزين التلقائي في أعلى اليسار
              if (_showProgress && !_isCachingManually)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      getDeviceLocale() == "ar"
                          ? 'تخزين تلقائي'
                          : 'Automatic storage',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // شريط تقدم التخزين
        if (_showProgress)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _loadingMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _cacheProgress,
                  backgroundColor: Colors.grey[300],
                  color: _isCachingManually ? Colors.blue : Colors.green,
                  minHeight: 6,
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
