import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class StudentMainScreenDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final GestureTapCallback onTab;
  const StudentMainScreenDrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTab,
          leading: Icon(
            icon,
            color: mode ? Colors.white : dayBar["blue3"],
          ),
          title: AutoSizeText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            maxFontSize: 15,
            title,
            style: TextStyle(
                color: mode ? Colors.white : dayBar["blue3"],
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: getWidth(context),
          height: 1,
          color: mode ? Colors.grey.shade300 : dayBar["blue3"],
        ),
      ],
    );
  }
}
