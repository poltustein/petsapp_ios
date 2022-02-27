// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/SavedVideosResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SavedVideoScreen extends StatefulWidget {
  SavedVideoScreen({
    Key? key,
  });

  _SavedVideoScreen createState() => new _SavedVideoScreen();
}

class _SavedVideoScreen extends State<SavedVideoScreen> {

  int page = 0;
  List<VideoPlayerController> controllers = [];
  SavedVideosResponse savedVideosResponse = new SavedVideosResponse();
  bool isLoaded = false;
  List<bool> favourites = [];
  var scrollController = ScrollController();

  String categoriesText(List<Categories> categories) {
    if (categories == null || categories.isEmpty) return "";
    String categoriesNames = "";
    for (Categories category in categories) {
      categoriesNames =
          categoriesNames + category.categoryName.toString() + ",\n";
    }
    categoriesNames = categoriesNames.substring(0, categoriesNames.length - 2);
    return categoriesNames;
  }


  @override
  void initState() {
    scrollController.addListener(pagination);
    Future.delayed(Duration.zero, () async {
      savedVideosResponse = await getSavedVideos(4, page);
      updateFavouritesAndVideos(savedVideosResponse);
      setState(() {
        isLoaded = true;
      });
    });

    super.initState();
  }

  Future<SavedVideosResponse> getSavedVideos(int pageSize, int pageIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await WebService().getSavedVideos(
        prefs.getString("emailid"),
        prefs.getString("token"),
        pageSize,
        pageIndex);
    return response;
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in controllers)
      controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return isLoaded==true? SafeArea(
      child: Material(
          color: Colors.black,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back(result: savedVideosResponse.videos);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Favourites",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Favourites",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                savedVideosResponse!.videos!.isEmpty?Container(
                  margin: EdgeInsets.only(top:80),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No favourite videos",style: TextStyle(fontSize: 25, color: Colors.white.withOpacity(0.5)),),
                        Icon(Icons.favorite, color: Colors.white.withOpacity(0.5),size: 25,)
                      ],
                    ),
                  ),
                ):ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: savedVideosResponse!.videos!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildVideoCard(
                          savedVideosResponse!.videos![index],
                          index,
                          context);
                    })
              ],
            ),
          )),
    ):Container();
  }

  buildVideoCard(SavedVideo video, int index, BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(top: 15.0, left: 8.0, bottom: 8.0, right: 8.0),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: VisibilityDetector(
                  key: Key("Unique Key saved_"+index.toString()),
                  onVisibilityChanged: (VisibilityInfo info){
                    if(info.visibleFraction==0){
                      controllers[index].pause();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      height: 175,
                      child: OrientationBuilder(builder: (context, orientation) {
                        switch (orientation) {
                          case Orientation.portrait:
                            return Scaffold(
                                resizeToAvoidBottomInset: true,
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .appBarTheme
                                    .color,
                                body: VideoPlayerWidget(
                                    controller: controllers![index]));

                          case Orientation.landscape:
                            return Scaffold(
                                resizeToAvoidBottomInset: true,
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .appBarTheme
                                    .color,
                                body: VideoPlayerWidget(
                                    controller: controllers![index]));
                        }
                      }),
                    ),
                  ),
                ),
              )),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    video!.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.yellow[700], fontSize: 16),
                  ),
                  InkWell(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final response = await WebService().saveVideoRequest(
                          prefs.getString("emailid"),
                          prefs.getString("token"),
                          video!.videoId!,
                          video!.videoUrl!);

                      if(response!.status=="SUCCESS"){
                        setState(() {
                          favourites.removeAt(index);
                          savedVideosResponse!.videos!.removeAt(index);
                        });

                      }
                      Toast.show(response.reason!, context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    },
                    child: Icon(
                      favourites[index]==true?Icons.favorite:Icons.favorite_border,
                      color: Colors.yellow[700],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoriesText(video!.categories!),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                  Text(
                      DateTime
                          .now()
                          .difference(
                          new DateFormat('MMM dd, yyyy, HH:mm:ss')
                              .parse(video!.createdOn!))
                          .inDays >
                          1
                          ? DateTime
                          .now()
                          .difference(
                          new DateFormat('MMM dd, yyyy, HH:mm:ss')
                              .parse(video!.createdOn!))
                          .inDays
                          .toString() +
                          " Days ago"
                          : "Today",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4), fontSize: 12))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  updateFavouritesAndVideos(SavedVideosResponse newResponse){
    if (newResponse != null &&
        newResponse!.videos != null &&
        newResponse!.videos!.isNotEmpty) {
      for (SavedVideo video in newResponse!.videos!) {
          favourites.add(true);
        VideoPlayerController videoController =
        VideoPlayerController.network(video!.videoUrl!);
        controllers.add(videoController);
        videoController
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((value) => videoController.pause());
      }
    }
  }

  void pagination() async {
    print("called pagination");
    print("videos length="+savedVideosResponse!.videos!.length.toString());
    print("count="+savedVideosResponse!.count.toString());
    print("page="+page.toString());
    if ((scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) && (savedVideosResponse!.videos!.length < savedVideosResponse!.count!)) {
      SavedVideosResponse newResponse = await getSavedVideos(4, (page+1)*4);
      print("pagination response= "+newResponse.toJson().toString());
      setState(() {
        page += 1;
        if(newResponse!=null && newResponse!.videos!=null && newResponse!.videos!.isNotEmpty) {
          savedVideosResponse!.videos!.addAll(newResponse!.videos!);
          updateFavouritesAndVideos(newResponse);
        }
      });
    }
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
          {controller.value.isPlaying ? controller.pause() : controller.play()},
          child: Stack(children: [
            Container(child: buildVideo(), color: Colors.black),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0),
              child: IconButton(
                icon: Icon(
                  controller.value.volume == 0
                      ? Icons.volume_mute
                      : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: () =>
                    controller.setVolume(controller.value.volume == 0 ? 1 : 0),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
            buildPlay()
          ]));

  Widget buildIndicator() =>
      VideoProgressIndicator(controller, allowScrubbing: true);

  Widget buildVideo() => buildVideoPlayer();

  Widget buildVideoPlayer() => VideoPlayer(controller);

  Widget buildPlay() =>
      controller.value.isPlaying
          ? Container()
          : Container(
          alignment: Alignment.center,
          color: Colors.white.withOpacity(0),
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50));
}

