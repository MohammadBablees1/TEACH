import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheManager extends CacheManager {
  static const key = 'videoCache';

  static final VideoCacheManager _instance = VideoCacheManager._();

  factory VideoCacheManager() {
    return _instance;
  }

  VideoCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 30), // Cache files for 30 days
          maxNrOfCacheObjects: 300, // Maximum number of cached files
        ));
}