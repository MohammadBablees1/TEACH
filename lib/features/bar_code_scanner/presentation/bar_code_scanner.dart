import 'dart:async';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/bar_code_scanner/presentation/manager/catch_code_for_sign_in/catch_code_for_sign_in_cubit.dart';
import 'package:teach/main.dart';

class BarCodeScanner extends StatefulWidget {
  
  final bool check;

  // ignore: prefer_const_constructors_in_immutables
  BarCodeScanner({super.key, required this.check});
  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner>
    with WidgetsBindingObserver {
  StreamSubscription<Object?>? _subscription;
late final MobileScannerController controller;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
          _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void dispose()  {
    WidgetsBinding.instance.removeObserver(this);

    unawaited(_subscription?.cancel());
    _subscription = null;
     controller.dispose();
    super.dispose();
  }

  var onceEnter = false;
  var onceEnterLoading = false;
  void _handleBarcode(BarcodeCapture capture) async {
    final barcode = capture.barcodes.first.rawValue;
    if (widget.check) {
      if (barcode != null) {
        context
            .read<CatchCodeForSignInCubit>()
            .catchCodeForSignIn(barcode.toString());
          if(mounted){
          Navigator.maybePop(context);
        }
      }
    } else {
      var check = false;
      if (!onceEnterLoading) {
        onceEnterLoading = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
              content: SizedBox(
                width: 10,
                height: getWidth(context) * .1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            mode ? nightBar["orange"] : dayBar["blue3"]),
                    onPressed: () {},
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    )),
              )),
        );
      }

      var codes =
          await supabase.from("codes").select().eq("id", barcode.toString());

      if (codes.isNotEmpty) {
        var user = await supabase
            .from("current_user")
            .select()
            .eq("id", supabase.auth.currentUser!.id);
        var code = user[0]["codes"];

        if (code.toString().contains(codes[0]["folder_id"])) {
           if(mounted){
          Navigator.maybePop(context);
        }
          if(mounted){
            lunchAwesomDialoge(
              DialogType.error,
              "e",
              getDeviceLocale() == "ar"
                  ? "لقد اشتركت بالفعل بهذا الكورس"
                  : "You have already signed up for this course.",
              
              context,
            
              getWidth(context),
         
              getHeight(context));
          }
          check = true;
        } else {
          code.add(codes[0]["folder_id"]);
          await supabase
              .from("current_user")
              .update({"codes": code}).eq("id", supabase.auth.currentUser!.id);
          await supabase.from("codes").delete().eq("id", codes[0]["id"]);
          var ch = await supabase
              .from("sold_codes")
              .select()
              .eq("name", codes[0]["name"])
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
                .insert({"name": codes[0]["name"], "count": 1});
          }
          if (!onceEnter) {
            onceEnter = true;
            if(mounted){
          Navigator.maybePop(context);
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
              if(mounted){
          Navigator.maybePop(context);
        }
          }
        }
      }

      if (!check && !onceEnter) {
        onceEnter = true;

       
        if(mounted){
          Navigator.maybePop(context);
        }
       if(mounted){
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
      }
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
       
        controller: controller,
      ),
    );
  }
}
