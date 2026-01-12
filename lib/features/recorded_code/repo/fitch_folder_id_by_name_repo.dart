import 'package:teach/core/supabase_client.dart';

class FitchFolderIdByNameRepo {


 Future<String> fetchFolderIdByName(String name) async {
    var data = await supabase.from("codes").select().eq("name", name);

    String sendData = data[0]["folder_id"].toString();

    // Extract document IDs (codes)
    return sendData;
  }
  
}