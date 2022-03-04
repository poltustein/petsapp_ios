import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/HomeResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchVideoScreen extends StatefulWidget {
  SearchVideoScreen({
    Key? key,
  });

  _SearchVideoScreen createState() => new _SearchVideoScreen();
}

class _SearchVideoScreen extends State<SearchVideoScreen> {
  int page = 0;
  String searchTerm = "";
  List<VideoPlayerController> controllers = [];
  HomeResponse searchResponse = new HomeResponse(count: 0);
  bool isLoaded = false;
  List<bool> favourites = [];
  var scrollController = ScrollController();
  final searchController = TextEditingController();

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
      setState(() {
        isLoaded = true;
      });
    });

    super.initState();
  }

  Future<HomeResponse> getSearchVideos(
      int pageSize, int pageIndex, String searchTerm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await WebService().getSearchVideos(
        prefs.getString("emailid")!,
        prefs.getString("token")!,
        pageSize,
        pageIndex,
        searchTerm);
    return response;
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in controllers) controller.dispose();
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          color: const Color(0xff191919),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextFormField(
                              controller: searchController,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      final newResponse = await getSearchVideos(
                                          4, 0, searchController.text);
                                      if (newResponse != null &&
                                          newResponse.videos != null &&
                                          newResponse.videos!.isNotEmpty) {
                                        setState(() {
                                          page = 0;
                                          searchTerm = searchController.text;
                                          searchResponse = newResponse;
                                          updateFavouritesAndVideos(
                                              searchResponse);
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Could not find any videos for your search!!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM);
                                      }
                                    },
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Search videos by Title",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.4))),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      (searchResponse!.videos == null ||
                              searchResponse!.videos!.isEmpty)
                          ? Container(
                              margin: EdgeInsets.only(top: 80),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No videos found",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : (searchResponse!.isVisible != null &&
                                  searchResponse!.isVisible == true)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: searchResponse!.videos!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildVideoCard(
                                        searchResponse!.videos![index],
                                        index,
                                        context);
                                  })
                              : Container(
                                  margin: EdgeInsets.only(top: 80),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "You are currently \n not subscribed",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                        ),
                                        Icon(
                                          Icons.search,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                )
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
                  key: Key("Unique Key search_" + index.toString()),
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

  updateFavouritesAndVideos(HomeResponse newResponse) {
    if (newResponse != null &&
        newResponse!.videos != null &&
        newResponse!.videos!.isNotEmpty) {
      for (Videos video in newResponse!.videos!) {
        if (video!.isLiked != null && video!.isLiked!)
          favourites.add(true);
        else
          favourites.add(false);
        VideoPlayerController videoController =
            VideoPlayerController.network(video!.url!);
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
    print("videos length=" + searchResponse!.videos!.length.toString());
    print("count=" + searchResponse!.count.toString());
    print("page=" + page.toString());
    if ((scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) &&
        (searchResponse!.videos!.length < searchResponse!.count!)) {
      HomeResponse newResponse =
          await getSearchVideos(4, (page + 1) * 4, searchTerm);
      print("pagination response= " + newResponse.toJson().toString());
      setState(() {
        page += 1;
        if (newResponse != null &&
            newResponse!.videos != null &&
            newResponse!.videos!.isNotEmpty) {
          searchResponse!.videos!.addAll(newResponse!.videos!);
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
