import 'package:teach/core/supabase_client.dart';

class GetFolderById {
  gett(data, i) async {
    return await supabase.from("folders").select().eq("id", data["codes"][i]);
  }
}
