import 'package:teach/core/supabase_client.dart';

class GatCurrentUserById {
  gett() async {
    var userId = supabase.auth.currentUser!.id;
    return await supabase
        .from("current_user")
        .select()
        .eq("id", userId)
        .maybeSingle();
  }
}
