import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/modules/user_plus.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/main.dart';
part 'teach_state.dart';

class TeachCubit extends Cubit<TeachState> {
  TeachCubit() : super(TeachInitial()) {}

  Future<bool> checkConnection() async {
    await checkSignIn();

    // final listener =
    //     InternetConnection().onStatusChange.listen((InternetStatus status) {
    //   switch (status) {
    //     case InternetStatus.connected:
    //       emit(Connected());

    //       break;
    //     case InternetStatus.disconnected:
    //       emit(NotConnected());
    //       break;
    //   }
    // });
    // listener.cancel();
    return true;
  }

  checkSignIn() async {
    var box = Hive.box(hiveBoxName);
    var user = box.get(isStudent);
    var mainManager = box.get(isMainManager);
    var manager = box.get(isManager);
    var currentUser = supabase.auth.currentUser;
    if ((user == null &&
        mainManager == null &&
        manager == null &&
        currentUser == null)) {
      emit(NoUSerFound());
    } else {
      // var data = await FirebaseFirestore.instance
      //     .collection("update")
      //     .doc("09pJXphQbASA10QcPhby")
      //     .get();
      // var isUpdateReq = await data.data()!["is_updated"];
      // if (isUpdateReq) {
      //   emit(UpdateApp());
      // } else {
      emit(UserFound());
      // }
    }
  }

  createNewUser(Map<String, dynamic> userInfo, password, email, name) async {
    var user = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    var id = user.user!.id;

    userInfo.addAll({"id": id});
    await supabase.from('current_user').insert(userInfo);
    // await FirebaseFirestore.instance.collection("user").doc(id).set(userInfo);
  }

  // createMainManager(UserPlus visiterPlus) async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: visiterPlus.email, password: visiterPlus.password);

  //   await FirebaseFirestore.instance
  //       .collection("user_plus")
  //       .doc("main_manager")
  //       .set(visiterPlus.toFirebaseJson());
  // }

  void changeSelectedAcount(acount) {
    emit(SelectedAcount(selected: acount));
  }

  Future<void> uploadFile(File file, name) async {
    try {
      final String fullPath = await supabase.storage.from('cruces').upload(
            '$name/icon.jpg',
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> createAd(
    File file,
    String cateName,
    String grade,
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
      print("Generated URL: $imageUrl"); // Debug print
      // 5. Store metadata in Supabase Database

      await supabase
          .from('ads') // Your table name
          .insert({
        'imageUrl': imageUrl,
        'category': cateName,
        'grade': grade,
        'collage': collage,
        "name": fileName,
      });
    } catch (e) {
      print("Error occurred: $e");

      rethrow;
    } finally {}
  }
  // Future<void> createAd(file, cateName, grade, collage) async {
  //   try {

  //     var ref =
  //         FirebaseStorage.instance.ref("ads").child(DateTime.now().toString());

  //     var uploadTask = ref.putFile(File(file.path));

  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double percentageAds = snapshot.bytesTransferred / snapshot.totalBytes;

  //       emit(Percentage(percent: percentageAds)); // Update the UI
  //     });

  //     await uploadTask;

  //     String imageUrl = await ref.getDownloadURL();
  //     await FirebaseFirestore.instance.collection('ads').add({
  //       'imageUrl': imageUrl,
  //       "category": cateName,
  //       "grade": grade,
  //       "collage": collage
  //     });
  //     // emit(TeachInitial());
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     // emit(TeachInitial());
  //   }
  // }

  Future<List> getAllAds() async {
    // FirebaseFirestore.instance.settings = const Settings(
    //   persistenceEnabled: true,
    // );
    var box = Hive.box(hiveBoxName);

    var ads;
    if (box.get(isStudent)) {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);
      var checkCollage = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id)
          .filter("collage", "is", null)
          .maybeSingle();
      if (checkCollage == null) {
        ads = await supabase
            .from("ads")
            .select()
            .eq("category", data[0]["grade"])
            .eq("grade", data[0]["category"]);
      } else {
        ads = await supabase
            .from("ads")
            .select()
            .eq("category", data[0]["grade"])
            .eq("grade", data[0]["category"])
            .eq("collage", data[0]["collage"]);
      }
    } else {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);
      ads = await supabase.from("ads").select();
    }
//GetOptions(source: Source.cache)
    return ads;
  }

  Future<void> deleteAd(ad) async {
    try {
      List<String> path = [];
      path.add(ad["name"]);
      await supabase.storage.from("ads").remove(path);
      await supabase.from("ads").delete().eq("id", ad["id"]);
    } catch (e) {}
  }

  Future<void> editAd(ad, image, newPath, id) async {
    try {
      var url = "";
      final imageFile = File(newPath);
      if (imageFile.existsSync()) {
        if (image) {
          await supabase.storage
              .from('ads') // e.g., 'profile-pictures'
              .update(
                id["name"], // Same path as the old image
                imageFile,
                fileOptions: FileOptions(
                  upsert: true, // Overwrite if exists
                ),
              );
          url = supabase.storage.from("ads").getPublicUrl(newPath);
          ad["imageUrl"] = url;
        }
      }

      await supabase.from("ads").update(ad).eq("id", id["id"]);
      // ignore: empty_catches
    } catch (e) {}
  }
}

String extractPathFromPublicUrl(String publicUrl) {
  final uri = Uri.parse(publicUrl);
  // Split the path and take everything after '/public/'
  final parts = uri.path.split('/public/');
  return parts.length > 1 ? parts[1] : '';
}

// extension on TaskSnapshot {
//   get snapshotEvents => null;
// }
