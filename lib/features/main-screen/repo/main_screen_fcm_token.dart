import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';

class MainScreenFcmToken {


Future<void> registerFCMToken() async {

  String? token = await FirebaseMessaging.instance.getToken();

  
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null && token != null) {
    var box = Hive.box(hiveBoxName);
    final data = await supabase
        .from("current_user")
        .select()
        .eq("id", user.id)
        .maybeSingle();
    await Supabase.instance.client.from('users').upsert({
      'id': user.id,
      'fcm_token': token,
      "role":
          box.get(isMainManager) || box.get(isManager) ? "" : data!["category"],
      'updated_at': DateTime.now().toIso8601String(),
    });
  }


  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    if (user != null) {
      await Supabase.instance.client
          .from('users')
          .upsert({'id': user.id, 'fcm_token': newToken});
    }
  });
  await FirebaseMessaging.instance.subscribeToTopic('all_users');
}


}