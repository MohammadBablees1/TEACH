import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/screens/main_screen.dart';

class EditableAdScreen extends StatefulWidget {
  var ad;
  var selectedImage = "";
  var imageFile = XFile("images/icon.jpg");

  var loading = false;
  String category = "";
  String grade = "";
  String collage = "";
  EditableAdScreen({required this.ad});
  String? selectedValue;
  String? selectedGrade;
  Object? selectedCollage;
  String? previusGrade;
  String? previusCollage;
  @override
  State<EditableAdScreen> createState() => _EditableAdScreenState();
}

class _EditableAdScreenState extends State<EditableAdScreen> {
  @override
  void initState() {
    widget.selectedGrade = widget.ad["grade"];
    widget.selectedValue = widget.ad["category"];
    widget.previusGrade = widget.selectedValue;
    widget.previusCollage = widget.selectedGrade;
    widget.selectedCollage = widget.ad["collage"];
    id = universety.where(
      (element) => element.name == widget.selectedGrade,
    );

    super.initState();
  }

  var customCachManager = CacheManager(Config(
    "customCacheKey",
    stalePeriod: Duration(days: 7),
  ));
  late var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar" ? "تعديل الإعلان" : "ُEdit the ad",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              if (!widget.loading) {
                Navigator.pop(context);
              }
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MainScreen(),
              //     ),
              //     (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (!widget.loading) {
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
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    cacheManager: customCachManager,
                                    imageUrl: '${widget.ad["imageUrl"]}',
                                    cacheKey:
                                        '${widget.ad["id"]}_${widget.ad["updated_at"]}',
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                    placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: mode
                                              ? Colors.white
                                              : dayBar["blue"],
                                        ))),
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
                                  value: widget.previusGrade !=
                                          widget.selectedValue
                                      ? data[0]
                                      : widget.selectedGrade,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selectedGrade = value;
                                      widget.previusGrade =
                                          widget.selectedValue;
                                      id = universety.where(
                                        (element) =>
                                            element.name ==
                                            widget.selectedGrade,
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
                            widget.selectedValue == itemsInEnglish[3]) &&
                        (widget.previusGrade == "جامعي" ||
                            widget.previusGrade == itemsInEnglish[3])
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
                                                value: value.split("/").last,
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                child: Text(value),
                                                value: value,
                                              ))
                                          .toList(),
                                  value: (widget.previusCollage !=
                                              widget.selectedGrade) ||
                                          (widget.selectedValue !=
                                              widget.selectedGrade)
                                      ? data[0]
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
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      widget.loading = true;
                    });

                    await BlocProvider.of<TeachCubit>(context).editAd({
                      "imageUrl": widget.ad["imageUrl"],
                      if (widget.selectedValue != null)
                        "category": widget.selectedValue,
                      if (widget.selectedGrade != null)
                        "grade": widget.selectedGrade,
                      "collage": widget.selectedCollage != null &&
                              (widget.selectedValue == "جامعي" ||
                                  widget.selectedValue == itemsInEnglish[3])
                          ? widget.collage
                          : "",
                    }, widget.selectedImage != "", widget.selectedImage,
                        widget.ad);

                    setState(() {
                      widget.loading = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ClauserIndexCubit(),
                            child: MainScreen(),
                          ),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  child: widget.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          getDeviceLocale() == "ar" ? "تعديل" : "Edit",
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          mode ? nightBar["buttons"] : dayBar["blue2"]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
