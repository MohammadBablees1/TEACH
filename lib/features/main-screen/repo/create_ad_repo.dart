import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:teach/main.dart';

class CreateAdRepo {


 Future<void> createAd(
    File file,
    String collage,
  ) async {
    try {
      // 1. Generate unique filename
      //  final fileName = 'ads/${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ads/$timestamp${extension(file.path)}';
      final fileSize = await file.length();
      int bytesUploaded = 0;

      // 2. Create progress-tracking stream

      final encodedFileName = Uri.encodeComponent(fileName);
      // 3. Upload to Supabase Storage
      await supabase.storage
          .from('ads') // Your bucket name
          .upload(
            fileName,
            file,
            // fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // 4. Get public URL
      final imageUrl = supabase.storage.from('ads').getPublicUrl(fileName);
      // Debug print
      // 5. Store metadata in Supabase Database

      await supabase
          .from('ads') // Your table name
          .insert({
        'imageUrl': imageUrl,
        'collage': collage,
        "name": fileName,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred: $e");
      }

      rethrow;
    } finally {}
  }

}