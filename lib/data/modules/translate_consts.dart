import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';

class Translation {
  late Locale locale;
  static Translation of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation)!;
  }

  Map<String, Map> translateMe = {
    "Arabic": {
      "app_name": appNameInArabic,
      "welcom_screen11": welcom11InArabic,
      "welcom_screen12": welcom12InArabic,
      "welcom_screen21": welcom21InArabic,
      "welcom_screen31": welcom31InArabic,
      "welcom_screen32": welcom32InArabic,
      "next_button": nextButtonInArabic,
      "previous_button": previousButtonInArabic,
      "skipe_button": skipButtonInArabic,
      "save_button": saveButtonInArabic,
      "welcom_hint": hintTextWelcon3InArabic,
      "wifi_Not_Connected": wifiNotConnectedInArabic,
      "try_again": tryAgainInArabic,
      "fill": errorMessageFillInArabic,
      "choose_acount": "يرجى اختيار نوع الحساب",
      "Log_in": "تسجيل الدخول",
      "Sin_up": "تأكيد الحساب",
      "email": "اكتب عنوان البريد الإلكتروني هنا...",
      "phone": "اكتب رقم الهاتف هنا...",
      "code_r": "اكتب كود الحساب هنا...",
      "fill_e": "يرجى ملء جميع الحقول!",
      "password": "اكتب كلمة السر هنا...",
      "sun_mode": sunModeInArabic,
      "night_mode": nightModeInArabic,
      "arabic": arabicModeInArabic,
      "english": englishModeInArabic,
      "add_ads": "إضافة إعلان",
      "add_folder": "إضافة كتاب",
      "save_folder": "اكتب اسم المجلد هنا...",
    },
    "English": {
      "app_name": appNameInEnglish,
      "welcom_screen11": welcom11InEnglish,
      "welcom_screen12": welcom12InEnglish,
      "welcom_screen21": welcom21InEnglish,
      "welcom_screen31": welcom31InEnglish,
      "welcom_screen32": welcom32InEnglish,
      "next_button": nextButtonInEnglish,
      "previous_button": previousButtonInEnglish,
      "skipe_button": skipButtonInEnglish,
      "save_button": saveButtonInEnglish,
      "welcom_hint": hintTextWelcon3InEnglish,
      "wifi_Not_Connected": wifiNotConnectedInEnglish,
      "try_again": tryAgainInEnglish,
      "fill": errorMessageFillInEnglish,
      "choose_acount": "Please choose an acount!",
      "Log_in": "LogIn",
      "Sin_up": "Sign up",
      "email": "Write your email here...",
      "phone": "Write your phone number here...",
      "code_r": "Write acount code here...",
      "fill_e": "Please fill in all fields!",
      "password": "Write your password here...",
      "sun_mode": sunModeInEnglish,
      "night_mode": nightModeInEnglish,
      "arabic": arabicModeInEnglish,
      "english": englishModeInEnglish,
      "add_ads": "Add ads",
      "add_folder": "Add book",
      "save_folder": "Write the name of folder here ...",
    }
  };
}
