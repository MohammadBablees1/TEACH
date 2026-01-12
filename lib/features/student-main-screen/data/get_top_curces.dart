import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';

class GetTopCurces {

  Future<List<Map<String, dynamic>>> getData() async {
    var box = Hive.box(hiveBoxName);
    return [
      {"0": box.get("top10"), "1": box.get("topName")}
    ];
  }

}