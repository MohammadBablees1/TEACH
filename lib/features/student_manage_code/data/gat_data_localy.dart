import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';

class GatDataLocaly {

   Future<List> getDataLocaly() async {
    var box = Hive.box(hiveBoxName);
    return await box.get("saved");
  }
}