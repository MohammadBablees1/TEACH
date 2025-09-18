import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_progress_uploads/supabase_progress_uploads.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/modules/folders.dart';
import 'package:teach/data/widgets/lunch.dart';

class FolderRepository {
  final SupabaseClient supabase;

  FolderRepository(this.supabase);

  // إنشاء مجلد جديد
  Future<bool> createFolder(String name, context,
      {int? parentId, String? selectedImage}) async {
    try {
      // 1. Check if folder with same name already exists in this location

      // 2. Handle NULL parent_id comparison properly
      if (parentId != null) {
        final query = supabase
            .from('folders')
            .select()
            .eq('name', name)
            .eq('parent_id', parentId);
        final existingFolder = await query.maybeSingle();
        if (existingFolder != null) {
          lunchAwesomDialoge(
              DialogType.warning,
              "",
              getDeviceLocale() == "ar"
                  ? "المجلد موجود بالفعل"
                  : "The folder already exists",
              context,
              getWidth(context),
              getHeight(context));
          return false;
        } else {
          final response = await supabase
              .from('folders')
              .insert({
                'name': name,
                'parent_id': parentId,
                'created_at': DateTime.now().toIso8601String(),
              })
              .select()
              .single();
          return true;
        }
      } else {
        final query = supabase
            .from('folders')
            .select()
            .eq('name', name)
            .filter('parent_id', "is", null);

        // 3. Execute the query
        final existingFolder = await query.maybeSingle();
        if (existingFolder != null) {
          lunchAwesomDialoge(
              DialogType.warning,
              "",
              getDeviceLocale() == "ar"
                  ? "المجلد موجود بالفعل"
                  : "The folder already exists",
              context,
              getWidth(context),
              getHeight(context));
          return false;
        } else {
          final uploadService = SupabaseUploadService(supabase, 'folders');
          final storageResponse = await uploadService.uploadFile(
            XFile(selectedImage.toString()),
          );
          final response = await supabase
              .from('folders')
              .insert({
                'name': name,
                'parent_id': parentId,
                "image_url": storageResponse.toString().trim(),
                "child_count": 0,
                'created_at': DateTime.now().toIso8601String(),
              })
              .select()
              .single();
          return true;
        }
      }

      // 2. Create the folder if name is available
    } catch (e) {
      rethrow; // Re-throw to handle in UI layer
    }
  }

  // تعديل اسم المجلد
  Future<bool> renameFolder(int folderId, String newName, context) async {
    try {
      // 1. Get current folder to check parent_id
      final currentFolder = await supabase
          .from('folders')
          .select('parent_id')
          .eq('id', folderId)
          .single();

      // 2. Check for existing name in same parent
      final query = supabase
          .from('folders')
          .select('id')
          .eq('name', newName)
          .eq("parent_id", currentFolder["parent_id"]);

      if (currentFolder['parent_id'] != null) {
        query.eq('parent_id', currentFolder['parent_id']);
      } else {
        query.filter('parent_id', "is", null);
      }

      final existing = await query.maybeSingle();

      if (existing != null) {
        lunchAwesomDialoge(
            DialogType.warning,
            "",
            getDeviceLocale() == "ar"
                ? "المجلد موجود بالفعل"
                : "The folder already exists",
            context,
            getWidth(context),
            getHeight(context));
        return false;
      } else {
        await supabase.from('folders').update({
          'name': newName,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', folderId);
        return true;
      }

      // 3. Perform the update
    } catch (e) {
      //  print('Error renaming folder: $e');
      rethrow;
    }
  }

  // حذف مجلد مع جميع المحتويات
  Future<void> deleteFolder(int folderId, parentId, context) async {
     try {
    final response = await supabase.functions.invoke(
      'delete-folder',
      body: {'folder_id': folderId},
    );
    
     
    
  
   
    
    
   
  } catch (e) {
    if (kDebugMode) {
      print('حدث خطأ: ${e.toString()}');
    }
  }
   
    }
  

  // استرجاع الهيكل الهرمي
  Future<List<Folder>> getFolderHierarchy() async {
    final response = await supabase.from('folders').select('*');
    return response.map((f) => Folder.fromMap(f)).toList();
  }

  Future<List<Folder>> getRootFolders() async {
    final response =
        await supabase.from('folders').select().filter('parent_id', 'is', null);

    return response.map((f) => Folder.fromJson(f)).toList();
  }

  Future<List<Folder>> getChildFolders(int parentId) async {
    final response = await supabase
        .from('folders')
        .select()
        .eq('parent_id', parentId)
        .order("id", ascending: true);

    return response.map((f) => Folder.fromJson(f)).toList();
  }

  Future<List<Folder>> getChildFoldersForStudent() async {
    try {
      // 1. الحصول على بيانات المستخدم الحالي
      final userData = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);

      // 2. التحقق من الصف الدراسي

      final rootFolders = await supabase
          .from("folders")
          .select("id")
          .eq("name", userData[0]["category"])
          .maybeSingle();
      var secondRoot = [];
      var response = [];
      if (rootFolders != null && rootFolders.isNotEmpty) {
        response = await supabase
            .from("folders")
            .select()
            .eq("parent_id", rootFolders["id"])
            .order("id", ascending: true);
      }

      if (response.isEmpty) {
        return []; // إرجاع قائمة فارغة إذا لم يكن هناك مجلدات
      }

      return response.map((f) => Folder.fromJson(f)).toList();

      // // 3. الحصول على root folder
      // final rootFolders = await supabase
      //     .from("folders")
      //     .select("id")
      //     .eq("name", userData[0]["category"]);

      // // 4. الحصول على مجلد الكلية
      // final collegeFolders = await supabase
      //     .from('folders')
      //     .select()
      //     .eq('parent_id', rootFolders[0]["id"])
      //     .eq("name", userData[0]["collage"]);

      // if (collegeFolders.isEmpty) {
      //   throw Exception("College folder not found");
      // }

      // // 5. الحصول على المجلدات الفرعية
      // final response = await supabase
      //     .from("folders")
      //     .select()
      //     .eq("parent_id", collegeFolders[0]["id"]);

      // if (response.isEmpty) {
      //   return []; // إرجاع قائمة فارغة إذا لم يكن هناك مجلدات
      // }

      // return response.map((f) => Folder.fromJson(f)).toList();
    } catch (e) {
      print('Error in getChildFoldersForStudent: $e');
      return []; // إرجاع قائمة فارغة في حالة الخطأ
    }
  }

  // استرجاع المجلدات الفرعية لمجلد معين
  Future<List<Folder>> getSubfolders(int parentId) async {
    final response =
        await supabase.from('folders').select('*').eq('parent_id', parentId);

    return response.map((f) => Folder.fromMap(f)).toList();
  }

  Future<String> getRootFolder(int parentId) async {
    try {
      var response =
          await supabase.from('folders').select('*').eq('id', parentId);

      if (response.isEmpty) {
        throw Exception('Folder not found');
      }

      final folderData = response[0];

      if (folderData["parent_id"] != null) {
        // نعيد استدعاء الدالة بشكل return لضمان إرجاع القيمة
        return await getRootFolder(folderData["parent_id"]);
      } else {
        // عندما نصل للمجلد الجذر (الذي ليس له parent)
        return folderData["name"];
      }
    } catch (e) {
      print('Error in getRootFolder: $e');
      rethrow; // أو return قيمة افتراضية مثل return "";
    }
  }

  var sub = "";
  Future<String> getSubRootFolder(int parentId) async {
    try {
      var response =
          await supabase.from('folders').select('*').eq('id', parentId);

      if (response.isEmpty) {
        throw Exception('Folder not found');
      }

      final folderData = response[0];

      if (folderData["parent_id"] != null) {
        sub = folderData["name"];
        // نعيد استدعاء الدالة بشكل return لضمان إرجاع القيمة
        return await getSubRootFolder(folderData["parent_id"]);
      } else {
        // عندما نصل للمجلد الجذر (الذي ليس له parent)
        return sub;
      }
    } catch (e) {
      print('Error in getRootFolder: $e');
      rethrow; // أو return قيمة افتراضية مثل return "";
    }
  }

  Future<String> getSubjectFolder(int parentId) async {
    try {
      var response =
          await supabase.from('folders').select('*').eq('id', parentId);

      if (response.isEmpty) {
        throw Exception('Folder not found');
      }

      final folderData = response[0];

      if (!folderData["is-subject"]) {
        sub = folderData["name"];
        // نعيد استدعاء الدالة بشكل return لضمان إرجاع القيمة
        return await getSubjectFolder(folderData["parent_id"]);
      } else {
        // عندما نصل للمجلد الجذر (الذي ليس له parent)
        return folderData["name"];
      }
    } catch (e) {
      print('Error in getRootFolder: $e');
      rethrow; // أو return قيمة افتراضية مثل return "";
    }
  }

  deleteVideo(copyData, BuildContext context, parentId) async {
    var id = copyData["id"];
    var oldName = copyData["name"];
    var path = extractPathFromUrl(copyData["url"]);
    await supabase.storage.from("curces").remove([path]);
    var folder =
        await supabase.from("folders").select().eq("id", copyData["folder_id"]);
    int childCount = int.parse(folder[0]["child_count"].toString());
    childCount = childCount - 1;
    await supabase.from("folders").update(
        {"child_count": childCount.toString()}).eq("id", copyData["folder_id"]);
    if (copyData["pdf_urls"].isNotEmpty) {
      for (var i = 0; i < copyData["pdf_urls"].length; i++) {
        var pdfPath = extractPathFromUrl(copyData["pdf_urls"][i]);
        await supabase.storage.from("curces").remove([pdfPath]);
      }
    }

    if (copyData["image_url"].toString() != "null" ||
        copyData["image_url"] != null) {
      var imagePath = extractPathFromUrl(copyData["image_url"]);
      await supabase.storage.from("curces").remove([imagePath]);
    }
    await supabase.from("curces").delete().eq("id", id);
  }
}
