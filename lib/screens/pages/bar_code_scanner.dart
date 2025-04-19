import 'dart:async';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

import 'package:flutter/material.dart';

import 'package:teach/data/consts/app_const.dart';

import 'package:teach/screens/pages/sign_in.dart';
import 'package:teach/screens/pages/student_main_screen.dart';

class BarCodeScanner extends StatefulWidget {
  var userEmail1 = "", userPassword1 = "", check = true, once = true;
  var codeController = TextEditingController();
  BarCodeScanner(
      {required this.userEmail1,
      required this.userPassword1,
      required this.check});
  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    useNewCameraSelector: false,
  );

  StreamSubscription<Object?>? _subscription;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) async {
    // Extract the scanned barcode string

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
              ),
            ),
            (Route<dynamic> route) => false);
      }
    } else {
      print(barcode);
      print("+++++++++++++++");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentMainScreen(),
          ));
    }

    // Optionally, return the scanned barcode to the previous screen
    // Navigator.pop(context, barcode);
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
        controller: controller,
      ),
    );
  }
}
