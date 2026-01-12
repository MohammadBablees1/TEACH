import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teach/core/supabase_client.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/recorded_code/repo/fitch_folder_id_by_name_repo.dart';
import 'package:teach/features/recorded_code/repo/generate_pdf.dart';
import 'package:teach/features/recorded_code/repo/generate_bar_code_repo.dart';

class RecordedCodeCard extends StatefulWidget {
  final Map<String, Map<String, dynamic>> data;
  final int index;
  const RecordedCodeCard({super.key, required this.data, required this.index});

  @override
  State<RecordedCodeCard> createState() => _RecordedCodeCardState();
}

class _RecordedCodeCardState extends State<RecordedCodeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: mode ? nightBar["orange"] : dayBar["blue3"],
      child: SizedBox(
        width: getWidth(context),
        height: getWidth(context) * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              widget.data.keys.toList()[widget.index],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: getWidth(context) * .5,
                  height: getWidth(context) * .7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "الأكواد المولّدة : "
                            : "Generated codes : ",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? " العدد الكلّي : "
                                : " Total number : ",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            widget.data[widget.data.keys
                                    .toList()[widget.index]]!["total_number"]
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? " العدد المباع : "
                                : " Sold number : ",
                            style: const TextStyle(color: Colors.white),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            widget.data[widget.data.keys
                                    .toList()[widget.index]]!["sold"]
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: getWidth(context) * .5,
                        height: getWidth(context) * .1,
                        child: ListView.builder(
                            itemCount: widget
                                .data[widget.data.keys.toList()[widget.index]]![
                                    "generators"]
                                .length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: getWidth(context) * .2,
                                      height: getWidth(context) * .06,
                                      decoration: BoxDecoration(
                                          color: mode
                                              ? dayBar["blue2"]
                                              : nightBar["buttons"],
                                          borderRadius: BorderRadius.circular(
                                              getWidth(context) * .01),
                                          border: Border.all(
                                              width: .5,
                                              color: mode
                                                  ? Colors.orange
                                                  : Colors.blue)),
                                      child: Center(
                                        child: AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          widget.data[widget.data.keys.toList()[
                                                  widget.index]]!["generators"]
                                              [i]["name"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: getWidth(context) * .2,
                                    height: getWidth(context) * .06,
                                    decoration: BoxDecoration(
                                        color: mode
                                            ? dayBar["blue2"]
                                            : nightBar["buttons"],
                                        borderRadius: BorderRadius.circular(
                                            getWidth(context) * .01),
                                        border: Border.all(
                                            width: .5,
                                            color: mode
                                                ? Colors.orange
                                                : Colors.blue)),
                                    child: Center(
                                      child: AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          widget.data[widget.data.keys
                                                      .toList()[widget.index]]![
                                                  "generators"][i]["count"]
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: getHeight(context) * .3,
                                      width: getWidth(context) * .8,
                                      child: ListView.builder(
                                        itemCount: widget
                                            .data[widget.data.keys.toList()[
                                                widget.index]]!["generators"]
                                            .length,
                                        itemBuilder: (context, i) {
                                          return BlocBuilder<LunchLoadingCubit,
                                              LunchLoadingState>(
                                            builder: (context, state) {
                                              return ElevatedButton(
                                                onPressed: () async {
                                                  context
                                                      .read<LunchLoadingCubit>()
                                                      .getCodeLoding(true, i);
                                                  // ignore: use_build_context_synchronously
                                              await GenerateBarCodeRepo().showGeneratorsName(context, widget.data, widget.index, i);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: mode
                                                        ? nightBar["buttons"]
                                                        : dayBar["blue3"]),
                                                child: state
                                                            is GetCodeLoading &&
                                                        state.loading &&
                                                        state.index == i
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    : AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        widget.data[
                                                                widget.data.keys
                                                                        .toList()[
                                                                    widget
                                                                        .index]]![
                                                                "generators"][i]
                                                                ["name"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mode
                                    ? nightBar["buttons"]
                                    : dayBar["blue2"]),
                            child: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "اختيار كود عشوائي"
                                  : "Select random code",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () async {
                                  try {
                                    context
                                        .read<LunchLoadingCubit>()
                                        .generatePdf(true, widget.index);
                                    await GeneratePdfRepo().generatePdf(widget
                                        .data.keys
                                        .toList()[widget.index]);
                                    // ignore: use_build_context_synchronously
                                    context
                                        .read<LunchLoadingCubit>()
                                        .generatePdf(false, widget.index);
                                  } catch (e) {
                                    // ignore: use_build_context_synchronously
                                    context
                                        .read<LunchLoadingCubit>()
                                        .generatePdf(false, widget.index);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mode
                                        ? nightBar["buttons"]
                                        : dayBar["blue2"]),
                                child: state is GeneratePdf &&
                                        state.loading &&
                                        state.index == widget.index
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "تصدير إلى ملف pdf"
                                            : "Export to pdf",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              try {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: SizedBox(
                                      width: getWidth(context) * .5,
                                      height: getWidth(context) * .2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(getDeviceLocale() == "ar"
                                              ? "هل أنت متأكد ؟"
                                              : "Are you sure ?"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              BlocBuilder<LunchLoadingCubit,
                                                  LunchLoadingState>(
                                                builder: (context, state) {
                                                  return ElevatedButton(
                                                      onPressed: () async {
                                                        context
                                                            .read<
                                                                LunchLoadingCubit>()
                                                            .deleteAllCodesFromUser(
                                                                true,
                                                                widget.index);
                                                        var userData =
                                                            await supabase
                                                                .from(
                                                                    "current_user")
                                                                .select();
                                                        String codeData =
                                                            await FitchFolderIdByNameRepo()
                                                                .fetchFolderIdByName(widget
                                                                    .data.keys
                                                                    .toList()[
                                                                        widget
                                                                            .index]
                                                                    .toString());
                                                        for (var i = 0;
                                                            i < userData.length;
                                                            i++) {
                                                          List codes =
                                                              userData[i]
                                                                  ["codes"];
                                                          if (kDebugMode) {
                                                            print("++++++++");
                                                          }
                                                          if (codes
                                                                  .isNotEmpty ||
                                                              codes != [] ||
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
                                                              "codes": codes
                                                            }).eq(
                                                                    "id",
                                                                    userData[i]
                                                                        ["id"]);
                                                          }
                                                        }
                                                        // ignore: use_build_context_synchronously
                                                        context
                                                            .read<
                                                                LunchLoadingCubit>()
                                                            .deleteAllCodesFromUser(
                                                                false,
                                                                widget.index);
                                                      },
                                                      child: state
                                                                  is DeleteAllCodesFromUser &&
                                                              state.loading &&
                                                              state.index ==
                                                                  widget.index
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Text(
                                                              getDeviceLocale() ==
                                                                      "ar"
                                                                  ? "نعم"
                                                                  : "Yes",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ));
                                                },
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    getDeviceLocale() == "ar"
                                                        ? "لا"
                                                        : "No",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                context
                                    .read<LunchLoadingCubit>()
                                    .deleteAllCodesFromUser(
                                        false, widget.index);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mode
                                    ? nightBar["buttons"]
                                    : dayBar["blue2"]),
                            child: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "تعطيل جميع الاشتراكات"
                                  : "Disable all subscriptions",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60,
                      lineWidth: getWidth(context) * .08,
                      percent: (100 *
                              widget.data[widget.data.keys
                                  .toList()[widget.index]]!["sold"] /
                              widget.data[widget.data.keys
                                  .toList()[widget.index]]!["total_number"]) /
                          100,
                      startAngle: 60,
                      progressColor: const Color.fromARGB(255, 1, 160, 6),
                      backgroundColor: const Color.fromARGB(255, 178, 9, 184),
                      center: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        "${((100 * widget.data[widget.data.keys.toList()[widget.index]]!["sold"] ~/ widget.data[widget.data.keys.toList()[widget.index]]!["total_number"])).toStringAsFixed(1)} %",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: getWidth(context) * .05,
                              height: getWidth(context) * .05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  getWidth(context) * .01,
                                ),
                                color: const Color.fromARGB(255, 1, 160, 6),
                              ),
                            ),
                            AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "الأكواد المباعة"
                                  : "Selled Codes",
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: getWidth(context) * .05,
                              height: getWidth(context) * .05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  getWidth(context) * .01,
                                ),
                                color: const Color.fromARGB(255, 178, 9, 184),
                              ),
                            ),
                            AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "الأكواد المولّدة"
                                  : "Generated Codes",
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 
}
