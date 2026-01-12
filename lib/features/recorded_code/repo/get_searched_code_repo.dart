import 'package:teach/core/supabase_client.dart';

class GetSearchedCodeRepo {


 Future getSearchCodes(String searchValue) async {
    var codes = await supabase
        .from("codes")
        .select()
        .filter("name", "ilike", "%$searchValue%");

    var sold = await supabase
        .from("sold_codes")
        .select()
        .filter("name", "ilike", "%$searchValue%");
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
    for (var name in sold) {
      for (var i = 0; i < result.length; i++) {
        if (name["name"] == result.keys.toList()[i]) {
          result[result.keys.toList()[i]]!["total_number"] =
              result[result.keys.toList()[i]]!["total_number"] + name["count"];
          result[result.keys.toList()[i]]!.addAll({"sold": name["count"]});
          break;
        } else {
          result[result.keys.toList()[i]]!.addAll({"sold": 0});
        }
      }
    }

    if (sold.isEmpty) {
      for (var i = 0; i < result.length; i++) {
        result[result.keys.toList()[i]]!["total_number"] =
            result[result.keys.toList()[i]]!["total_number"];
        result[result.keys.toList()[i]]!.addAll({"sold": 0});
      }
    }
    return result;
  }

}