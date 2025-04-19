import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'wave_clipper.dart';

class CustomWaveAppBar extends StatelessWidget {
  final String username;
  final Function(String) onSearch;

  const CustomWaveAppBar({
    Key? key,
    required this.username,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: WaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: mode
                    ? [
                        nightBar["orange"],
                        nightBar["buttons"],
                      ]
                    : [Colors.blue.shade700, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // السطر الأول: اسم المستخدم وزر القائمة
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                        Expanded(
                          child: Text(
                            getDeviceLocale() == "ar"
                                ? 'أهلاً بك $username'
                                : "Welcom  $username",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // السطر الثاني: حقل البحث
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      style: TextStyle(
                          color: mode ? nightBar["orange"] : dayBar["blue2"]),
                      cursorColor: mode ? nightBar["orange"] : dayBar["blue2"],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: Icon(Icons.search,
                            color: mode
                                ? nightBar["orange"]
                                : Colors.blue.shade700),
                        hintText: 'ابحث هنا...',
                        hintStyle: TextStyle(
                            color: mode
                                ? nightBar["orange"].withOpacity(.5)
                                : Colors.blue.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: onSearch,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
