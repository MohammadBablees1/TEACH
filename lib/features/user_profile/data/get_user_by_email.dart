import 'package:teach/main.dart';

class GetUserByEmail {

  getUser(widget)async{
      return await supabase
            .from("current_user")
            .select()
            .eq("email", widget.emailController.text.trim())
            .maybeSingle();
  }

}