import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teach/core/supabase_client.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/widgets/lunch.dart';

class GenerateBarCodeRepo {
  Future<dynamic> showGeneratorsName(
      BuildContext context, data, index, i) async {
    var codes = await supabase
        .from("codes")
        .select()
        .eq("name", data.keys.toList()[index])
        .eq("generator-name",
            data[data.keys.toList()[index]]!["generators"][i]["name"]);

    var code = codes[0]["id"];
    // ignore: use_build_context_synchronously
    context.read<LunchLoadingCubit>().getCodeLoding(false, i);
    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: getHeight(context) * .5,
          width: getWidth(context) * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrettyQrView.data(
                data: code.toString(),
                decoration: const PrettyQrDecoration(
                  background: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final qrCode = QrCode.fromData(
                          data: code.toString(),
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
                          lunchAwesomDialoge(
                              DialogType.error,
                              "e",
                              getDeviceLocale() == "ar"
                                  ? "فشل توليد باركود"
                                  : "Field",
                              // ignore: use_build_context_synchronously
                              context,
                              // ignore: use_build_context_synchronously
                              getWidth(context),
                              // ignore: use_build_context_synchronously
                              getHeight(context));
                        } else {
                          final Uint8List qrImageBytes =
                              qrImageData.buffer.asUint8List();
                          final tempDir = await getTemporaryDirectory();
                          final tempFile = File('${tempDir.path}/qr_image.png');
                          await tempFile.writeAsBytes(qrImageBytes);

                          final result =
                              await Share.shareXFiles([XFile(tempFile.path)]);
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "مشاركة صورة"
                                : "Share image",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        await Share.share(
                          code.toString(),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.text_fields,
                            color: Colors.white,
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "مشاركة نص"
                                : "Share text",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
