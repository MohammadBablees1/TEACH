import 'package:teach/core/supabase_client.dart';

class GetAllCodesRepo {

 Future getAllCodes() async {
    var codes = await supabase.from("codes").select();
    var sold = await supabase.from("sold_codes").select();
    Map<String, Map<String, dynamic>> result = {};

    for (var map in codes) {
      String name = map['name'];
      String generator = map['generator-name'] ?? map['generator-name'];

      if (!result.containsKey(name)) {
        result[name] = {
          'total_number': 0,
          'generators': [],
        };
      }

      // زيادة العدد الكلي لهذا الاسم
      result[name]!['total_number']++;

      // البحث عن المولد في القائمة
      bool generatorExists = false;
      for (var gen in result[name]!['generators']) {
        if (gen['name'] == generator) {
          gen['count']++;
          generatorExists = true;
          break;
        }
      }

      // إذا لم يكن المولد موجوداً نضيفه جديداً
      if (!generatorExists) {
        result[name]!['generators'].add({
          'name': generator,
          'count': 1,
        });
      }
    }

    List<int> saved = [];
    //  print(sold.length);
    for (var name in sold) {
      for (var i = 0; i < result.length; i++) {
        if (name["name"] == result.keys.toList()[i]) {
          saved.add(i);
          result[result.keys.toList()[i]]!["total_number"] =
              result[result.keys.toList()[i]]!["total_number"] + name["count"];
          result[result.keys.toList()[i]]!.addAll({"sold": name["count"]});
          if (name["name"] ==
              "كلية الحقوق - السنة الثالثة  - خاص (2) - أ. أمجد سجيع") {
            
          }
          break;
        } else if (!saved.contains(i)) {
          if (result.keys.toList()[result.length - 1] ==
              "كلية الحقوق - السنة الثالثة  - خاص (2) - أ. أمجد سجيع") {
            //   print(result.values.toList()[result.length - 3]);
          }
          result[result.keys.toList()[i]]!.addAll({"sold": 0});
        }
      }
    }

    if (sold.isEmpty) {
      for (var i = 0; i < result.length; i++) {
        result[result.keys.toList()[i]]!.addAll({"sold": 0});
      }
    }
    for (var i = 0; i < result.length; i++) {
      if (result.values.toList()[i]["sold"] == null) {
        result[result.keys.toList()[i]]!.addAll({"sold": 0});
      }
    }
   
    return result;
  }

}