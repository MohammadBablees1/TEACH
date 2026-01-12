import 'package:teach/main.dart';

class UpdateDataForSignIn {

  updateDeviceId(mobileDeviceIdentifier, email)async {
    await supabase
                .from("current_user")
                .update({"deviceId": mobileDeviceIdentifier}).eq(
                    "email", email.toString());
  }

}