import 'package:teach/core/supabase_client.dart';
class FetchCodeByNameRepo {
  Future<List<Map<String, dynamic>>> fetchCodesByName(String name) async {
    var data = await supabase.from("codes").select().eq("name", name);
    return data;
  }
}