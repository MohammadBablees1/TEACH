import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';

class HiveData {


 Future<List> getAdsLocaly() async {
    var box = Hive.box(hiveBoxName);
    List ads = await box.get("ads");
    return ads;
  }

   Future<List> getDataFromHive() async {
    var box = await Hive.openBox(hiveBoxName);
    List v = box.get("main");

    return v;
  }

}