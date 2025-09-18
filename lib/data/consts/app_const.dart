import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';

import 'package:teach/data/consts/day_neight.dart';

import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';

import 'package:teach/main.dart';

var appNameInArabic = "الملتقى";
var appNameInEnglish = "ALMOLTKA";
var databaseName = "tech_me.db";
var databaseVersion = 1;
var welcom11InArabic = "مرحباً بكم في رحلتكم التعليمية";
var welcom12InArabic = "مع \"الملتقى\"";
var welcom11InEnglish = "Welcome to your educational journey ";
var welcom12InEnglish = "with \"ALMOLTKA\"";
var welcom2InArabic = "حساب طالب,حساب مدير,حساب مالك";
var welcom2InEnglish = "Student account,manager account,owner account";
var welcom21InArabic = "لدي حساب,حساب طالب,حساب مدير,حساب مالك";
var welcom21InEnglish =
    "I have an account,Student account,manager account,owner account";
var welcom31InArabic = "نتمنّى لكم تجربة";
var welcom31InEnglish = "We wish you an enjoyable";
var welcom32InArabic = "تعليمية ممتعة";
var welcom32InEnglish = "learning experience";
var nextButtonInArabic = "التالي";
var nextButtonInEnglish = "Next";
var saveButtonInArabic = "حفظ";
var saveButtonInEnglish = "save";
var previousButtonInArabic = "السابق";
var previousButtonInEnglish = "previous";
var skipButtonInArabic = "تخطي";
var skipButtonInEnglish = "skip";
var hintTextWelcon3InArabic = "اكتب اسمك هنا...";
var hintTextWelcon3InEnglish = "Type your name here...";
var wifiNotConnectedInEnglish = "You are not connected";
var wifiNotConnectedInArabic = "يرجى الاتصال بالانترنت!";
var tryAgainInEnglish = "Try again";
var tryAgainInArabic = "أعد المحاولة";
var errorMessageFillInEnglish = "Write your name please!";
var errorMessageFillInArabic = "يرجى كتابة الاسم!";
var sunModeInArabic = "الوضع النهاري";
var sunModeInEnglish = "Sun mode";
var nightModeInArabic = "الوضع الليلي";
var nightModeInEnglish = "Night mode";
var englishModeInArabic = "اللغة الإنكليزية";
var englishModeInEnglish = "English";
var arabicModeInArabic = "اللغة العربية";
var arabicModeInEnglish = "Arabic";
var selectedPublicAcount = 4;
var language = false;
var checkMainMAnager = false;
var constCurrentUser = {};
var percentageAds = 0.0;
var hiveBoxName = "myAppData";
var isStudent = "student";
var isManager = "manager";
var isMainManager = "main_manager";
var isCode = "code";
var isFile = "file";
var watching = "watch";
var editing = "edite";
var noting = "not";
var deleting = "de;eting";

const appVersion = "1.0.0";

String getDeviceLocale() {
  if (language) {
    return "en";
  } else {
    return "ar";
  }
}

getWidth(context) {
  return MediaQuery.of(context).size.width;
}

getHeight(context) {
  return MediaQuery.of(context).size.height;
}

final List<String> itemsInArabic = [
  'ابتدائي',
  'إعدادي',
  'ثانوي',
  'جامعي',
];
final List<String> itemsInEnglish = [
  'Primary',
  'Preparatory',
  'Secondary',
  'University',
];

final List<String> school = [
  "الصف الأوّل",
  "الصف الثاني",
  "الصف الثالث",
  "الصف الرابع",
  "الصف الخامس",
  "الصف السادس",
  "الصف السابع",
  "الصف الثامن",
  "الصف التاسع",
  "الصف العاشر",
  "الصف الحادي عشر",
  "الثالث الثانوي",
  "First Grade",
  "Second Grade",
  "Third Grade",
  "Fourth Grade",
  "Fifth Grade",
  "Sixth Grade",
  "Seventh grade",
  "Eighth grade",
  "Ninth grade",
  "Tenth Grade",
  "Eleventh Grade",
  "Twelfth Grade (Baccalaureate)",
];

final List<String> primaryInArabic = [
  "الصف الأوّل",
  "الصف الثاني",
  "الصف الثالث",
  "الصف الرابع",
  "الصف الخامس",
  "الصف السادس",
];
final List<String> primaryInEnglish = [
  "First Grade",
  "Second Grade",
  "Third Grade",
  "Fourth Grade",
  "Fifth Grade",
  "Sixth Grade",
];
final List<String> preparatoryInArabic = [
  "الصف السابع",
  "الصف الثامن",
  "الصف التاسع",
];
final List<String> preparatoryInEnglish = [
  "Seventh grade",
  "Eighth grade",
  "Ninth grade",
];

final List<String> secondaryInArabic = [
  "الصف العاشر",
  "الصف الحادي عشر",
  "الثالث الثانوي",
];
final List<String> secondaryInEnglish = [
  "Tenth Grade",
  "Eleventh Grade",
  "Twelfth Grade (Baccalaureate)",
];

final List<String> universitySubjectsInArabic = [
  "كلية الطب البشري",
  "كلية طب الأسنان",
  "كلية الصيدلة",
  "كلية التمريض",
  "كلية العلوم الصحية (العلوم الطبية التطبيقية)",
  "كلية الهندسة المعلوماتية (هندسة الحاسوب)",
  "كلية الهندسة المدنية",
  "كلية الهندسة المعمارية",
  "كلية الهندسة الميكانيكية والكهربائية",
  "كلية الهندسة الكيميائية والبترولية",
  "كلية العلوم",
  "كلية العلوم الزراعية",
  "كلية العلوم البيطرية",
  "كلية الآداب والعلوم الإنسانية",
  "كلية التربية",
  "كلية الحقوق",
  "كلية الاقتصاد (العلوم الاقتصادية)",
  "كلية العلوم السياسية",
  "كلية السياحة",
  "كلية الفنون الجميلة",
  "كلية الإعلام (الاعلام والاتصال)",
  "كلية الشريعة",
  "كلية الدعوة الإسلامية",
];
final List<String> universitySubjectsInEnglish = [
  "College of Human Medicine",
  "College of Dentistry",
  "College of Pharmacy",
  'College of Nursing',
  "College of Health Sciences (Applied Medical Sciences)",
  'College of Informatics Engineering (Computer Engineering)',
  "College of Civil Engineering",
  "College of Architectural Engineering",
  "College of Mechanical and Electrical Engineering",
  "College of Chemical and Petroleum Engineering",
  "College of Science",
  "College of Agricultural Sciences",
  "College of Veterinary Sciences",
  "College of Arts and Humanities",
  'College of Education',
  "College of Law",
  "College of Economics (Economic Sciences)",
  "College of Political Science",
  "College of Tourism",
  "College of Fine Arts",
  "College of Media (Media and Communication)",
  "College of Sharia",
  "College of Islamic Propagation",
];

final Map<String, int> codeOfGrade = {
  itemsInEnglish[0]: 5,
  itemsInEnglish[1]: 8,
  itemsInEnglish[2]: 11,
  itemsInEnglish[3]: 14,
  primaryInEnglish[0]: 5,
  primaryInEnglish[1]: 5,
  primaryInEnglish[2]: 5,
  primaryInEnglish[3]: 5,
  primaryInEnglish[4]: 5,
  primaryInEnglish[5]: 5,
  preparatoryInEnglish[0]: 8,
  preparatoryInEnglish[1]: 8,
  preparatoryInEnglish[2]: 8,
  secondaryInEnglish[0]: 11,
  secondaryInEnglish[1]: 11,
  secondaryInEnglish[2]: 11,
  universitySubjectsInEnglish[0]: 14,
  universitySubjectsInEnglish[1]: 14,
  universitySubjectsInEnglish[2]: 14,
  universitySubjectsInEnglish[3]: 14,
  universitySubjectsInEnglish[4]: 14,
  universitySubjectsInEnglish[5]: 14,
  universitySubjectsInEnglish[6]: 14,
  universitySubjectsInEnglish[7]: 14,
  universitySubjectsInEnglish[8]: 14,
  universitySubjectsInEnglish[10]: 14,
  universitySubjectsInEnglish[11]: 14,
  universitySubjectsInEnglish[12]: 14,
  universitySubjectsInEnglish[13]: 14,
  universitySubjectsInEnglish[14]: 14,
  universitySubjectsInEnglish[15]: 14,
  universitySubjectsInEnglish[16]: 14,
  universitySubjectsInEnglish[17]: 14,
  universitySubjectsInEnglish[18]: 14,
  universitySubjectsInEnglish[19]: 14,
  universitySubjectsInEnglish[20]: 14,
  universitySubjectsInEnglish[21]: 14,
  universitySubjectsInEnglish[22]: 14,
};

getCodeFromGrade(catName) {
  return codeOfGrade[catName];
}

Future<List<String>> getTruthSubject() async {
  var catName = "";
  var id;

  catName = itemsInEnglish[3];

  final FolderRepository _repo = FolderRepository(supabase);
  var data = await _repo.getRootFolders();
  List<String> universityItems = [];

  universety = data;

  if (universety.length >= 1) {
    for (var i = 0; i < universety.length; i++) {
      universityItems.add(universety[i].name.toString());
    }
    if (universityItems.isEmpty) {
      return [
        getDeviceLocale() == "ar"
            ? "لا يوجد كورسات جامعية بعد"
            : "There are no university courses yet."
      ];
    }
    return universityItems;
  } else {
    return [
      getDeviceLocale() == "ar"
          ? "لا يوجد كورسات جامعية بعد"
          : "There are no university courses yet."
    ];
  }
}

List universety = [];
var mode = false;

bool checkPermision(editing, deleting, watching, coding, uploading, not) {
  var box = Hive.box(hiveBoxName);

  var check = box.get(isMainManager);
  if (check == null) {
    return false;
  }
  if (!check) {
    check = box.get(isManager);

    if (check) {
      check =
          checkFilePermision(editing, deleting, watching, coding, uploading, not);
    }
  }

  return check;
}

checkManager() {
  var box = Hive.box(hiveBoxName);
  if (box.get(isManager) == null) {
    return false;
  }
  return box.get(isManager);
}

bool checkCodePermision() {
  var box = Hive.box(hiveBoxName);
  if (box.get(isMainManager) != null) {
    if (box.get(isMainManager)) {
      return true;
    }
  }
  if (box.get(isCode) == null) {
    return false;
  }
  return box.get(isCode);
}

Future<void> showNotification(RemoteMessage message) async {
  if (message.notification != null) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? 'You have a new message',
      ),
    );
  }
}

Future<void> registerFCMToken() async {
  // 1. الحصول على رمز الجهاز من Firebase
  String? token = await FirebaseMessaging.instance.getToken();

  // 2. إذا كان المستخدم مسجل الدخول، احفظ الرمز في Supabase
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

  // 3. تحديث الرمز تلقائياً إذا تغير (مهم للأمان)
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    if (user != null) {
      await Supabase.instance.client
          .from('users')
          .upsert({'id': user.id, 'fcm_token': newToken});
    }
  });
  await FirebaseMessaging.instance.subscribeToTopic('all_users');
}

Future initUserInfo() async {
  var hiveInfo = [];
  var info = supabase.auth.currentUser;
  var box = Hive.box(hiveBoxName);

  var checkInternet = await checkConnection();
  var data;
  if (box.get("info") == null && checkInternet) {
    if (box.get(isStudent)) {
      data = await supabase
          .from("current_user")
          .select()
          .eq("email", info!.email.toString())
          .maybeSingle();
    } else if (box.get(isManager)) {
      data = await supabase
          .from("manager")
          .select()
          .eq("email", info!.email.toString())
          .maybeSingle();
    } else if (box.get(isMainManager)) {
      data = await supabase
          .from("main_manager")
          .select()
          .eq("email", info!.email.toString())
          .maybeSingle();
    }

    //  print(info.email.toString());
    if (data != null) {
      hiveInfo.add(data["name"]);
      hiveInfo.add(data["phone"]);
      hiveInfo.add(data["email"]);

      box.put("info", hiveInfo);
    }
  }
}

bool checkFilePermision(editing1, deleting1, watching1, coding1, uploading1, not) {
  var box = Hive.box(hiveBoxName);

  if (editing1) {
    return editing1.toString() == box.get(editing).toString().trim();
  } else if (deleting1) {
    return deleting1.toString() == box.get(deleting).toString().trim();
  } else if (watching1) {
    return watching1.toString() == box.get(watching).toString().trim();
  } else if (coding1) {
    return coding1.toString() == box.get(isCode).toString().trim();
  } else if (uploading1) {
    return uploading1.toString() == box.get(isFile).toString().trim();
  } else if(not){
     return not.toString() == box.get(noting).toString().trim();
  } else {
    return true;
  }
}

emailValidator(String email) {
  if (email.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (!email.contains("@")) {
    return getDeviceLocale() == "ar"
        ? "يجب أن يحوي البريد الإلكتروني على @"
        : "Email must contain @";
  } else if (email.length <= 10) {
    return getDeviceLocale() == "ar"
        ? "البريد الإلكتروني غير صالح"
        : "Invalid email";
  }
}

passwordValidator(String password) {
  if (password.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (password.length < 6) {
    return getDeviceLocale() == "ar"
        ? "كلمة السر غير صحيحة"
        : "Incorrect password";
    // return getDeviceLocale() == "ar" ? "يجب أن يكون طول كلمة السر على الأقل 9" : "Password length must be at least 9";
  }
}

newPasswordValidator(String password) {
  if (password.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (!isValidString(password) && selectedPublicAcount != 1) {
    return getDeviceLocale() == "ar"
        ? " يجب أن يحوي كلمة السر على 6 حروف على الأقل!"
        : "The password must contain at least 6 letters and 3 numbers!";
    // return getDeviceLocale() == "ar" ? "يجب أن يكون طول كلمة السر على الأقل 9" : "Password length must be at least 9";
  }
}

confirmPassword(String password, String confirmPassword) {
  if (password.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (password != confirmPassword) {
    return getDeviceLocale() == "ar" ? "لا يوجد تطابق" : "No match";
    // return getDeviceLocale() == "ar" ? "يجب أن يكون طول كلمة السر على الأقل 9" : "Password length must be at least 9";
  }
}

nameValidator(String name) {
  if (name.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  }
}

customNameValidator(String name) {
  if (name.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (name.toString().split(" ").length == 1 ||
      name.toString().split(" ")[1] == " " ||
      name.toString().split(" ")[1].isEmpty) {
    return getDeviceLocale() == "ar"
        ? "يجب كتابة اسمك الكامل هنا!"
        : "Your full name must be written here!";
  }
}

phoneValidator(String number) {
  if (number.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (!checkString(number)) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يحوي رقم الهاتف على حروف أو رموز!"
        : "The phone number cannot contain letters or symbols!";
  }
}

codeGeneratorValidator(String number) {
  if (number.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  } else if (!checkString(number)) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يحوي رقم على حروف أو رموز!"
        : "The phone number cannot contain letters or symbols!";
  } else if (int.parse(number) > 100) {
    return getDeviceLocale() == "ar" ? "الحد الأقصى 100" : "Maximum 100";
  }
}

codeValidator(code) {
  if (code.isEmpty) {
    return getDeviceLocale() == "ar"
        ? "لا يمكن أن يكون هذا الحقل فارغاً"
        : "This field cannot be empty.";
  }
}

checkString(String input) {
  if (containsNonDigits(input)) {
    return false;
  } else {
    return true;
  }
}

bool containsNonDigits(String input) {
  // تعبير عادي للتحقق من وجود أي شيء غير الأرقام
  final RegExp regex = RegExp(r'[^0-9]');
  return regex.hasMatch(input);
}

bool isValidString(String input) {
  // شرط 1: يحتوي على 6 أحرف على الأقل
  bool hasMin6Letters =
      input.replaceAll(RegExp(r'[^a-zA-Zء-ي]'), '').length >= 6;

  // // شرط 2: يحتوي على 3 أرقام على الأقل
  // bool hasMin3Digits = RegExp(r'\d{3,}').hasMatch(input);
  //
  // // شرط 3: يحتوي على رمزين على الأقل
  // bool hasMin2Symbols =
  //     RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]{2,}').hasMatch(input);

  // التحقق من جميع الشروط
  return hasMin6Letters;
}

Future<bool> checkConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  // Check if the device is connected to any network
  if (connectivityResult.first == ConnectivityResult.none) {
    return false; // No network connection
  }

  // Check for real internet access
  return true;
}

Future<bool> hasRealInternetAccess() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true; // Internet is available
    }
  } on SocketException catch (_) {
    return false; // No internet
  }
  return false;
}

Center connection_widget(width, height, BuildContext context) {
  return Center(
    child: Container(
      width: width / 2.5,
      height: height / 4,
      decoration: BoxDecoration(
          color: mode ? nightBar["orange"] : dayBar["blue"],
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Image.asset(
              "images/not_connected.gif",
              width: getWidth(context) / 10,
              height: getHeight(context) / 10,
            ),
          ),
          AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            getDeviceLocale() == "ar"
                ? Translation().translateMe["Arabic"]!["wifi_Not_Connected"]
                : Translation().translateMe["English"]!["wifi_Not_Connected"],
            style: TextStyle(color: Colors.white),
          ),
          BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () async {
                  context.read<LunchLoadingCubit>().lunchLoading(true);
                  var check = await checkConnection();
                  if (!check) {
                    context.read<LunchLoadingCubit>().lunchLoading(false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor:
                            mode ? nightBar["buttons"] : dayBar["blue2"],
                        content: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "أنت غير متصل"
                              : "You are not connected!",
                          style: TextStyle(color: Colors.white),
                        )));
                  } else {
                    context.read<LunchLoadingCubit>().lunchLoading(false);
                  }
                },
                child: state is LunchLoading
                    ? state.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? Translation()
                                    .translateMe["Arabic"]!["try_again"]
                                : Translation()
                                    .translateMe["English"]!["try_again"],
                            style: TextStyle(color: Colors.white),
                          )
                    : AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? Translation().translateMe["Arabic"]!["try_again"]
                            : Translation()
                                .translateMe["English"]!["try_again"],
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Future<List<String>> fetchCourses() async {
  List<String> courses = [];

  var codeNameFormate = "";
  try {
    List data = await supabase.from("curces").select();

    List foldersId = data
        .map(
          (e) => e["folder_id"],
        )
        .toSet()
        .toList();
    for (var i = 0; i < foldersId.length; i++) {
      var curce =
          await supabase.from("curces").select().eq("folder_id", foldersId[i]);
      var curceName =
          await supabase.from("folders").select().eq("id", foldersId[i]);
      codeNameFormate =
          "${curce[0]["grade"]}-${curce[0]["class"]}-${curceName[0]["name"]}";
      courses.add(codeNameFormate);
    }
  } catch (e) {
    print("Error fetching courses: $e");
  }
  return courses;
}

Future getSoldCode() async {
  var data = await supabase.from("sold_codes").select();
  return data;
}

Future<bool> doesTableExist(String tableName) async {
  try {
    final response =
        await supabase.rpc('table_exists', params: {'tname': tableName});
    return response as bool;
  } catch (e) {
    print('Error checking table: $e');
    return false;
  }
}

Future<void> createTable(String tableName) async {
  try {
    await supabase.rpc('create_custom_table', params: {
      'table_name': tableName,
      'columns': [
        {'name': 'id', 'type': 'SERIAL', 'primary_key': true},
        {'name': 'name', 'type': 'text'},
        {'name': 'parent_id', 'type': 'int8'}
      ]
    });
  } catch (e) {
    rethrow; // لإظهار الخطأ للطبقات الأعلى
  }
}

Future<void> renameTable(String currentName, String newName) async {
  try {
    await supabase.rpc('rename_table',
        params: {'old_name': currentName, 'new_name': newName});
  } catch (e) {
    print('Error renaming table: $e');
    rethrow;
  }
}

Future<List<String>> getTruthDegree(selectedGrade, id) async {
  final FolderRepository _repo = FolderRepository(supabase);

  var data = await _repo.getChildFolders(id);
  List<String> sendData = [];
  for (var i = 0; i < data.length; i++) {
    sendData.add(data[i].name);
  }
  if (sendData.isEmpty) {
    return [
      getDeviceLocale() == "ar"
          ? "لا توجد كورسات للجامعة المختارة"
          : "There are no courses for the selected university."
    ];
  }

  return sendData;
}

String formatFileSize(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}

String handleDatabaseError(PostgrestException e, String locale) {
  if (e.code == '23505') {
    // Unique violation
    return locale == "ar"
        ? "هذا البريد الإلكتروني مسجل بالفعل"
        : "This email is already registered";
  }

  return locale == "ar"
      ? "خطأ في قاعدة البيانات: ${e.message}"
      : "Database error: ${e.message}";
}

String handleAuthError(AuthException e, String locale) {
  switch (e.statusCode) {
    case "400":
      return locale == "ar"
          ? "البريد الإلكتروني أو كلمة المرور غير صالحة"
          : "Invalid email or password";
    case "422":
      return locale == "ar"
          ? "صيغة البريد الإلكتروني غير صحيحة"
          : "Invalid email format";
    case "429":
      return locale == "ar"
          ? "محاولات كثيرة جدًا. يرجى الانتظار قبل المحاولة مرة أخرى"
          : "Too many attempts. Please wait before trying again";
    default:
      return locale == "ar"
          ? "خطأ في المصادقة: ${e.message}"
          : "Authentication error: ${e.message}";
  }
}

Widget myImageAsset(String path, context) {
  return Container(
    width: 90,
    height: 90,
    child: Image.asset(
      path,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
    ),
  );
}

String extractPathFromUrl(String publicUrl) {
  final uri = Uri.parse(publicUrl);
  final path = uri.path.split('/storage/v1/object/public/curces/').last;
  return path;
}