import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenTelegramRepo {

   Future<void> openTelegram(String phoneNumber, context) async {
    
    final url = 'tg://resolve?phone=+963$phoneNumber';


    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      
      final webUrl =
          'https://t.me/+963$phoneNumber'; 
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl));
      } else {
         lunchAwesomDialoge(
          DialogType.warning,
          "w",
          getDeviceLocale() == "ar" ? "فشل" : "Fail",
          context,
          getWidth(context),
          getHeight(context));
      }
    }
  }

}