import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Codes extends StatefulWidget {
  var name = "";
  Codes({required this.name});

  @override
  State<Codes> createState() => _CodesState();
}

class _CodesState extends State<Codes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            widget.name),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await generatePdf();
              },
              icon: Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: FutureBuilder(
            future: fetchCodesByName(widget.name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: myImageAsset("images/loading.gif", context),
                );
              } else if (!snapshot.hasData) {
                return Container(
                    width: getWidth(context),
                    height: getHeight(context) / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NoDataFound(),
                      ],
                    ));
              } else {
                var data = snapshot.data;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: mode ? nightBar["orange"] : dayBar["blue2"],
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor:
                                mode ? nightBar["buttons"] : dayBar["blue"],
                            child: Icon(
                              Icons.code,
                              color: Colors.white,
                            )),
                        title: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Container(
                                  height: getHeight(context) * .5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PrettyQrView.data(
                                        data: data[index],
                                        decoration: const PrettyQrDecoration(
                                          background: Colors.white,
                                          // image:
                                          //     PrettyQrDecorationImage(
                                          //   matchTextDirection: true,
                                          //   image: AssetImage(
                                          //     'images/qr_icon.png',
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                final qrCode = QrCode.fromData(
                                                  data: data[index],
                                                  errorCorrectLevel:
                                                      QrErrorCorrectLevel.M,
                                                );

                                                final qrImage = QrImage(qrCode);
                                                final qrImageData =
                                                    await qrImage
                                                        .toImageAsBytes(
                                                  size: 512,
                                                  format: ImageByteFormat.png,
                                                  decoration:
                                                      const PrettyQrDecoration(
                                                    shape:
                                                        PrettyQrSmoothSymbol(),
                                                    background: Colors.white,
                                                    //   image:
                                                    //       PrettyQrDecorationImage(
                                                    //     image: AssetImage(
                                                    //         'images/icon.jpg'),
                                                    //   ),
                                                    // ),
                                                  ),
                                                );
                                                if (qrImageData == null) {
                                                  throw Exception(
                                                      'Failed to generate QR code bytes.');
                                                }
                                                final Uint8List qrImageBytes =
                                                    qrImageData.buffer
                                                        .asUint8List();
                                                final tempDir =
                                                    await getTemporaryDirectory();
                                                final tempFile = File(
                                                    '${tempDir.path}/qr_image.png');
                                                await tempFile
                                                    .writeAsBytes(qrImageBytes);

                                                final result =
                                                    await Share.shareXFiles(
                                                        [XFile(tempFile.path)]);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    color: Colors.white,
                                                  ),
                                                  AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      getDeviceLocale() == "ar"
                                                          ? "مشاركة صورة"
                                                          : "Share image",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await Share.share(data[index]);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.text_fields,
                                                    color: Colors.white,
                                                  ),
                                                  AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    getDeviceLocale() == "ar"
                                                        ? "مشاركة نص"
                                                        : "Share text",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            data[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchCodesByName(String name) async {
    var data = await supabase.from("codes").select().eq("name", widget.name);

    List<String> sendData = data
        .map(
          (e) => e["id"] as String,
        )
        .toList();

    // Extract document IDs (codes)
    return sendData;
  }

  Future<void> generatePdf() async {
    List data = await fetchCodesByName(widget.name);
    List<Uint8List> imageBytes = [];
    for (var i = 0; i < data.length; i++) {
      final qrCode = QrCode.fromData(
        data: data[i],
        errorCorrectLevel: QrErrorCorrectLevel.M,
      );

      final qrImage = QrImage(qrCode);

      final qrImageData = await qrImage.toImageAsBytes(
        size: 512,
        format: ImageByteFormat.png,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(),
          background: Colors.white,
          //   image:
          //       PrettyQrDecorationImage(
          //     image: AssetImage(
          //         'images/icon.jpg'),
          //   ),
          // ),
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
      (imageBytes.length / 6).ceil(),
      (index) => imageBytes.skip(index * 6).take(6).toList(),
    );

    // Create a page for each chunk
    for (var images in chunkedImages) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(20),
          build: (context) => pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              // Top image
              pw.Center(
                child: pw.Image(headerImage,
                    height: 100), // Adjust the height as needed
              ),

              pw.Text(
                maxLines: 1,
                
                widget.name,
                style: pw.TextStyle(
                  fontSize: 16,
                  font: font,
                  fontFallback: [],
                ),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              // Grid of images
              pw.GridView(
                childAspectRatio: .5,
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,

                children: images.map((imageData) {
                  final image = pw.MemoryImage(imageData);
                  return pw.Image(image,
                      fit: pw.BoxFit.cover, width: 100, height: 100);
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

    print("PDF saved to ${outputFile.path}");
    await Share.shareXFiles([XFile(outputFile.path)]);
  }
}
