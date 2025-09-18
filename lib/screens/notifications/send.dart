import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> sendNotificationToUser(
    String userId, String title, String body) async {
  // 1. الحصول على رمز الجهاز من Supabase
  final response = await Supabase.instance.client
      .from('users')
      .select('fcm_token')
      .eq('id', userId)
      .single();

  // 2. إرسال الإشعار باستخدام FCM v1 API
  final serviceAccount = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "al-multka-af65e",
    "private_key_id": "d8a6e572e319beaa0fe1b82248dc90cef6351652",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDyP7OvgBgYcrbz\n44WVzTiDMKyFWjRFePBAHozHPx6yJ2mJs/Tc3Nmo8MpUmk1xuOaaQtvt3ouliv6K\ne7sxheM8Y2NieqUPa8HE6c0NBPzazjAqxaOcX3MnGDMxJqMy3YFhQ27e8IesEq8K\nERAektwqZCAXxDfGioDoT91rwA2XPyEfnKiXwTPeJa4EYyH2OYZ69iqj3AOwsWdx\nDoD6vc7jKVTzfRp/F4VAjUu5rstRBtyZOlpTRAloylRgwyIUwy+LFwUX2IW/P1WZ\nyTSu3vcCAcyY6e7RaJ0sO4CJnOqKgEfpgsHzdURzX/+eWdD/uUj20PKVI+XqgSWR\nm9XUnZMXAgMBAAECggEAR5db2vnYJSGBwAH1cJf9o4e29JH78KwVFF3y7M9SmwPa\nxL9SFhOOn8bJhMc1K+6g9+XaaSnjy0CQiQyX/cK7rRUSQgBM14nY8gDGgJqAv4k/\n4uQVvhjXRy53sobgpB+iJMRw96HN9qRu5mK0iNSODFkawutSMHKuNfmkTjuryI5k\nU/lnAKE3+O7iKOv6x0L6sDOReqn6v7OXr8urPNZNKeZP1M1LE5agfUwDmsgRLJAb\n41m6lgsDKeNEzRyveCRSKum3s7Zj8zrC2C2eGwSlJz6mLY3l3olXGKaL/pAsdMWt\n7xNSq7HFQiAa/XslVbA3qMg7KB5JNX0P/JjoeP7lwQKBgQD//59B/5Y5JB8YssjS\nXVXZ/LkRPmCfJYer7QTGbrAMrkzOx9wYoOZe+ktHXqtqCuFhBM3qkQx8+43WoeDm\nU9P2VzXvrBPSUqND4BZiwvArz+KEc9NLQaz5BlE65GR+YR++pU5ncaxbXBITpnuo\nsMDTo4nEuFPUXXrBkJCT1Se1cwKBgQDyQA87Ub29lGWam8CKWLvjpeos+2CsoxUe\n+ULJ+oh/eyIvUMg9LV6rkAGAuS4nKSgDuqCzOYZqaz94IuU9RqWz33I7aoZRYWsH\n2kLBvBnvGLGpeigKfrgTyOTRXjZ6sEZh3iW89xld/VOrf3P0shUmN65Uqj/R2Drf\nK8BufWgizQKBgQC1EgaAdRq5cg44twSKnxABbtssEjXfe3k6JxzQiiwl3Adh30WT\negNYPKuQYKrYB7ggmnhXqJ7vrDJIFRnxcGule0wgKVOf2Wm3scHDu2SLaLAsxYw3\nV83UGh7MjA10wpfkjiIl0uZ5fGcg1Qn0aIkLaUoiBcrtk+0nCmzo08URdwKBgQCj\nEeQu9jNXbpGGpdnSRzETaRhd90l4bL9G/lurQu6ngefdGe/w3p2ft2yLjhw3WEkL\nWZHbk5mcAV3ULQlLWkco8f0fafHIzl8SBiZx64E5pdHSV9ykU/DtwInnNhhONmLq\ndnPI5D07O9Aa3czcpxP9ifXcIE6dn4Thvb3nopt68QKBgD6Iq2mLpApx+fEuDOPO\n0fZuNTuCMjmc1mppK1djGjGQH13O9dgybbNLmEzEtAm0DbJqMPJFkKHv8B4UKHsa\nw+Jdu9RGUHIYGh9a2FISXfWKaCkDUmCnlaXgi+OIgEvMsLl1TgMx7knJZdwlNHuW\nfTEv4z4BOGs8kqTbENo/mbn6\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-fbsvc@al-multka-af65e.iam.gserviceaccount.com",
    "client_id": "104412433004517473610",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40al-multka-af65e.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  });

  final authClient = await clientViaServiceAccount(
    serviceAccount,
    ['https://www.googleapis.com/auth/cloud-platform'],
  );

  final message = {
    'message': {
      'token': response['fcm_token'],
      'notification': {'title': title, 'body': body},
      'data': {'type': 'admin_message', 'id': '123'},
    }
  };

  await authClient.post(
    Uri.parse(
        'https://fcm.googleapis.com/v1/projects/al-multka-af65e/messages:send'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(message),
  );

  authClient.close();
}
