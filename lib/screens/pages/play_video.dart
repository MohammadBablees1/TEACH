import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/quize.dart';
import 'package:teach/screens/pages/view_pdf.dart';
import 'package:teach/widgets/vedio_cached_manager_widget.dart';
import 'package:teach/widgets/vedio_cached_manager_widget_ai.dart';
import 'package:uuid/uuid.dart';

class PlayVideo extends StatefulWidget {
  PlayVideo({super.key, required this.data, required this.name});

  late var data, name;
  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late final PodPlayerController controller;
  late VideoPlayerController _videoController;

  bool _isCached = false;
  @override
  void initState() {
    watchVideo();
    controller = PodPlayerController(
      podPlayerConfig: PodPlayerConfig(forcedVideoFocus: true),
      playVideoFrom: PlayVideoFrom.network(
        widget.data["url"],
      ),
    )..initialise();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FixedCacheVideoPlayer(
              videoUrl: widget.data["url"],
              videoId: widget.name,
            ),
            // PodVideoPlayer(
            //   controller: controller,
            // ),
            Container(
              width: getWidth(context),
              height: getHeight(context) / 2,
              child: ListView.builder(
                itemCount: widget.data["pdf_urls"] is List
                    ? widget.data["pdf_urls"].length
                    : 1,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 1,
                      color: mode
                          ? Colors.white
                          : const Color.fromARGB(255, 11, 85, 145),
                    ))),
                    child: ListTile(
                      onTap: () {
                        controller.pause();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewPdf(
                              pdfUrl: widget.data["pdf_urls"] is List
                                  ? widget.data["pdf_urls"][index]
                                  : widget.data["pdf_urls"]),
                        ));
                      },
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: mode
                            ? nightBar["orange"]
                            : const Color.fromARGB(255, 151, 14, 4),
                      ),
                      title: Text(
                        getDeviceLocale() == "ar"
                            ? "الملف رقم ${index + 1} التابع للفيديو"
                            : "The video's ${index + 1} file",
                        style: TextStyle(),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  controller.pause();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Quize(
                        questions: widget.data["que"],
                        choices: widget.data["choose"],
                        answers: widget.data["ans"]),
                  ));
                },
                child: Text(
                  getDeviceLocale() == "ar"
                      ? "قيّم فهمك"
                      : "Evaluate your understanding",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }

  void watchVideo() async {
    // var id = FirebaseAuth.instance.currentUser?.uid;
    var watchers = await supabase
        .from("curces")
        .select("watchers")
        .eq("name", widget.name);
    List data = watchers[0]["watchers"];
    if (!data.contains(supabase.auth.currentUser!.id)) {
      data.add(supabase.auth.currentUser!.id);
      await supabase
          .from("curces")
          .update({"watchers": data}).eq("name", widget.name);
    }
  }
}
