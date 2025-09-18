import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/folders.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/widgets/loading_upload.dart';

class AddAds extends StatefulWidget {
  var selectedImage = "";
  XFile imageFile = XFile("images/icon.jpg");
  var title = "";
  var text = "";
  var once = false;
  String? selectedValue;
  String? selectedGrade;
  Object? selectedCollage;
  String? previusGrade;
  String? previusCollage;
  late var id;
  @override
  State<AddAds> createState() => _AddAdsState();
}

class _AddAdsState extends State<AddAds> {
  var loading = false;
  var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: () {
          context.read<ManagerScreenCubit>().changeIndex(0);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getWidth(context) * .4,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getWidth(context) * .05),
                      child: SizedBox(
                          width: getWidth(context) * .15,
                          height: getWidth(context) * .15,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "images/add_ads.png",
                                width: getWidth(context),
                                fit: BoxFit.cover,
                              ))),
                    ),
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
                                ? "إنشاء إعلان جديد"
                                : "Create new ad",
                            style: TextStyle(
                                fontSize: getWidth(context) * .05,
                                color: Colors.white),
                          ),
                        ),
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
                    color: mode ? Colors.black : Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          var pickedImage = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            widget.selectedImage = pickedImage!.path;
                            widget.imageFile = pickedImage;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: getWidth(context),
                          height: getHeight(context) / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: mode ? nightBar["buttons"] : dayBar["blue3"],
                          ),
                          child: Center(
                            child: widget.selectedImage == ""
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "اضغط لاختيار صورة للإعلان"
                                            : "Click to select an image for the ad",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      width: getWidth(context),
                                      File(widget.selectedImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: getWidth(context),
                        child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "اختر الفئة المتبوع لها : "
                              : "Choose the category to follow : ",
                          style: TextStyle(
                              color: mode ? Colors.white : dayBar["blue2"]),
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: getTruthSubject(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: mode ? Colors.white : dayBar["blue2"],
                              ),
                            );
                          } else {
                            var data = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: mode
                                                ? Colors.white
                                                : dayBar["blue2"],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  hint: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? widget.selectedValue == "جامعي" ||
                                                widget.selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "اختر نوع الجامعة"
                                            : "اختر الدرجة العلمية : "
                                        : widget.selectedValue == "جامعي" ||
                                                widget.selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "Choose the type of university"
                                            : "Choose the academic degree : ",
                                  ),
                                  items: getDeviceLocale() == "ar"
                                      ? (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    value),
                                                value: value,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    value),
                                                value: value,
                                              ))
                                          .toList(),
                                  value: widget.selectedGrade != null
                                      ? widget.previusGrade !=
                                              widget.selectedValue
                                          ? data[0]
                                          : widget.selectedGrade
                                      : widget.selectedGrade,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selectedGrade = value;
                                      widget.previusGrade =
                                          widget.selectedValue;

                                      id = universety.where(
                                        (element) => element.name == value,
                                      );
                                    });
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                    color: mode
                                        ? nightBar["orange"]
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  )),
                                ),
                              ),
                            );
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocConsumer<TeachCubit, TeachState>(
                        listener: (context, state) async {
                          if (state is Percentage && !widget.once) {
                            widget.once = true;
                            await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => LoadingUpload());
                          }
                        },
                        builder: (context, state) {
                          return BlocBuilder<LunchLoadingCubit,
                              LunchLoadingState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () async {
                                  if (loading) {
                                  } else {
                                    if (widget.imageFile.path.isEmpty ||
                                        widget.selectedImage.isEmpty ||
                                        widget.selectedImage == "" ||
                                        widget.selectedGrade == null) {
                                      lunchAwesomDialoge(
                                          DialogType.error,
                                          "e",
                                          getDeviceLocale() == "ar"
                                              ? "يرجى تعبئة جميع الحقول"
                                              : "Please fill in all fields.",
                                          context,
                                          getWidth(context),
                                          getHeight(context));
                                    } else {
                                      context
                                          .read<LunchLoadingCubit>()
                                          .lunchLoading(true);
                                      await BlocProvider.of<TeachCubit>(context)
                                          .createAd(File(widget.imageFile.path),
                                              widget.selectedGrade.toString());
                                      context
                                          .read<LunchLoadingCubit>()
                                          .lunchLoading(false);
                                      lunchAwesomDialoge(
                                          DialogType.success,
                                          "s",
                                          getDeviceLocale() == "ar"
                                              ? "تمّت العملية بنجاح"
                                              : "The operation was successful.",
                                          context,
                                          getWidth(context),
                                          getHeight(context));
                                    }
                                  }
                                },
                                child: state is LunchLoading && state.loading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "نشر"
                                            : "Publish",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mode
                                        ? nightBar["buttons"]
                                        : dayBar["blue3"]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
