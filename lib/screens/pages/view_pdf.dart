import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class ViewPdf extends StatefulWidget {
  ViewPdf({super.key, required this.pdfUrl});
  late var pdfUrl;
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
  @override
  State<ViewPdf> createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  File? _cachedPdfFile;
  bool _isLoading = true;
  String? _errorMessage;
  Future<File> _renameFile(File file, String newName) async {
    final newPath = "${file.parent.path}/$newName";
    return file.rename(newPath);
  }

  Future<void> _loadPdf() async {
    if (kDebugMode) {
      print(widget.pdfUrl);
    }
    if (kDebugMode) {
      print("+++++++++++++++++");
    }
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.pdfUrl);
      final renamedFile = await _renameFile(file, "cached_pdf.pdf");

      setState(() {
        _cachedPdfFile = renamedFile;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading PDF: $e");
      } // Debugging: Print error
      setState(() {
        _errorMessage = getDeviceLocale() == "ar"
            ? "فشل تحميل ملف PDF. يُرجى التحقق من اتصالك بالإنترنت."
            : "Failed to load PDF. Please check your internet connection.";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    widget._pdfViewerController = PdfViewerController();
    _loadPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.white),
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar" ? "ملف pdf" : "pdf file",
          style: TextStyle(),
        ),
        iconTheme: IconThemeData(),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
      ),
      body: _isLoading
          ? Container(
              width: getWidth(context),
              height: getHeight(context),
              child: Center(
                  child: CircularProgressIndicator(
                color: mode ? Colors.white : dayBar["blue"],
              )))
          : _errorMessage != null
              ? Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 15,
                    _errorMessage!.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : SfPdfViewer.file(
                  _cachedPdfFile!,
                ),
    );
  }
}
