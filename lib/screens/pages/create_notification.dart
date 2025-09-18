import "package:auto_size_text/auto_size_text.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart";
import "package:teach/data/consts/app_const.dart";
import "package:teach/data/consts/day_neight.dart";
import "package:teach/main.dart";
import "package:teach/screens/notifications/send.dart";

class CreateNotification extends StatefulWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  String? selectedValue, selectedGrade, previusGrade;
  @override
  State<CreateNotification> createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                  width: getWidth(context) * .3,
                  height: getWidth(context) * .4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(
                        Icons.notification_add,
                        size: getWidth(context) * .2,
                        color: Colors.white,
                      ))),
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
                          ? "إنشاء إشعار"
                          : "Create Notification",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
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
                  child: TextFormField(
                    validator: (value) {
                      return nameValidator(value!);
                    },
                    cursorColor: mode ? Colors.white : dayBar["blue"],
                    controller: widget.titleController,
                    style: TextStyle(
                        color: mode
                            ? Colors.white
                            : const Color.fromARGB(255, 11, 85, 145)),
                    decoration: InputDecoration(
                      hintText: getDeviceLocale() == "ar"
                          ? "عنوان الإشعار  : "
                          : "Notification title : ",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1,
                              color: mode
                                  ? nightBar["orange"]
                                  : const Color.fromARGB(255, 11, 85, 145))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1.5,
                              color: mode
                                  ? nightBar["orange"]
                                  : const Color.fromARGB(255, 11, 85, 145))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      return nameValidator(value!);
                    },
                    cursorColor: mode ? Colors.white : dayBar["blue"],
                    controller: widget.bodyController,
                    style: TextStyle(
                        color: mode
                            ? Colors.white
                            : const Color.fromARGB(255, 11, 85, 145)),
                    decoration: InputDecoration(
                      hintText: getDeviceLocale() == "ar"
                          ? "نص الإشعار  : "
                          : "Notification body : ",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1,
                              color: mode
                                  ? nightBar["orange"]
                                  : const Color.fromARGB(255, 11, 85, 145))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              width: 1.5,
                              color: mode
                                  ? nightBar["orange"]
                                  : const Color.fromARGB(255, 11, 85, 145))),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      borderRadius: BorderRadius.circular(20))),
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
                                      .map((String value) => DropdownMenuItem(
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
                                            value: value,
                                          ))
                                      .toList()
                                  : (data)!
                                      .map((String value) => DropdownMenuItem(
                                            child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                value),
                                            value: value,
                                          ))
                                      .toList(),
                              value: widget.selectedGrade != null
                                  ? widget.previusGrade != widget.selectedValue
                                      ? data[0]
                                      : widget.selectedGrade
                                  : widget.selectedGrade,
                              onChanged: (value) {
                                setState(() {
                                  widget.selectedGrade = value;
                                  widget.previusGrade = widget.selectedValue;

                                  id = universety.where(
                                    (element) => element.name == value,
                                  );
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                color: mode ? nightBar["orange"] : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              )),
                            ),
                          ),
                        );
                      }
                    }),
                BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) => ElevatedButton(
                        onPressed: () async {
                          try {
                            context
                                .read<LunchLoadingCubit>()
                                .sendNotification(true);
                            var data;
                            if (widget.selectedGrade == null ||
                                widget.selectedGrade!.isEmpty) {
                              data = await supabase.from("users").select();
                            } else {
                              data = await supabase
                                  .from("users")
                                  .select()
                                  .eq("role", widget.selectedGrade!);
                            }
                            if (data != null || data.isNotEmpty) {
                              for (var i = 0; i < data.length; i++) {
                                await sendNotificationToUser(
                                    data[i]["id"],
                                    widget.titleController.text
                                        .toString()
                                        .trim(),
                                    widget.bodyController.text
                                        .toString()
                                        .trim());
                              }
                            }

                            context
                                .read<LunchLoadingCubit>()
                                .sendNotification(false);
                          } catch (e) {
                            context
                                .read<LunchLoadingCubit>()
                                .sendNotification(false);
                            print(e);
                          }
                        },
                        child: state is SendNotification && state.loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "إرسال" : "Send",
                                style: TextStyle(color: Colors.white),
                              ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
