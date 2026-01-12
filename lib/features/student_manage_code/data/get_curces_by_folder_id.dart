import 'package:teach/core/supabase_client.dart';

class GetCurcesByFolderId {
  gett(data, i) async {
    return await supabase
        .from("curces")
        .select()
        .eq("folder_id", data["codes"][i]);
    
  }
}
