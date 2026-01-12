import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/core/supabase_client.dart';

Future<void> waitForValidSession() async {
  final session = supabase.auth.currentSession;

  if (session == null) return;

  // إذا التوكن ما زال صالح
  if (session.expiresAt != null &&
      session.expiresAt! * 1000 > DateTime.now().millisecondsSinceEpoch) {
    return;
  }

  // انتظر refresh
  await supabase.auth.onAuthStateChange
      .firstWhere((data) => data.event == AuthChangeEvent.tokenRefreshed);
}


Future<void> ensureFreshSession() async {
  final session = supabase.auth.currentSession;
  if (session == null) return;

  final expiresAt = session.expiresAt;
  if (expiresAt != null &&
      expiresAt * 1000 >
          DateTime.now().millisecondsSinceEpoch + 60 * 1000) {
    // التوكن ما زال صالح لأكثر من دقيقة
    return;
  }

  await supabase.auth.refreshSession();
}

