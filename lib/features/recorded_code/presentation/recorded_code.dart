import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:teach/features/recorded_code/presentation/manager/home_search/home_search_cubit.dart";
import "package:teach/data/consts/app_const.dart";
import "package:teach/data/consts/day_neight.dart";
import "package:teach/features/recorded_code/presentation/widget/recorded_code_card.dart";
import "package:teach/features/recorded_code/repo/get_all_codes_repo.dart";
import "package:teach/features/recorded_code/repo/get_searched_code_repo.dart";
import "package:teach/widgets/no_data_found.dart";

// ignore: must_be_immutable
class RecordedCode extends StatefulWidget {
  late final TextEditingController searchController;
  // ignore: prefer_const_constructors_in_immutables
  RecordedCode({super.key});
  @override
  State<RecordedCode> createState() => _RecordedCodeState();
}

class _RecordedCodeState extends State<RecordedCode> {
  @override
  void initState() {
    widget.searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () {
          context.read<HomeSearchCubit>().searchForValue(false, "");
          Navigator.pop(context);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
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
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 196, 190, 190)),
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
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color:
                        mode ? const Color.fromRGBO(0, 0, 0, 1) : Colors.white),
                child: BlocBuilder<HomeSearchCubit, HomeSearchState>(
                  builder: (context, state) {
                    return FutureBuilder(
                      future: state is SendSearchValue && state.search
                          ? GetSearchedCodeRepo()
                              .getSearchCodes(state.searchValue)
                          : GetAllCodesRepo().getAllCodes(),
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
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    RecordedCodeCard(data: data, index: index),
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
}
