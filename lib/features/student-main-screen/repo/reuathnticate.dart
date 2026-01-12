import 'package:teach/main.dart';

class Reuathnticate {



    Future<void> reauthenticateAndDelete() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      
      // Handle exceptions
    }
  }
}