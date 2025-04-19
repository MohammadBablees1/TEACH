import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar" ? "إضافة إعلان" : "Add an ad",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              if (!widget.once) {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (!widget.once) {
            Navigator.pop(context);
          }
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      var pickedImage =
                          await picker.pickImage(source: ImageSource.gallery);
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
                        color: mode ? nightBar["buttons"] : dayBar["blue"],
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
                                  Text(
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
                    child: Text(
                      getDeviceLocale() == "ar"
                          ? "اختر الفئة المتبوع لها : "
                          : "Choose the category to follow : ",
                      style: TextStyle(
                          color: mode ? Colors.white : dayBar["blue2"]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: mode ? Colors.white : dayBar["blue2"],
                              ),
                              borderRadius: BorderRadius.circular(20))),
                      hint: Text(
                        getDeviceLocale() == "ar"
                            ? "اختر الفئة المتبوع لها : "
                            : "Choose the category to follow : ",
                      ),
                      items: getDeviceLocale() == "ar"
                          ? itemsInArabic
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList()
                          : itemsInEnglish
                              .map((String value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                      value: widget.selectedValue,
                      onChanged: (value) {
                        setState(() {
                          widget.selectedValue = value;
                        });
                      },
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                        color: mode ? nightBar["orange"] : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                    ),
                  ),
                ),
                widget.selectedValue != null
                    ? FutureBuilder(
                        future: getTruthSubject(widget.selectedValue),
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
                                  hint: Text(
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
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
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
                        })
                    : Container(),
                widget.selectedGrade != null &&
                        (widget.selectedValue == "جامعي" ||
                            widget.selectedValue == itemsInEnglish[3])
                    ? FutureBuilder(
                        future:
                            getTruthDegree(widget.selectedGrade, id.first.id),
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
                                  hint: Text(
                                    getDeviceLocale() == "ar"
                                        ? "اختر الدرجة العلمية : "
                                        : "Choose the academic degree : ",
                                  ),
                                  items: getDeviceLocale() == "ar"
                                      ? (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child:
                                                    Text(value.split("/").last),
                                                value: value,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList(),
                                  value: widget.selectedCollage != null
                                      ? widget.previusCollage !=
                                              widget.selectedGrade
                                          ? data[0].split("/").last
                                          : widget.selectedCollage
                                      : widget.selectedCollage,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selectedCollage = value;
                                      widget.previusCollage =
                                          widget.selectedGrade;
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
                        })
                    : Container(),
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
                      return BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (loading) {
                              } else {
                                if (widget.imageFile.path.isEmpty ||
                                    widget.selectedValue == null ||
                                    widget.selectedImage.isEmpty ||
                                    widget.selectedImage == "" ||
                                    widget.selectedGrade == null ||
                                    widget.selectedCollage ==
                                        (getDeviceLocale() == "ar"
                                            ? "لا توجد كورسات للجامعة المختارة"
                                            : "There are no courses for the selected university.") ||
                                    (widget.selectedValue == "جامعي" &&
                                        widget.selectedCollage == null)) {
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
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(true);
                                  await BlocProvider.of<TeachCubit>(context)
                                      .createAd(
                                          File(widget.imageFile.path),
                                          widget.selectedValue.toString(),
                                          widget.selectedGrade.toString(),
                                          widget.selectedCollage.toString());
                                 context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              ClauserIndexCubit(),
                                          child: MainScreen(),
                                        ),
                                      ),
                                      (Route<dynamic> route) => false);
                                }
                              }
                            },
                            child: state is LoadingPdf && state.loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    getDeviceLocale() == "ar"
                                        ? "نشر"
                                        : "Publish",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mode
                                    ? nightBar["buttons"]
                                    : dayBar["blue2"]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
