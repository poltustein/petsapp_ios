// ignore_for_file: prefer_const_constructors

import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/HomeResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/planScreen/plan_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwd_app/models/CategoriesResponse.dart' as c;
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CategoryVideoScreen extends StatefulWidget {
  final c.Categories category;

  CategoryVideoScreen({Key? key, required this.category});

  _CategoryVideoScreen createState() => new _CategoryVideoScreen();
}

class _CategoryVideoScreen extends State<CategoryVideoScreen> {
  int page = 0;
  List<VideoPlayerController> controllers = [];
  HomeResponse categoryResponse = new HomeResponse(count: 0);
  bool isLoaded = false;
  List<bool> favourites = [];
  var scrollController = ScrollController();

  updateFavouritesAndVideos(HomeResponse newResponse) {
    print("inside");
    if (newResponse != null &&
        newResponse!.videos != null &&
        newResponse!.videos!.isNotEmpty) {
      for (Videos video in newResponse!.videos!) {
        if (video!.isLiked != null && video!.isLiked!)
          favourites.add(true);
        else
          favourites.add(false);
        print("done half");
        VideoPlayerController videoController =
            VideoPlayerController.network(video!.url!);
        controllers.add(videoController);
        videoController
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((value) => videoController.pause());
        print("done here update");
      }
    }
  }

  Future<HomeResponse> getCategoryVideos(int pageSize, int pageIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await WebService().getCategoryVideos(prefs.getString('emailid')!,
        prefs.getString('token')!, pageSize, pageIndex, widget.category!.sId!);
  }

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
      categoryResponse = await getCategoryVideos(4, page);
      print("response=" + categoryResponse.toJson().toString());
      if (categoryResponse != null &&
          categoryResponse!.videos != null &&
          categoryResponse!.videos!.isNotEmpty) {
        updateFavouritesAndVideos(categoryResponse);
        setState(() {
          isLoaded = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispose called");
    for (VideoPlayerController controller in controllers) {
      controller.pause();
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return isLoaded == true
        ? SafeArea(
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
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.category!.categoryName!,
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
                          widget.category!.categoryName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      categoryResponse!.isVisible == false
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 175,
                                            child: Image.asset(
                                              'assets/Protection Dogs Worldwide-203.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                categoryResponse!
                                                    .videos![0].title!,
                                                style: TextStyle(
                                                    color: Colors.yellow[700],
                                                    fontSize: 16),
                                              ),
                                              Icon(
                                                Icons.favorite_border,
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                categoryResponse!.isVisible ==
                                                        false
                                                    ? categoriesText(
                                                        categoryResponse!
                                                            .videos![0]
                                                            .categories!)
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                  DateTime.now()
                                                              .difference(new DateFormat(
                                                                      'MMM dd, yyyy, HH:mm:ss')
                                                                  .parse(categoryResponse!
                                                                      .videos![
                                                                          0]
                                                                      .createdOn!))
                                                              .inDays >
                                                          1
                                                      ? DateTime.now()
                                                              .difference(new DateFormat(
                                                                      'MMM dd, yyyy, HH:mm:ss')
                                                                  .parse(categoryResponse!
                                                                      .videos![
                                                                          0]
                                                                      .createdOn!))
                                                              .inDays
                                                              .toString() +
                                                          " Days ago"
                                                      : "Today",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      fontSize: 12))
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                    height: 225,
                                    width: double.infinity,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(padding: EdgeInsets.all(16)),
                                          Row(
                                            children: [
                                              Card(
                                                color: Colors.yellow[700],
                                                shape: CircleBorder(),
                                                child: SizedBox(
                                                  width: 48,
                                                  height: 48,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Image.asset(
                                                        'assets/151627323516313445444151-128.png'),
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    "Subscribe to an insight \nand educational platform",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            "Protection Dogs Basic\nStarting at \$4.99/month",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                final SubscriptionPlans
                                                    plansResponse =
                                                    await WebService()
                                                        .subscriptionPlans(
                                                            prefs.getString(
                                                                'emailid')!,
                                                            prefs.getString(
                                                                'token')!);
                                                d.log(plansResponse
                                                    .toJson()
                                                    .toString());
                                                Get.to(PlanScreen(
                                                    plans: plansResponse));
                                              },
                                              color: Colors.yellow[700],
                                              child: Text(
                                                "BUY NOW",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32)),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: categoryResponse!.videos!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return buildVideoCard(
                                    categoryResponse!.videos![index],
                                    index,
                                    context);
                              })
                    ],
                  ),
                )),
          )
        : Container();
  }

  buildVideoCard(Videos video, int index, BuildContext context) {
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
                  key: Key("Unique Key category_" + index.toString()),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction == 0) {
                      controllers[index].pause();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      height: 175,
                      child:
                          OrientationBuilder(builder: (context, orientation) {
                        switch (orientation) {
                          case Orientation.portrait:
                            return Scaffold(
                                resizeToAvoidBottomInset: true,
                                backgroundColor:
                                    Theme.of(context).appBarTheme.color,
                                body: VideoPlayerWidget(
                                  controller: controllers![index],
                                  thumbUrl: video.thumbUrl ?? "",
                                ));

                          case Orientation.landscape:
                            return Scaffold(
                                resizeToAvoidBottomInset: true,
                                backgroundColor:
                                    Theme.of(context).appBarTheme.color,
                                body: VideoPlayerWidget(
                                  controller: controllers![index],
                                  thumbUrl: video.thumbUrl ?? "",
                                ));
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
                          prefs.getString("emailid")!,
                          prefs.getString("token")!,
                          video!.resourceId!,
                          video!.url!);

                      if (response!.status == "SUCCESS") {
                        setState(() {
                          favourites[index] = !favourites[index];
                        });
                      }

                      Fluttertoast.showToast(
                          msg: response.reason!,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    },
                    child: Icon(
                      favourites[index] == true
                          ? Icons.favorite
                          : Icons.favorite_border,
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
                      DateTime.now()
                                  .difference(
                                      new DateFormat('MMM dd, yyyy, HH:mm:ss')
                                          .parse(video!.createdOn!))
                                  .inDays >
                              1
                          ? DateTime.now()
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

  void pagination() async {
    print("called pagination");
    print("videos length=" + categoryResponse!.videos!.length.toString());
    print("count=" + categoryResponse!.count.toString());
    print("page=" + page.toString());
    if ((scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) &&
        (categoryResponse!.videos!.length < categoryResponse!.count)) {
      HomeResponse newResponse = await getCategoryVideos(4, (page + 1) * 4);
      print("pagination response= " + newResponse.toJson().toString());
      setState(() {
        page += 1;
        if (newResponse != null &&
            newResponse!.videos != null &&
            newResponse!.videos!.isNotEmpty) {
          categoryResponse!.videos!.addAll(newResponse!.videos!);
          updateFavouritesAndVideos(newResponse);
        }
      });
    }
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final String thumbUrl;

  const VideoPlayerWidget({
    required this.controller,
    required this.thumbUrl,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
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
        Positioned.fill(
          bottom: 4,
          child: controller.value.isInitialized
              ? SizedBox.shrink()
              : Image.network(
                  thumbUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/Protection Dogs Worldwide-203.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
        buildPlay()
      ]));

  Widget buildIndicator() =>
      VideoProgressIndicator(controller, allowScrubbing: true);

  Widget buildVideo() => buildVideoPlayer();

  Widget buildVideoPlayer() => VideoPlayer(controller);

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.white.withOpacity(0),
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50));
}
