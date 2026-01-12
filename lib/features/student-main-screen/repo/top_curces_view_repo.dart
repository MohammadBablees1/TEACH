import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';

class TopCurcesViewRepo {
  Future<List<Map<String, dynamic>>> getTopViewedCourses() async {
    try {
      
      if (await checkConnection()) {
        var data = await supabase
            .from("current_user")
            .select()
            .eq("id", supabase.auth.currentUser!.id);
        var response = await supabase
            .from('curces')
            .select()
            .eq("grade", data[0]["category"]); // جلب الكورسات مع مشاهداتها

        if (response.isEmpty) return [];

        // ترتيب الكورسات حسب عدد المشاهدين
        final sortedCourses = response.map((course) {
          final viewers = (course['watchers'] as List).length;
          return {
            ...course,
            'viewers_count': viewers, // إضافة حقل عددي لعدد المشاهدين
          };
        }).toList()
          ..sort((a, b) =>
              b['viewers_count'].compareTo(a['viewers_count'])); // ترتيب تنازلي

        List subjects = [];

        var sum = 0;
        var uniqueCourses =
            sortedCourses.fold(<Map<String, dynamic>>[], (list, element) {
          if (!list.any(
              (item) => item["subject-folder"] == element["subject-folder"])) {
            list.add(element);
          }
          return list;
        });
        try {
          for (var i = 0; i < (uniqueCourses.length); i++) {
            var folders = await supabase
                .from("folders")
                .select()
                .eq("id", uniqueCourses[i]["subject-folder"]);

            subjects.add(folders[0]["name"]);
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }

        return [
          {"0": uniqueCourses, "1": subjects},
        ]; // إرجاع أول 10 فقط
      } else {
        var box = Hive.box(hiveBoxName);
        return [
          {"0": box.get("top10"), "1": box.get("topName")}
        ];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
