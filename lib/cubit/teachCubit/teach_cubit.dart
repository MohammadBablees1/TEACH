import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/core/wait_for_session.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';
part 'teach_state.dart';

class TeachCubit extends Cubit<TeachState> {
  TeachCubit() : super(TeachInitial());
  bool _checkedOnce = false;
  Future<bool> checkConnection() async {
    if (_checkedOnce) return true;
    _checkedOnce = true;
    await checkSignIn();

    return true;
  }

  checkSignIn() async {
    // if (!Hive.isBoxOpen(hiveBoxName)) {
    //   // Hive غير جاهز بعد
    //   emit(TeachInitial());
    //   return;
    // }
    var box = Hive.box(hiveBoxName);
    var user = box.get(isStudent);
    var mainManager = box.get(isMainManager);
    var manager = box.get(isManager);

    final currentUser = supabase.auth.currentUser;

    if (user == null &&
        mainManager == null &&
        manager == null &&
        currentUser == null) {
      emit(NoUSerFound());
      return;
    }

    try {
      /// 🔥 هذا هو السطر الحاسم
      await ensureFreshSession();

      final lastVersion =
          await supabase.from("last_version").select().eq("id", 1).single();

      if (appVersion == lastVersion["version"]) {
        emit(UserFound());
      } else if (lastVersion["forced"] == true) {
        emit(UpdateRecomended());
      } else {
        emit(UserFound());
      }
    } catch (e, s) {
      debugPrint("❌ Supabase error: $e");
      debugPrintStack(stackTrace: s);
      emit(NoUSerFound());
    }
  }

  createNewUser(Map<String, dynamic> userInfo, password, email, name) async {
    var user = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    var box = Hive.box(hiveBoxName);
    box.put("student_name", userInfo["name"]);
    box.put(isStudent, true);
    box.put(isMainManager, false);
    box.put(isManager, false);
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
    var user = supabase.auth.currentUser;
    if (user == null) {
      return ["null"];
    } else {
      var ads;
      try {
        if (box.get(isStudent)) {
          try {
            var data = await supabase
                .from("current_user")
                .select()
                .eq("id", supabase.auth.currentUser!.id);

            ads = await supabase
                .from("ads")
                .select()
                .eq("collage", data[0]["category"]);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        } else {
          ads = await supabase.from("ads").select();
        }
      } catch (e) {
        print(e);
      }
      return ads;
    }

//GetOptions(source: Source.cache)
  }

  Future<void> deleteAd(ad) async {
    try {
      print(ad);
      List<String> path = [];
      path.add(ad["name"].toString());
      await supabase.storage.from("ads").remove(path);
      await supabase
          .from("ads")
          .delete()
          .eq("id", int.parse(ad["id"].toString()));
    } catch (e) {
      print(e);
    }
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
