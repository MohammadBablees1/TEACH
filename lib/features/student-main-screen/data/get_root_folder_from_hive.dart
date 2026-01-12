import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';

class GetRootFolderFromHive {


   Future<List> getDataFromHive() async {
    var box = await Hive.openBox(hiveBoxName);
    List v = box.get("main");
    return v;
  }

  
}