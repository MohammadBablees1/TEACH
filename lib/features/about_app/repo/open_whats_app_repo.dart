import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenWhatsAppRepo {
  void openWhatsApp(String phoneNumber, context) async {
    final url = 'https://wa.me/+963$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      lunchAwesomDialoge(
          DialogType.warning,
          "w",
          getDeviceLocale() == "ar" ? "فشل" : "fail",
          context,
          getWidth(context),
          getHeight(context));
    }
  }
}
