import 'dart:io';
import 'dart:typed_data';
import 'package:get_thumbnail_video/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

part 'upload_video_state.dart';

class UploadVideoCubit extends Cubit<UploadVideoState> {
  UploadVideoCubit() : super(UploadVideoInitial()) {}
  Future<String?> uploadFile(String filePath, String folderName,
      String fileName, String videoName) async {
    final file = File(filePath);

    final fileExtension = filePath.split('.').last;
    String sanitized = videoName.replaceAll(RegExp(r'[^\w\-\.]'), '_');
    sanitized = sanitized.replaceAll(RegExp(r'_+'), '_');

    // Remove leading/trailing underscores
    sanitized = sanitized.replaceAll(RegExp(r'^_|_$'), '');

    final storagePath = '$folderName/$sanitized/$fileName.$fileExtension';

    final response =
        await supabase.storage.from('curces').upload(storagePath, file);

    // Get public URL
    final String publicUrl =
        supabase.storage.from('curces').getPublicUrl(storagePath);

    return publicUrl;
  }

  Future<void> saveCourse({
    required String videoPath,
    required List pdfPaths,
    required String courseName,
    required List<String> questions,
    required List choices,
    required List answers,
    required String videoName,
    context,
  }) async {
    // First create a folder
    var name = videoName.split("/").last.split(".").first;
    var id = await supabase.from("folders").select("id").eq("name", courseName);
    var check = await supabase
        .from("curces")
        .select()
        .eq("folder_id", id[0]["id"])
        .eq("name", name)
        .maybeSingle();

    if (check != null) {
      lunchAwesomDialoge(
          DialogType.error,
          "e",
          getDeviceLocale() == "ar"
              ? "الفيديو موجود بالفعل"
              : "The video already exists",
          context,
          getWidth(context),
          getHeight(context));
    } else {
      int len = pdfPaths.length + 1;
      double percent = 0.0;
      // Upload files
      emit(ChangePercentage(percent: percent));
      final videoUrl = await uploadFile(videoPath, id[0]["id"].toString(), 'video', name);
      percent = (1 / len);
      emit(ChangePercentage(percent: percent));
      final pdfUrls = [];
      for (var i = 0; i < pdfPaths.length; i++) {
        var pdfUrl = await uploadFile(
            pdfPaths[i].path, id[0]["id"].toString(), 'document${DateTime.now()}', name);
        pdfUrls.add(pdfUrl);
        percent = percent + (1 / len);
        emit(ChangePercentage(percent: percent));
      }

      // Save course data
      await supabase.from('curces').insert({
        'folder_id': id[0]["id"],
        'name': name,
        'url': videoUrl,
        "pdf_urls": pdfUrls,
        'que': questions,
        'choose': choices,
        'ans': answers,
        "watchers": []
      });
    }
  }

  uploadeVideo(XFile files, String ref, pdfFiles, questions, choices, answers,
      context) async {
    var refCheck = await FirebaseFirestore.instance
        .collection("videos")
        .doc(files.name)
        .get();
    await FirebaseFirestore.instance
        .collection("Course_path")
        .doc(ref.split("/").join("-"))
        .set({"sold": "0"});
    if (refCheck.exists) {
      lunchAwesomDialoge(
          DialogType.error,
          "e",
          getDeviceLocale() == "ar"
              ? "الفيديو موجود مسبقاً"
              : "The video already exists.",
          context,
          getWidth(context),
          getHeight(context));
    } else {
      emit(ChangePercentage(percent: 0.0));

      var bytes1 = 0.0;
      var bytes2 = [];
      for (var i = 0; i < pdfFiles.length; i++) {
        bytes2.add(0.0);
      }
      var len = pdfFiles.length + 1;
      File file = File(files.path);

      if (await file.exists()) {
        final uint8list = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128,
          quality: 25,
        );

        var ref1 = FirebaseStorage.instance
            .ref("$ref/${files.name}")
            .child(files.name);
        var ref6 = FirebaseStorage.instance
            .ref("$ref/${files.name}")
            .child("thumbnails.jpg");
        var uploadTask = ref1.putFile(file);

        uploadTask.snapshotEvents.listen(
          (event) {
            bytes1 = (event.bytesTransferred / event.totalBytes);
            uodateValue(bytes1, [0.0], len);
          },
        );

        await uploadTask;
        await ref6.putData(uint8list);
        final downloadUrlOfThumb = await ref6.getDownloadURL();
        var ref3 = FirebaseStorage.instance.ref("$ref");
        var folder = await ref3.list();

        if (folder.items.isNotEmpty) {
          await ref3.child("folder").delete();
        }
        var downloadUrl = [];
        var videoUrl = [];

        for (var i = 0; i < pdfFiles.length; i++) {
          File pdfFile = File(pdfFiles[i].path);
          if (await pdfFile.exists()) {
            var ref2 = FirebaseStorage.instance
                .ref("$ref/${files.name}")
                .child(pdfFiles[i].name);

            var uploadPdf = ref2.putFile(pdfFile);

            uploadPdf.snapshotEvents.listen(
              (event) {
                bytes2[i] = (event.bytesTransferred / event.totalBytes);
                uodateValue(bytes1, bytes2, len);
              },
            );

            await uploadPdf;

            downloadUrl.add(await ref2.getDownloadURL());

            videoUrl.add(await ref1.getDownloadURL());
          } else {}
        }

        await FirebaseFirestore.instance
            .collection("videos")
            .doc("${files.name}")
            .set({
          "videoUrl": videoUrl[0],
          "pdfUrl": downloadUrl,
          "thumbUrl": downloadUrlOfThumb,
          "qustions": questions,
          "choices": choices,
          "answers": answers,
          "wathers": [],
        });
      }
    }
  }

  void uodateValue(double bytes1, bytes2, len) {
    var newValue = bytes1 / len;
    for (var i = 0; i < bytes2.length; i++) {
      newValue = newValue + (bytes2[i] / len);
    }
    emit(ChangePercentage(percent: newValue));
  }
}
