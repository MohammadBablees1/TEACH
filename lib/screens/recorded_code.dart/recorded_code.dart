import "dart:io";
import "dart:typed_data";
import "dart:ui";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:percent_indicator/circular_percent_indicator.dart";
import "package:pretty_qr_code/pretty_qr_code.dart";
import "package:share_plus/share_plus.dart";
import "package:teach/cubit/home_search/home_search_cubit.dart";
import "package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart";
import "package:teach/data/consts/app_const.dart";
import "package:teach/data/consts/day_neight.dart";
import "package:teach/main.dart";
import "package:teach/widgets/no_data_found.dart";
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class RecordedCode extends StatefulWidget {
  TextEditingController searchController = TextEditingController();

  @override
  State<RecordedCode> createState() => _RecordedCodeState();
}

class _RecordedCodeState extends State<RecordedCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      body: WillPopScope(
        onWillPop: () {
          context.read<HomeSearchCubit>().searchForValue(false, "");
          Navigator.pop(context);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getWidth(context) * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Center(
                          child: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "سجل الأكواد"
                                : "Saved codes",
                            style: TextStyle(
                                fontSize: getWidth(context) * .05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: widget.searchController,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.name,
                        onSubmitted: (codeName) {
                          if (codeName.toString().isNotEmpty) {
                            context.read<HomeSearchCubit>().searchForValue(
                                true, widget.searchController.text.trim());
                          } else {
                            context.read<HomeSearchCubit>().searchForValue(
                                false, widget.searchController.text.trim());
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: .5, color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: .5, color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.white)),
                          hintText: getDeviceLocale() == "ar"
                              ? "اكتب للبحث هنا ..."
                              : "Type here to search ...",
                          hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 196, 190, 190)),
                          prefixIcon: const Icon(
                            Icons.code,
                            color: Colors.white,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getHeight(context) - (getWidth(context) * .4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color:
                        mode ? const Color.fromRGBO(0, 0, 0, 1) : Colors.white),
                child: BlocBuilder<HomeSearchCubit, HomeSearchState>(
                  builder: (context, state) {
                    return FutureBuilder(
                      future: state is SendSearchValue && state.search
                          ? getSearchCodes(state.searchValue)
                          : getAllCodes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: myImageAsset("images/loading.gif", context),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: NoDataFound(),
                          );
                        } else {
                          Map<String, Map<String, dynamic>> data =
                              snapshot.data;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              print(data[data.keys.toList()[index]]);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: mode
                                      ? nightBar["orange"]
                                      : dayBar["blue3"],
                                  child: Container(
                                    width: getWidth(context),
                                    height: getWidth(context) * .8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          data.keys.toList()[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: getWidth(context) * .5,
                                              height: getWidth(context) * .7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    getDeviceLocale() == "ar"
                                                        ? "الأكواد المولّدة : "
                                                        : "Generated codes : ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? " العدد الكلّي : "
                                                            : " Total number : ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        data[data.keys.toList()[
                                                                    index]]![
                                                                "total_number"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? " العدد المباع : "
                                                            : " Sold number : ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        data[data.keys.toList()[
                                                                index]]!["sold"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width:
                                                        getWidth(context) * .5,
                                                    height:
                                                        getWidth(context) * .1,
                                                    child: ListView.builder(
                                                        itemCount: data[data
                                                                        .keys
                                                                        .toList()[
                                                                    index]]![
                                                                "generators"]
                                                            .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  width: getWidth(
                                                                          context) *
                                                                      .2,
                                                                  height: getWidth(
                                                                          context) *
                                                                      .06,
                                                                  decoration: BoxDecoration(
                                                                      color: mode
                                                                          ? dayBar[
                                                                              "blue2"]
                                                                          : nightBar[
                                                                              "buttons"],
                                                                      borderRadius:
                                                                          BorderRadius.circular(getWidth(context) *
                                                                              .01),
                                                                      border: Border.all(
                                                                          width:
                                                                              .5,
                                                                          color: mode
                                                                              ? Colors.orange
                                                                              : Colors.blue)),
                                                                  child: Center(
                                                                    child:
                                                                        AutoSizeText(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          15,
                                                                      data[data
                                                                          .keys
                                                                          .toList()[index]]!["generators"][i]["name"],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: getWidth(
                                                                        context) *
                                                                    .2,
                                                                height: getWidth(
                                                                        context) *
                                                                    .06,
                                                                decoration: BoxDecoration(
                                                                    color: mode
                                                                        ? dayBar[
                                                                            "blue2"]
                                                                        : nightBar[
                                                                            "buttons"],
                                                                    borderRadius:
                                                                        BorderRadius.circular(getWidth(context) *
                                                                            .01),
                                                                    border: Border.all(
                                                                        width:
                                                                            .5,
                                                                        color: mode
                                                                            ? Colors.orange
                                                                            : Colors.blue)),
                                                                child: Center(
                                                                  child: AutoSizeText(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          15,
                                                                      data[data.keys.toList()[index]]!["generators"][i]
                                                                              [
                                                                              "count"]
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Column(
                                                    children: [
                                                      BlocBuilder<
                                                          LunchLoadingCubit,
                                                          LunchLoadingState>(
                                                        builder:
                                                            (context, state) {
                                                          return ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              context
                                                                  .read<
                                                                      LunchLoadingCubit>()
                                                                  .getCodeLoding(
                                                                      true,
                                                                      index);
                                                              var codes = await supabase
                                                                  .from("codes")
                                                                  .select()
                                                                  .eq(
                                                                      "name",
                                                                      data.keys
                                                                              .toList()[
                                                                          index]);
                                                              var code =
                                                                  codes[0]
                                                                      ["id"];
                                                              context
                                                                  .read<
                                                                      LunchLoadingCubit>()
                                                                  .getCodeLoding(
                                                                      false,
                                                                      index);
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  content:
                                                                      Container(
                                                                    height:
                                                                        getHeight(context) *
                                                                            .5,
                                                                    width: getWidth(
                                                                            context) *
                                                                        .8,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        PrettyQrView
                                                                            .data(
                                                                          data:
                                                                              code.toString(),
                                                                          decoration:
                                                                              const PrettyQrDecoration(
                                                                            background:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
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
                                                                                    throw Exception('Failed to generate QR code bytes.');
                                                                                  }
                                                                                  final Uint8List qrImageBytes = qrImageData.buffer.asUint8List();
                                                                                  final tempDir = await getTemporaryDirectory();
                                                                                  final tempFile = File('${tempDir.path}/qr_image.png');
                                                                                  await tempFile.writeAsBytes(qrImageBytes);

                                                                                  final result = await Share.shareXFiles([
                                                                                    XFile(tempFile.path)
                                                                                  ]);
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.image,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    AutoSizeText(
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      minFontSize: 10,
                                                                                      maxFontSize: 15,
                                                                                      getDeviceLocale() == "ar" ? "مشاركة صورة" : "Share image",
                                                                                      style: TextStyle(color: Colors.white),
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
                                                                                    Icon(
                                                                                      Icons.text_fields,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    AutoSizeText(
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      minFontSize: 10,
                                                                                      maxFontSize: 15,
                                                                                      getDeviceLocale() == "ar" ? "مشاركة نص" : "Share text",
                                                                                      style: TextStyle(color: Colors.white),
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
                                                            },
                                                            child: state is GetCodeLoading &&
                                                                    state
                                                                        .loading &&
                                                                    state.index ==
                                                                        index
                                                                ? CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : AutoSizeText(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    minFontSize:
                                                                        10,
                                                                    maxFontSize:
                                                                        15,
                                                                    getDeviceLocale() ==
                                                                            "ar"
                                                                        ? "اختيار كود عشوائي"
                                                                        : "Select random code",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: mode
                                                                    ? nightBar[
                                                                        "buttons"]
                                                                    : dayBar[
                                                                        "blue2"]),
                                                          );
                                                        },
                                                      ),
                                                      BlocBuilder<
                                                          LunchLoadingCubit,
                                                          LunchLoadingState>(
                                                        builder:
                                                            (context, state) {
                                                          return ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .generatePdf(
                                                                        true,
                                                                        index);
                                                                await generatePdf(data
                                                                        .keys
                                                                        .toList()[
                                                                    index]);
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .generatePdf(
                                                                        false,
                                                                        index);
                                                              } catch (e) {
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .generatePdf(
                                                                        false,
                                                                        index);
                                                              }
                                                            },
                                                            child: state is GeneratePdf &&
                                                                    state
                                                                        .loading &&
                                                                    state.index ==
                                                                        index
                                                                ? CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : AutoSizeText(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    minFontSize:
                                                                        10,
                                                                    maxFontSize:
                                                                        15,
                                                                    getDeviceLocale() ==
                                                                            "ar"
                                                                        ? "تصدير إلى ملف pdf"
                                                                        : "Export to pdf",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: mode
                                                                    ? nightBar[
                                                                        "buttons"]
                                                                    : dayBar[
                                                                        "blue2"]),
                                                          );
                                                        },
                                                      ),
                                                      BlocBuilder<
                                                          LunchLoadingCubit,
                                                          LunchLoadingState>(
                                                        builder:
                                                            (context, state) {
                                                          return ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .deleteAllCodesFromUser(
                                                                        true,
                                                                        index);
                                                                var userData =
                                                                    await supabase
                                                                        .from(
                                                                            "current_user")
                                                                        .select();
                                                                String
                                                                    codeData =
                                                                    await fetchFolderIdByName(data
                                                                        .keys
                                                                        .toList()[
                                                                            index]
                                                                        .toString());
                                                                for (var i = 0;
                                                                    i <
                                                                        userData
                                                                            .length;
                                                                    i++) {
                                                                  List codes =
                                                                      userData[
                                                                              0]
                                                                          [
                                                                          "codes"];

                                                                  if (codes
                                                                          .isNotEmpty ||
                                                                      codes !=
                                                                          [] ||
                                                                      codes.toList() !=
                                                                          [] ||
                                                                      codes
                                                                          .toList()
                                                                          .isNotEmpty) {
                                                                    codes.remove(
                                                                        int.parse(
                                                                            codeData));
                                                                    await supabase
                                                                        .from(
                                                                            "current_user")
                                                                        .update({
                                                                      "codes":
                                                                          codes
                                                                    }).eq("id",
                                                                            userData[0]["id"]);
                                                                  }
                                                                }
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .deleteAllCodesFromUser(
                                                                        false,
                                                                        index);
                                                              } catch (e) {
                                                                context
                                                                    .read<
                                                                        LunchLoadingCubit>()
                                                                    .deleteAllCodesFromUser(
                                                                        false,
                                                                        index);
                                                              }
                                                            },
                                                            child: state is DeleteAllCodesFromUser &&
                                                                    state
                                                                        .loading &&
                                                                    state.index ==
                                                                        index
                                                                ? const CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : AutoSizeText(
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    minFontSize:
                                                                        10,
                                                                    maxFontSize:
                                                                        15,
                                                                    getDeviceLocale() ==
                                                                            "ar"
                                                                        ? "تعطيل جميع الاشتراكات"
                                                                        : "Disable all subscriptions",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: mode
                                                                    ? nightBar[
                                                                        "buttons"]
                                                                    : dayBar[
                                                                        "blue2"]),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  CircularPercentIndicator(
                                                    radius: 60,
                                                    lineWidth:
                                                        getWidth(context) * .08,
                                                    percent: (100 *
                                                            data[data.keys
                                                                        .toList()[
                                                                    index]]![
                                                                "sold"] /
                                                            data[data.keys
                                                                        .toList()[
                                                                    index]]![
                                                                "total_number"]) /
                                                        100,
                                                    startAngle: 60,
                                                    progressColor:
                                                        const Color.fromARGB(
                                                            255, 1, 160, 6),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 178, 9, 184),
                                                    center: AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      "${((100 * data[data.keys.toList()[index]]!["sold"] ~/ data[data.keys.toList()[index]]!["total_number"])).toStringAsFixed(1)} %",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: getWidth(
                                                                    context) *
                                                                .05,
                                                            height: getWidth(
                                                                    context) *
                                                                .05,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                getWidth(
                                                                        context) *
                                                                    .01,
                                                              ),
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  1, 160, 6),
                                                            ),
                                                          ),
                                                          AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "الأكواد المباعة"
                                                                : "Selled Codes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: getWidth(
                                                                    context) *
                                                                .05,
                                                            height: getWidth(
                                                                    context) *
                                                                .05,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                getWidth(
                                                                        context) *
                                                                    .01,
                                                              ),
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  178, 9, 184),
                                                            ),
                                                          ),
                                                          AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "الأكواد المولّدة"
                                                                : "Generated Codes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getAllCodes() async {
    var codes = await supabase.from("codes").select();
    var sold = await supabase.from("sold_codes").select();
    Map<String, Map<String, dynamic>> result = {};

    for (var map in codes) {
      String name = map['name'];
      String generator = map['generator-name'] ?? map['generator-name'];

      if (!result.containsKey(name)) {
        result[name] = {
          'total_number': 0,
          'generators': [],
        };
      }

      // زيادة العدد الكلي لهذا الاسم
      result[name]!['total_number']++;

      // البحث عن المولد في القائمة
      bool generatorExists = false;
      for (var gen in result[name]!['generators']) {
        if (gen['name'] == generator) {
          gen['count']++;
          generatorExists = true;
          break;
        }
      }

      // إذا لم يكن المولد موجوداً نضيفه جديداً
      if (!generatorExists) {
        result[name]!['generators'].add({
          'name': generator,
          'count': 1,
        });
      }
    }
    for (var name in sold) {
      for (var i = 0; i < result.length; i++) {
        if (name["name"] == result.keys.toList()[i]) {
          result[result.keys.toList()[i]]!["total_number"] =
              result[result.keys.toList()[i]]!["total_number"] + name["count"];
          result[result.keys.toList()[i]]!.addAll({"sold": name["count"]});
          break;
        } else {
          result[result.keys.toList()[i]]!.addAll({"sold": 0});
        }
      }
    }

    return result;
  }

  Future<List<String>> fetchCodesByName(String name) async {
    var data = await supabase.from("codes").select().eq("name", name);

    List<String> sendData = data
        .map(
          (e) => e["id"] as String,
        )
        .toList();

    // Extract document IDs (codes)
    return sendData;
  }

  Future<String> fetchFolderIdByName(String name) async {
    var data = await supabase.from("codes").select().eq("name", name);

    String sendData = data[0]["folder_id"].toString();

    // Extract document IDs (codes)
    return sendData;
  }

  Future<void> generatePdf(name) async {
    List data = await fetchCodesByName(name);

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
      (imageBytes.length / 4).ceil(),
      (index) => imageBytes.skip(index * 4).take(4).toList(),
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
                name,
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
                childAspectRatio: 0.9,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageData = entry.value;
                  final image = pw.MemoryImage(imageData);
                  final text = data[index];

                  return pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Image(image, width: 100, height: 100),
                      pw.SizedBox(height: 5),
                      pw.ConstrainedBox(
                        constraints: const pw.BoxConstraints(maxWidth: 100),
                        child: pw.Text(
                          maxLines: 1,
                          text,
                          style: pw.TextStyle(
                            fontSize: getFontSize(
                                text), // دالة لحساب حجم الخط ديناميكيًا
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

    if (kDebugMode) {
      print("PDF saved to ${outputFile.path}");
    }
    await Share.shareXFiles([XFile(outputFile.path)]);
  }

  double getFontSize(String text) {
    if (text.length > 20) return 6;
    if (text.length > 10) return 8;
    return 10;
  }

  Future getSearchCodes(String searchValue) async {
    var codes = await supabase
        .from("codes")
        .select()
        .filter("name", "ilike", "%$searchValue%");

    var sold = await supabase
        .from("sold_codes")
        .select()
        .filter("name", "ilike", "%$searchValue%");
    Map<String, Map<String, dynamic>> result = {};

    for (var map in codes) {
      String name = map['name'];
      String generator = map['generator-name'] ?? map['generator-name'];

      if (!result.containsKey(name)) {
        result[name] = {
          'total_number': 0,
          'generators': [],
        };
      }

      // زيادة العدد الكلي لهذا الاسم
      result[name]!['total_number']++;

      // البحث عن المولد في القائمة
      bool generatorExists = false;
      for (var gen in result[name]!['generators']) {
        if (gen['name'] == generator) {
          gen['count']++;
          generatorExists = true;
          break;
        }
      }

      // إذا لم يكن المولد موجوداً نضيفه جديداً
      if (!generatorExists) {
        result[name]!['generators'].add({
          'name': generator,
          'count': 1,
        });
      }
    }
    for (var name in sold) {
      for (var i = 0; i < result.length; i++) {
        if (name["name"] == result.keys.toList()[i]) {
          result[result.keys.toList()[i]]!["total_number"] =
              result[result.keys.toList()[i]]!["total_number"] + name["count"];
          result[result.keys.toList()[i]]!.addAll({"sold": name["count"]});
          break;
        } else {
          result[result.keys.toList()[i]]!.addAll({"sold": 0});
        }
      }
    }

    if (sold.isEmpty) {
      for (var i = 0; i < result.length; i++) {
        result[result.keys.toList()[i]]!["total_number"] =
            result[result.keys.toList()[i]]!["total_number"];
        result[result.keys.toList()[i]]!.addAll({"sold": 0});
      }
    }
    return result;
  }
}
