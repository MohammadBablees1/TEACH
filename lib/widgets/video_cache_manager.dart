import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
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
          stalePeriod: const Duration(days: 365), // تأكد من هذا الإعداد
          maxNrOfCacheObjects: 1000,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileSystem: IOFileSystem(key),
          fileService: HttpFileService(),
        ));

  // دالة جديدة لعرض الإعدادات
  void debugCacheSettings() {
    if (!kDebugMode) return;
    
    final config = Config(key);
    if (kDebugMode) {
      print('''
🎯 VideoCacheManager Configuration:
   - Stale Period: ${config.stalePeriod}
   - Max Cache Objects: ${config.maxNrOfCacheObjects}
   - Cache Key: ${config.key}
   - File System: ${config.fileSystem}
''');
    }
  }

  // دالة للحصول على معلومات الكاش
  Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final directory = await getTemporaryDirectory();
      final cacheDir = Directory('${directory.path}/$key');
      
      int fileCount = 0;
      int totalSize = 0;
      
      if (await cacheDir.exists()) {
        final files = await cacheDir.list().toList();
        fileCount = files.length;
        
        for (final file in files) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
      
      return {
        'stalePeriod': Config(key).stalePeriod,
        'maxNrOfCacheObjects': Config(key).maxNrOfCacheObjects,
        'cacheDirectory': cacheDir.path,
        'fileCount': fileCount,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

extension on Config {
  get key => null;
}