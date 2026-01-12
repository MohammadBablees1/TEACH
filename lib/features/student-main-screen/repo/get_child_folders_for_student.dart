import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/modules/folders.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class GetChildFoldersForStudent {
  Future<List<Folder>> getChildFoldersForStudent(context) async {
    try {
      final userData = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);

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
        return [];
      }

      return response.map((f) => Folder.fromJson(f)).toList();
    } catch (e) {
      lunchAwesomDialoge(DialogType.error, "e", e.toString(), context,
          getWidth(context), getHeight(context));
      return [];
    }
  }
}
