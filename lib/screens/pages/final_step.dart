import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/selected_value/selected_value_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/widgets/no_data_found.dart';

class FinalStep extends StatefulWidget {
  var grade = 12;
  FinalStep({required this.grade});
  @override
  State<FinalStep> createState() => _FinalStepState();
}

class _FinalStepState extends State<FinalStep> {
  var selectedClass = "";
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "images/white_icon.jpg",
                  width: getWidth(context) / 3,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getDeviceLocale() == "ar"
                    ? "اختر ما يناسبك : "
                    : "Choose what suits you:",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: fetchMyData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset("images/loading.gif"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        width: getWidth(context),
                        height: getWidth(context),
                        child: Center(
                          child: NoDataFound(),
                        ),
                      );
                    } else {
                      var data = snapshot.data;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 2,
                            duration: Duration(milliseconds: 500),
                            child: ScaleAnimation(
                              duration: Duration(milliseconds: 800),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: BlocBuilder<SelectedValueCubit,
                                    SelectedValueState>(
                                  builder: (context, state) {
                                    return InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        context
                                            .read<SelectedValueCubit>()
                                            .changeValue(data[index]);
                                        selectedClass = data[index];
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            mode
                                                ? BoxShadow()
                                                : BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 30,
                                                    spreadRadius: 0.0,
                                                    offset: Offset(0, 15),
                                                  )
                                          ],
                                          gradient: LinearGradient(
                                            colors: mode
                                                ? [
                                                    nightBar["orange"],
                                                    nightBar["buttons"],
                                                  ]
                                                : state is SelectedValue && state.value == data[index] ?
                                                     [
                                                        const Color.fromARGB(
                                                            255, 7, 109, 10),
                                                        const Color.fromARGB(
                                                            255, 11, 105, 14)
                                                      ]
                                                    : [
                                                        const Color.fromARGB(
                                                            255, 11, 85, 145),
                                                        const Color.fromARGB(
                                                            255, 4, 96, 172)
                                                      ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(children: [
                                              Container(
                                                width: getWidth(context),
                                                height: getHeight(context) / 10,
                                                decoration: BoxDecoration(
                                                    color: mode
                                                        ? Colors.grey
                                                            .withOpacity(.4)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.school,
                                                  size: 40,
                                                  color: selectedClass ==
                                                          data[index]
                                                      ? const Color.fromARGB(
                                                          255, 7, 109, 10)
                                                      : dayBar["blue"],
                                                )),
                                              ),
                                            ]),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    data[index],
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () async {
                        context.read<LoadingPdfCubit>().loadingPdf(true);
                        var box = Hive.box(hiveBoxName);
                        box.put("univarsity", ""); // we are here ...
                        context.read<LoadingPdfCubit>().loadingPdf(false);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: state is LoadingPdf && state.loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              getDeviceLocale() == "ar" ? "متابعة" : "Start",
                              style: TextStyle(color: Colors.white),
                            ));
                },
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchMyData() async {
    widget.grade = 12;
    if (widget.grade <= 6) {
      List<String> primary = [];

      var data = await supabase
          .from("folders")
          .select("name")
          .filter("parent_id", "is", null);
      for (var i = 0; i < data.length; i++) {
        if (primaryInArabic.contains(data[i]["name"]) ||
            primaryInEnglish.contains(data[i]["name"])) {
          primary.add(data[i]["name"]);
        }
      }
      return primary;
    } else if (widget.grade <= 9) {
      List<String> preparatory = [];

      var data = await supabase
          .from("folders")
          .select("name")
          .filter("parent_id", "is", null);
      for (var i = 0; i < data.length; i++) {
        if (preparatoryInArabic.contains(data[i]["name"]) ||
            preparatoryInEnglish.contains(data[i]["name"])) {
          preparatory.add(data[i]["name"]);
        }
      }
      return preparatory;
    } else if (widget.grade <= 12) {
      List<String> secondary = [];

      var data = await supabase
          .from("folders")
          .select("name")
          .filter("parent_id", "is", null);
      print(data);

      for (var i = 0; i < data.length; i++) {
        if (secondaryInArabic.contains(data[i]["name"]) ||
            secondaryInEnglish.contains(data[i]["name"])) {
          secondary.add(data[i]["name"]);
        }
      }
      return secondary;
    } else {
      List<String> university = [];

      var data = await supabase
          .from("folders")
          .select("name")
          .filter("parent_id", "is", null);

      for (var i = 0; i < data.length; i++) {
        if (!school.contains(data[i]["name"])) {
          university.add(data[i]["name"]);
        }
      }
      return university;
    }
  }
}
