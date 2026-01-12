import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:teach/core/supabase_client.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/features/student_manage_code/data/gat_current_user_by_id.dart';
import 'package:teach/features/student_manage_code/data/get_curces_by_folder_id.dart';
import 'package:teach/features/student_manage_code/data/get_folder_by_id.dart';

class GetStudentCodeRepo {
  Future<List> getStudentCodes() async {
    try {
      var box = Hive.box(hiveBoxName);
      var userId = supabase.auth.currentUser!.id;
      var data = await GatCurrentUserById().gett();

      if (data!["codes"].isEmpty) {
        return [];
      } else {
        List info = [];
        for (var i = 0; i < data["codes"].length; i++) {
          var d = await GetFolderById().gett(data, i);
          var ch = await GetCurcesByFolderId().gett(data, i);
          box.put("${d[0]["name"]}", ch);
          info.add(d[0]);
        }
        return info;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
