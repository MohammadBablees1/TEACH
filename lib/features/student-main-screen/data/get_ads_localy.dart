import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';

class GetAdsLocaly {


  Future<List> getAdsLocaly() async {
    var box = Hive.box(hiveBoxName);
    List ads = await box.get("ads");
    return ads;
  }

}