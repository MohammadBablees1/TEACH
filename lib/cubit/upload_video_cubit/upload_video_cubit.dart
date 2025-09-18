import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:supabase_progress_uploads/supabase_progress_uploads.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

part 'upload_video_state.dart';

class UploadVideoCubit extends Cubit<UploadVideoState> {
  UploadVideoCubit() : super(UploadVideoInitial()) {}
  Future<String?> uploadFile(
      String filePath, String videoName, len, position) async {
    try{
      var box = Hive.box(hiveBoxName);
    var percent = box.get("per");
    if (percent == null) {
      box.put("per", 0.0);
    }
    var value = box.get("per");

    var color = getRandomColorWithOpacity();
    emit(ChangePercentage(percent: value, color: color));

    final file = File(filePath);
    final uploadService = SupabaseUploadService(supabase, 'curces');

    final response = await uploadService.uploadFile(
      XFile(file.path),
      onUploadProgress: (progress) {
        value = ((progress.floor() / 100) * (1 / len)) + box.get("per");

        emit(ChangePercentage(percent: value, color: color));
      },
    );
    box.put("per", value);

// Then move to desired folder

    // Get public URL
    String? publicUrl = response;

    return publicUrl;
    }catch (e, stackTrace) {
  if (kDebugMode) {
    print("Error uploading file: $e");
  }
  if (kDebugMode) {
    print("Stack trace: $stackTrace");
  }
  return null;
}
  }

  String sanitizePath(String path) {
    return path
        .replaceAll(RegExp(r'[^\w\-\./]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
  }

  Future<void> saveCourse({
    required parent_id,
    required String videoPath,
    required List pdfPaths,
    required String courseName,
    required List<String> questions,
    required List choices,
    required List answers,
    required String videoName,
    required String imagePath,
    required bool locked,
    required bool isTeacher,
    required bool isFolder,
    required bool isFree,
    required String price,
    required String size,
    required bool isSubject,
    context,
  }) async {
    try {
      if ((locked || isTeacher || isFolder)) {
        String? imageUrl;
        if (imagePath.isNotEmpty && videoPath.isEmpty && pdfPaths.isEmpty) {
          imageUrl = await uploadFile(imagePath, courseName, 1, 1);
        }
        var sub = await supabase
            .from("folders")
            .select()
            .eq("id", parent_id)
            .maybeSingle();

        String subValue = "";
        if (sub != null &&
            (sub["locked"] || sub["sub"].toString().isNotEmpty) &&
            sub["sub"] != null) {
          subValue =
              sub["sub"] == "" ? parent_id.toString() : sub["sub"].toString();
        }
        await supabase.from("folders").insert({
          "name": courseName,
          "parent_id": parent_id,
          "child_count": "0",
          "image_url": imageUrl,
          "is_teacher": isTeacher,
          "locked": locked,
          "price": price,
          "is-subject": isSubject,
          "sub": subValue,
        });
        var count = await supabase.from("folders").select().eq("id", parent_id);
        int intCount = int.parse(count[0]["child_count"]);

        await supabase.from("folders").update(
            {"child_count": (intCount + 1).toString()}).eq("id", parent_id);
        var box = Hive.box(hiveBoxName);
        box.put("per", 0.0);
      } else if (videoPath.isNotEmpty ||
          pdfPaths.isNotEmpty ||
          questions.isNotEmpty) {
        // ignore: prefer_typing_uninitialized_variables
        var root;
        // ignore: prefer_typing_uninitialized_variables
        var subRoot;
        // ignore: prefer_typing_uninitialized_variables
        var id;
        root = await supabase
            .from("folders")
            .select()
            .eq("id", id ?? parent_id)
            .maybeSingle();
        while (root["parent_id"] != null) {
          var folder = await supabase
              .from("folders")
              .select()
              .eq("id", id ?? parent_id)
              .maybeSingle();
          id = folder!["parent_id"];
          root = folder;
          if (id == null) {
            break;
          }

          subRoot = root;
        }

        var check = await supabase
            .from("curces")
            .select()
            .eq("folder_id", parent_id)
            .eq("name", courseName)
            .maybeSingle();
        var checkLocked =
            await supabase.from("folders").select().eq("id", parent_id);
        if (check != null) {
          lunchAwesomDialoge(
              DialogType.error,
              "e",
              getDeviceLocale() == "ar"
                  ? "الملف موجود بالفعل"
                  : "The file already exists",
              context,
              getWidth(context),
              getHeight(context));
        } else {
          int len = pdfPaths.length + (videoPath.isNotEmpty ? 1 : 0) + 1;
          double percent = 0.0;
          // Upload files
          // ignore: prefer_typing_uninitialized_variables
          var videoUrl;
          // ignore: prefer_typing_uninitialized_variables
          var imageUrl;
          if (videoPath.isNotEmpty) {
            videoUrl =
                await uploadFile(videoPath, parent_id.toString(), len, 1);
          }

          final pdfUrls = [];
          for (var i = 0; i < pdfPaths.length; i++) {
            var pdfUrl = await uploadFile(
                pdfPaths[i].path, parent_id.toString(), len, i + 2);

            pdfUrls.add(pdfUrl);
          }
          if (imagePath.isNotEmpty) {
            imageUrl = await uploadFile(imagePath, courseName, len, len);
          }

          // Save course data
          if (questions.isEmpty) {
            questions = [];
            answers = [];
            choices = [];
          }

          var checkData = await supabase
              .from("folders")
              .select()
              .eq("id", parent_id)
              .maybeSingle();

          while (checkData != null && !checkData["is-subject"]) {
            checkData = await supabase
                .from("folders")
                .select()
                .eq("id", checkData["parent_id"])
                .maybeSingle();
          }
          var sub = await supabase
              .from("folders")
              .select()
              .eq("id", parent_id)
              .maybeSingle();
          String subValue = "";
          if (sub != null &&
              (sub["locked"] || sub["sub"].toString().isNotEmpty) &&
              sub["sub"] != null) {
            subValue =
                sub["sub"] == "" ? parent_id.toString() : sub["sub"].toString();
          }
        
          await supabase.from('curces').insert({
            'folder_id': parent_id,
            'name': courseName.toString().trim(),
            'url': videoUrl ?? "",
            "pdf_urls": pdfUrls,
            'que': questions,
            'choose': choices,
            'ans': answers,
            "watchers": [],
            "grade": root["name"],
            "class": subRoot["name"],
            "image_url": imageUrl,
            "is_free": isFree,
            "size": size,
            "subject-folder": checkData!["id"],
            "sub": subValue,
          });

          var count =
              await supabase.from("folders").select().eq("id", parent_id);
          int intCount = int.parse(count[0]["child_count"]);

          await supabase.from("folders").update(
              {"child_count": (intCount + 1).toString()}).eq("id", parent_id);
          var box = Hive.box(hiveBoxName);
          box.put("per", 0.0);
        }
      }
    } catch (e) {
      var box = Hive.box(hiveBoxName);
      box.put("per", 0.0);
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
