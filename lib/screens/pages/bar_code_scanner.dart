import 'dart:async';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/sign_in.dart';
import 'package:teach/screens/pages/student_main_screen.dart';

class BarCodeScanner extends StatefulWidget {
  MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  var userEmail1 = "", userPassword1 = "", check = true, once = true;
  var codeController = TextEditingController();
  var universityNumber = TextEditingController();
  BarCodeScanner(
      {required this.userEmail1,
      required this.userPassword1,
      required this.universityNumber,
      required this.check});
  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner>
    with WidgetsBindingObserver {
  int routesToRemove = 2;
  int seenRoutes = 0;
  StreamSubscription<Object?>? _subscription;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!widget.controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = widget.controller.barcodes.listen(_handleBarcode);

        unawaited(widget.controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(widget.controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _subscription = widget.controller.barcodes.listen(_handleBarcode);

    unawaited(widget.controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);

    unawaited(_subscription?.cancel());
    _subscription = null;

    super.dispose();

    await widget.controller.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) async {
    final barcode = capture.barcodes.first.rawValue;
    if (widget.check) {
      if (barcode != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(
                emailController: TextEditingController(text: widget.userEmail1),
                passwordController:
                    TextEditingController(text: widget.userPassword1),
                codeController: TextEditingController(text: barcode),
                universityNumberController: widget.universityNumber,
              ),
            ), (Route<dynamic> route) {
          seenRoutes++;

          return seenRoutes <= routesToRemove ? false : true;
        });
      }
    } else {
      var check = false;
      var codes = await supabase.from("codes").select();
      for (var i = 0; i < codes.length; i++) {
        if (codes[i]["id"] == barcode.toString()) {
          var user = await supabase
              .from("current_user")
              .select()
              .eq("id", supabase.auth.currentUser!.id);
          var code = user[0]["codes"];

          if (code.toString().contains(codes[i]["folder_id"])) {
            lunchAwesomDialoge(
                DialogType.error,
                "e",
                getDeviceLocale() == "ar"
                    ? "لقد اشتركت بالفعل بهذا الكورس"
                    : "You have already signed up for this course.",
                context,
                getWidth(context),
                getHeight(context));
            check = true;
            break;
          }
          

          
          code.add(codes[i]["folder_id"]);
          await supabase
              .from("current_user")
              .update({"codes": code}).eq("id", supabase.auth.currentUser!.id);
          await supabase.from("codes").delete().eq("id", codes[i]["id"]);
          var ch = await supabase
              .from("sold_codes")
              .select()
              .eq("name", codes[i]["name"])
              .maybeSingle();
          if (ch != null) {
            var total = int.parse(ch["count"].toString());
            total++;
            await supabase
                .from("sold_codes")
                .update({"count": total}).eq("id", ch["id"]);
          } else {
            await supabase
                .from("sold_codes")
                .insert({"name": codes[i]["name"], "count": 1});
          }

          check = true;

          Fluttertoast.showToast(
              msg: getDeviceLocale() == "ar"
                  ? "تمّ شراء الكورس بنجاح"
                  : "The course has been successfully purchased.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
          break;
        }
      }
      if (!check) {
        lunchAwesomDialoge(
            DialogType.error,
            "e",
            getDeviceLocale() == "ar"
                ? "الكود غير صالح"
                : "The code is invalid",
            context,
            getWidth(context),
            getHeight(context));
      }
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => StudentMainScreen(),
      //     ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiBarcodeScanner(
        showError: true,
        showSuccess: true,
        hideGalleryButton: true,
        hideSheetDragHandler: true,
        sheetTitle:
            getDeviceLocale() == "ar" ? "البحث عن كود" : "Search for code",
        onDetect: (BarcodeCapture barcodeCapture) {
          var code = barcodeCapture.barcodes.first.rawValue;
        },
        controller: widget.controller,
      ),
    );
  }
}
