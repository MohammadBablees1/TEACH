// core/supabase_gate.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGate {
  static bool _ready = false;

  static Future<void> ensureReady() async {
    if (_ready) return;

    final client = Supabase.instance.client;

    if (client.auth.currentSession != null) {
      await client.auth.refreshSession();
    }

    _ready = true;
  }
}
