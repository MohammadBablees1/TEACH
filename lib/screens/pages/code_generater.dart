import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/animatedContainerTow/animated_container_tow_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';

class CodeGenerater extends StatefulWidget {
  var isVisible = true;
  var managerName = "",
      managerPhone = "",
      managerEmail = "",
      managerPassword = "",
      filePermision = false,
      codePermision = false;
  var manager = true;
  var codes = false;
  var curseName = "", numberOfCodes = 0, cate = "";
  List<String> courses = [];
  @override
  State<CodeGenerater> createState() => _CodeGeneraterState();
}

class _CodeGeneraterState extends State<CodeGenerater> {
  GlobalKey<FormState> globalKey = GlobalKey();
  GlobalKey<FormState> globalKeyCode = GlobalKey();

  @override
  void initState() {
    fetchCourses().then((fetchedCourses) {
      setState(() {
        widget.courses = fetchedCourses;
      });
    });
    super.initState();
  }

  String? selectedCode;
  final TextEditingController searchEditingController = TextEditingController();

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar" ? "توليد الأكواد" : "Generate codes",
        ),
      ),
      body: SafeArea(child:
          BlocBuilder<AnimatedContainerTowCubit, AnimatedContainerTowState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: state is ChangeAnimation
                ? state.manager
                    ? managerBody()
                    : codesBody(context)
                : managerBody(),
          );
        },
      )),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Form managerBody() {
    return Form(
      key: globalKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                  getDeviceLocale() == "ar"
                      ? "إنشاء حساب مدير"
                      : "Create an admin account",
                  style: TextStyle(
                    fontSize: 25,
                    color: mode ? Colors.white : dayBar["blue2"],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                return nameValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              onChanged: (value) {
                widget.managerName = value;
              },
              style: TextStyle(
                color: mode
                    ? Colors.white
                    : const Color.fromARGB(255, 11, 85, 145),
              ),
              decoration: InputDecoration(
                hintText: getDeviceLocale() == "ar"
                    ? "اسم المدير..."
                    : "Manager name...",
                prefixIcon: Icon(
                  Icons.person,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: mode
                            ? nightBar["orange"]
                            : const Color.fromARGB(255, 11, 85, 145))),
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
                return phoneValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                widget.managerPhone = value;
              },
              style: TextStyle(
                  color: mode
                      ? Colors.white
                      : const Color.fromARGB(255, 11, 85, 145)),
              decoration: InputDecoration(
                hintText:
                    getDeviceLocale() == "ar" ? "رقم الهاتف ..." : "Phone...",
                prefixIcon: Icon(
                  Icons.phone,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: mode
                            ? nightBar["orange"]
                            : const Color.fromARGB(255, 11, 85, 145))),
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
                return emailValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                widget.managerEmail = value;
              },
              style: TextStyle(
                  color: mode
                      ? Colors.white
                      : const Color.fromARGB(255, 11, 85, 145)),
              decoration: InputDecoration(
                hintText: getDeviceLocale() == "ar"
                    ? "البريد الإلكتروني ..."
                    : "Email...",
                prefixIcon: Icon(
                  Icons.email,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: mode
                            ? nightBar["orange"]
                            : const Color.fromARGB(255, 11, 85, 145))),
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
            child: BlocBuilder<PasswordCubit, PasswordState>(
              builder: (context, state) {
                return TextFormField(
                  validator: (value) {
                    return newPasswordValidator(value!);
                  },
                  cursorColor: mode ? Colors.white : dayBar["blue2"],
                  obscureText:
                      state is VisiblePassword ? state.isVisible : true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    widget.managerPassword = value;
                  },
                  style: TextStyle(
                      color: mode
                          ? Colors.white
                          : const Color.fromARGB(255, 11, 85, 145)),
                  decoration: InputDecoration(
                    hintText: getDeviceLocale() == "ar"
                        ? "كلمة السر ..."
                        : "Password...",
                    prefixIcon: IconButton(
                      onPressed: () {
                        widget.isVisible = !widget.isVisible;
                        context
                            .read<PasswordCubit>()
                            .changePasswordVisibility(widget.isVisible);
                      },
                      icon: state is VisiblePassword
                          ? state.isVisible
                              ? Icon(
                                  Icons.visibility_off,
                                  color: mode ? Colors.white : dayBar["blue2"],
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: mode ? Colors.white : dayBar["blue2"],
                                )
                          : Icon(
                              Icons.visibility_off,
                              color: mode ? Colors.white : dayBar["blue2"],
                            ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            width: 1,
                            color: mode
                                ? nightBar["orange"]
                                : const Color.fromARGB(255, 11, 85, 145))),
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
                );
              },
            ),
          ),
          BlocBuilder<PasswordCubit, PasswordState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.filePermision
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.filePermision = value;

                      context
                          .read<PasswordCubit>()
                          .changePermision(value, widget.codePermision);
                    },
                    title: Text(
                      getDeviceLocale() == "ar"
                          ? "صلاحيات ترفيع الملفات"
                          : "File upload permissions",
                      style: TextStyle(),
                    ),
                  ),
                  SwitchListTile(
                    activeColor: mode
                        ? nightBar["orange"]
                        : const Color.fromARGB(255, 11, 85, 145),
                    value: state is FilePermisions
                        ? state.codePermesion
                            ? true
                            : false
                        : false,
                    onChanged: (value) {
                      widget.codePermision = value;

                      context
                          .read<PasswordCubit>()
                          .changePermision(widget.filePermision, value);
                    },
                    title: Text(
                      getDeviceLocale() == "ar"
                          ? "صلاحيات توليد الأكواد "
                          : "Code generation permissions",
                      style: TextStyle(),
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () async {
                  if (await checkConnection()) {
                    if (!globalKey.currentState!.validate() ||
                        (!widget.filePermision && !widget.codePermision)) {
                      lunchAwesomDialoge(
                          DialogType.error,
                          "e",
                          getDeviceLocale() == "ar"
                              ? "يرجى كتابة جميع المعلومات"
                              : "Please write all information",
                          context,
                          getWidth(context),
                          getHeight(context));
                    } else {
                      try {
                        context.read<LunchLoadingCubit>().lunchLoading(true);
                        await context
                            .read<PasswordCubit>()
                            .createManagerAccount(
                                name: widget.managerName,
                                phone: widget.managerPhone,
                                email: widget.managerEmail,
                                password: widget.managerPassword,
                                filePermision: widget.filePermision,
                                codePermision: widget.codePermision);
                        context.read<LunchLoadingCubit>().lunchLoading(false);
                        lunchAwesomDialoge(
                            DialogType.success,
                            "s",
                            getDeviceLocale() == "ar"
                                ? "تمّت العملية بنجاح"
                                : "The operation was completed successfully.",
                            context,
                            getWidth(context),
                            getHeight(context));
                      } catch (e) {
                        context.read<LunchLoadingCubit>().lunchLoading(false);

                        String errorMessage;
                        if (e is AuthException) {
                          errorMessage = handleAuthError(e, getDeviceLocale());
                        } else if (e is PostgrestException) {
                          errorMessage =
                              handleDatabaseError(e, getDeviceLocale());
                        } else {
                          errorMessage = getDeviceLocale() == "ar"
                              ? "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى"
                              : "An unexpected error occurred. Please try again";
                        }
                        lunchAwesomDialoge(DialogType.error, "e", errorMessage,
                            context, getWidth(context), getHeight(context));
                      }
                    }
                  } else {
                    lunchAwesomDialoge(
                        DialogType.warning,
                        "e",
                        getDeviceLocale() == "ar"
                            ? "تأكد من اتصالك بالإنترنت"
                            : "Make sure you are connected to the Internet",
                        context,
                        getWidth(context),
                        getHeight(context));
                  }
                },
                child: state is LunchLoading
                    ? state.loading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            getDeviceLocale() == "ar" ? "توليد" : "generate",
                            style: TextStyle(color: Colors.white),
                          )
                    : Text(
                        getDeviceLocale() == "ar" ? "توليد" : "generate",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(
                  width: .5,
                )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget bottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: getHeight(context) / 15,
      child: Container(
        height: getHeight(context) / 20,
        width: getWidth(context),
        child:
            BlocBuilder<AnimatedContainerTowCubit, AnimatedContainerTowState>(
          builder: (context, state) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      widget.manager = true;
                      widget.codes = false;
                      context
                          .read<AnimatedContainerTowCubit>()
                          .chnageAnimation(widget.manager, widget.codes);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: getWidth(context) / 4,
                          child: Center(
                            child: AnimatedContainer(
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: state is ChangeAnimation
                                  ? state.manager
                                      ? getWidth(context) / 4
                                      : 0
                                  : getWidth(context) / 4,
                              duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(.3)),
                            ),
                          ),
                        ),
                        Container(
                          width: getWidth(context) / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.manage_accounts_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                getDeviceLocale() == "ar"
                                    ? "المدراء"
                                    : "Managers",
                                style: TextStyle(
                                    fontWeight: state is ChangeAnimation
                                        ? state.manager
                                            ? FontWeight.bold
                                            : FontWeight.w100
                                        : FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.manager = false;
                      widget.codes = true;
                      context
                          .read<AnimatedContainerTowCubit>()
                          .chnageAnimation(widget.manager, widget.codes);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                    child: Stack(
                      children: [
                        SizedBox(
                            width: getWidth(context) / 4,
                            child: Center(
                              child: AnimatedContainer(
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: state is ChangeAnimation
                                    ? state.codes
                                        ? getWidth(context) / 4
                                        : 0
                                    : 0,
                                duration: Duration(seconds: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(.3)),
                              ),
                            )),
                        Container(
                          width: getWidth(context) / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.code,
                                color: Colors.white,
                              ),
                              Text(
                                getDeviceLocale() == "ar"
                                    ? "الكورسات"
                                    : "Courses",
                                style: TextStyle(
                                    fontWeight: state is ChangeAnimation
                                        ? state.codes
                                            ? FontWeight.bold
                                            : FontWeight.w100
                                        : FontWeight.w100,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  codesBody(BuildContext context) {
    return Form(
      key: globalKeyCode,
      child: Column(
        children: [
          FutureBuilder(
              future: fetchCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Image.asset("images/loading.gif"),
                  );
                } else {
                  var data = snapshot.data;
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(getDeviceLocale() == "ar"
                          ? "اختر الكورس المطلوب"
                          : "Choose the required course"),
                      items: data!.map((String course) {
                        return DropdownMenuItem<String>(
                          value: course,
                          child: Text(course),
                        );
                      }).toList(),
                      value: selectedCode,
                      onChanged: (value) {
                        setState(() {
                          selectedCode = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        width: getWidth(context) * .95,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(color: Colors.white)),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 60,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: searchEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: searchEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: getDeviceLocale() == "ar"
                                  ? 'البحث عن كورس...'
                                  : 'Search for an course...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          searchEditingController.clear();
                        }
                      },
                    ),
                  );
                }
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                return codeGeneratorValidator(value!);
              },
              cursorColor: mode ? Colors.white : dayBar["blue2"],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.numberOfCodes = int.parse(value);
              },
              style: TextStyle(
                  color: mode
                      ? Colors.white
                      : const Color.fromARGB(255, 11, 85, 145)),
              decoration: InputDecoration(
                hintText: getDeviceLocale() == "ar"
                    ? "عدد الأكواد المطلوبة..."
                    : "Number of codes required...",
                prefixIcon: Icon(
                  Icons.numbers,
                  color: mode ? Colors.white : dayBar["blue2"],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        width: 1,
                        color: mode
                            ? nightBar["orange"]
                            : const Color.fromARGB(255, 11, 85, 145))),
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
          BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () async {
                  if (await checkConnection()) {
                    if (globalKeyCode.currentState!.validate() &&
                        selectedCode != null) {
                      context.read<LunchLoadingCubit>().lunchLoading(true);
                      await context.read<PasswordCubit>().createCodes(
                            name: selectedCode,
                            number: widget.numberOfCodes,
                          );
                      context.read<LunchLoadingCubit>().lunchLoading(false);
                      lunchAwesomDialoge(
                          DialogType.success,
                          "s",
                          getDeviceLocale() == "ar"
                              ? "تمّت العملية بنجاح"
                              : "The operation was completed successfully.",
                          context,
                          getWidth(context),
                          getHeight(context));
                    }
                  } else {
                    lunchAwesomDialoge(
                        DialogType.warning,
                        "e",
                        getDeviceLocale() == "ar"
                            ? "تأكد من اتصالك بالإنترنت"
                            : "Make sure you are connected to the Internet",
                        context,
                        getWidth(context),
                        getHeight(context));
                  }
                },
                child: state is LunchLoading
                    ? state.loading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            getDeviceLocale() == "ar" ? "توليد" : "generate",
                            style: TextStyle(color: Colors.white),
                          )
                    : Text(
                        getDeviceLocale() == "ar" ? "توليد" : "generate",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                    side: BorderSide(
                  width: .5,
                )),
              );
            },
          ),
        ],
      ),
    );
  }
}
