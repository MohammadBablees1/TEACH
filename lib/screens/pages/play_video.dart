import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/quize.dart';
import 'package:teach/screens/pages/view_pdf.dart';
import 'package:teach/widgets/vedio_cached_manager_widget.dart';

class PlayVideo extends StatefulWidget {
  PlayVideo({super.key, required this.data, required this.name});

  late var data, name;
  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late final PodPlayerController controller;
  late VideoPlayerController _videoController;


  @override
  void initState() {
    watchVideo();
    if (widget.data["url"].isNotEmpty) {
      controller = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(forcedVideoFocus: true),
        playVideoFrom: PlayVideoFrom.network(
          widget.data["url"],
        ),
      )..initialise();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.data["url"].isNotEmpty) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          width: getWidth(context),
          height: getHeight(context),
          child: Column(
            mainAxisAlignment:
                widget.data["url"].isNotEmpty && widget.data["pdf_urls"].isEmpty
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              widget.data["url"].isEmpty
                  ? Container()
                  : CachedVideoPlayer(
                      videoUrl: widget.data["url"],
                      showCacheButton: true,
                      // videoId: widget.name,
                    ),
              // PodVideoPlayer(
              //   controller: controller,
              // ),
              widget.data["url"].isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: getWidth(context),
                        height: getWidth(context) * .3,
                        child: Center(
                          child: SizedBox(
                            width: getWidth(context) * .2,
                            height: getWidth(context) * .2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/white_icon.jpg",
                                width: getWidth(context) * .2,
                                height: getWidth(context) * .2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: getWidth(context),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.data["pdf_urls"] is List
                      ? widget.data["pdf_urls"].length
                      : 1,
                  itemBuilder: (context, index) {
                    return Card(
                      color: mode
                          ? nightBar["orange"]
                          : const Color.fromARGB(255, 11, 85, 145),
                      child: ListTile(
                        onTap: () {
                          if (widget.data["url"].isNotEmpty) {
                            controller.pause();
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewPdf(
                                pdfUrl: widget.data["pdf_urls"] is List
                                    ? widget.data["pdf_urls"][index]
                                    : widget.data["pdf_urls"]),
                          ));
                        },
                        leading: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                        ),
                        title: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "الملف رقم ${index + 1}"
                              : " file ${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              widget.data["que"].isEmpty
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        if (widget.data["url"].isNotEmpty) {
                          controller.pause();
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Quize(
                              questions: widget.data["que"],
                              choices: widget.data["choose"],
                              answers: widget.data["ans"]),
                        ));
                      },
                      child: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
                        getDeviceLocale() == "ar"
                            ? "قيّم فهمك"
                            : "Evaluate your understanding",
                        style: TextStyle(color: Colors.white),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void watchVideo() async {
    // var id = FirebaseAuth.instance.currentUser?.uid;
    if (await checkConnection()) {
      var watchers = await supabase
          .from("curces")
          .select()
          .eq("name", widget.name)
          .eq("folder_id", widget.data["folder_id"]);
      List data = watchers[0]["watchers"];

      if (!data.contains(supabase.auth.currentUser!.id)) {
        data.add(supabase.auth.currentUser!.id);
        await supabase
            .from("curces")
            .update({"watchers": data})
            .eq("name", widget.name)
            .eq("folder_id", widget.data["folder_id"]);
      }
    }
  }
}
