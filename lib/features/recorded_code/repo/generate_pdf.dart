import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teach/features/recorded_code/repo/fetch_code_by_name_repo.dart';
import 'package:teach/features/recorded_code/repo/get_font_size_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
class GeneratePdfRepo {
   Future<void> generatePdf(name) async {
    List<Map<String, dynamic>> data = await FetchCodeByNameRepo().fetchCodesByName(name);
    List<Uint8List> imageBytes = [];
    for (var i = 0; i < data.length; i++) {
      final qrCode = QrCode.fromData(
        data: data[i]["id"],
        errorCorrectLevel: QrErrorCorrectLevel.M,
      );

      final qrImage = QrImage(qrCode);

      final qrImageData = await qrImage.toImageAsBytes(
        size: 512,
        format: ImageByteFormat.png,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(),
          background: Colors.white,
        ),
      );

      if (qrImageData == null) {
        throw Exception('Failed to generate QR code bytes.');
      }
      final Uint8List qrImageBytes = qrImageData.buffer.asUint8List();
      imageBytes.add(qrImageBytes);
    }
    final pdf = pw.Document();

    // Load the header image from assets
    final headerImage = pw.MemoryImage(
      (await rootBundle.load('images/icon.jpg')).buffer.asUint8List(),
    );
    final ByteData bytes = await rootBundle.load(
        'font/Noto_Sans_Arabic/static/NotoSansArabic_Condensed-Black.ttf');
    final font = pw.Font.ttf(bytes.buffer.asByteData());

    // Divide images into groups of 6 for each page
    final chunkedImages = List.generate(
      (imageBytes.length / 9).ceil(),
      (index) => imageBytes.skip(index * 9).take(9).toList(),
    );
    int currentIndex = -1;
    // Create a page for each chunk
    for (var images in chunkedImages) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(20),
          build: (context) => pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.SizedBox(height: 10),
              // Grid of images
              pw.GridView(
                childAspectRatio: 0.9,
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageData = entry.value;
                  final image = pw.MemoryImage(imageData);
                  currentIndex++;
                  final text = data[currentIndex]["id"];
                  final subject = data[currentIndex]["subject"];
                  final teacher = data[currentIndex]["teacher"];
                  return pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Image(image, width: 125, height: 125),
                      pw.SizedBox(height: 5),
                      pw.ConstrainedBox(
                        constraints: const pw.BoxConstraints(maxWidth: 125),
                        child: pw.Text(
                          maxLines: 1,
                          text,
                          style: pw.TextStyle(
                            fontSize: GetFontSizeRepo().getFontSize(
                                text),
                            font: font,
                          ),
                          overflow: pw.TextOverflow.clip,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.ConstrainedBox(
                        constraints: const pw.BoxConstraints(maxWidth: 125),
                        child: pw.Text(
                          maxLines: 1,
                          subject,
                          style: pw.TextStyle(
                            fontSize: GetFontSizeRepo().getFontSize(
                                subject), // دالة لحساب حجم الخط ديناميكيًا
                            font: font,
                          ),
                          overflow: pw.TextOverflow.clip,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.ConstrainedBox(
                        constraints: const pw.BoxConstraints(maxWidth: 125),
                        child: pw.Text(
                          maxLines: 1,
                          teacher,
                          style: pw.TextStyle(
                            fontSize:GetFontSizeRepo(). getFontSize(
                                teacher), // دالة لحساب حجم الخط ديناميكيًا
                            font: font,
                          ),
                          overflow: pw.TextOverflow.clip,
                          textDirection: pw.TextDirection.rtl,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              // Bottom text
            ],
          ),
        ),
      );
    }

    // Save the PDF to a file
    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File("${outputDir.path}/output.pdf");
    await outputFile.writeAsBytes(await pdf.save());

    
    await Share.shareXFiles([XFile(outputFile.path)]);
  }

}