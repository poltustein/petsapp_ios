import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pwd_app/models/MyDogsResponse.dart';
import 'package:flutter_image/network.dart';
import 'package:pwd_app/screens/myDogsScreen/dog_detail.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDogsScreen extends StatefulWidget {
  MyDogsResponse myDogsResponse;
  MyDogsScreen({Key? key, required this.myDogsResponse});

  @override
  _MyDogsScreen createState() => _MyDogsScreen();
}


class _MyDogsScreen extends State<MyDogsScreen> {
  int page=0;
  var scrollController = ScrollController();

  @override
  void initState()  {
    scrollController.addListener(pagination);
    super.initState();
  }

  buildDog(Dogs dog, BuildContext context){

    return Flexible(
      flex: 1,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                print(MediaQuery.of(context).size.width);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 350,
                    child: Card(
                      color: Color(0xff191919),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(flex: 3,child:new Image(image:new NetworkImageWithRetry(dog!.dogImages![0]),fit: BoxFit.cover)),
                             Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      dog!.dogName!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.yellow[700], fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                dog!.isVetChecked!?Icon(
                                                  Icons.check,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ):Icon(
                                                  Icons.clear,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ),
                                                Text(
                                                  "Vet Checked",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                dog!.isPedigree!?Icon(
                                                  Icons.check,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ):Icon(
                                                  Icons.clear,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ),
                                                Text(
                                                  "Pedigree",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                dog!.isPassport!?Icon(
                                                  Icons.check,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ):Icon(
                                                  Icons.clear,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ),
                                                Text(
                                                  "Passport",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                dog!.isVaccinated!?Icon(
                                                  Icons.check,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ):Icon(
                                                  Icons.clear,
                                                  color: Colors.yellow[700],
                                                  size: 12,
                                                ),
                                                Text(
                                                  "Vaccinated",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Get.to(DogDetail(dog: dog),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                                      },
                                      child: Text("More Info"),
                                      color: Colors.yellow[700],
                                      minWidth: double.infinity,
                                      height: 24,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
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
                        "My Dogs",
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
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  "My Dogs",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "My Dogs List",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 12),
                ),
              ),

              (widget.myDogsResponse!=null && widget.myDogsResponse.dogs!=null && widget.myDogsResponse.dogs!.isNotEmpty)?
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                   physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.myDogsResponse!.dogs!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return index%2==0? (index+1<widget.myDogsResponse!.dogs!.length?
                      (Row(
                        children: [
                          buildDog(widget.myDogsResponse.dogs![index], context),
                          buildDog(widget.myDogsResponse.dogs![index+1], context)
                        ],
                      )):(
                      Row(
                        children: [
                          buildDog(widget.myDogsResponse.dogs![index], context),
                        ],
                      )
                      )
                      ):Container();
                    },
                  ),
              ): Container(
                margin: EdgeInsets.only(top: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Dogs were added by you!!", style: TextStyle(color: Colors.white.withOpacity(0.5)),),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Icon(Icons.extension , color: Colors.white.withOpacity(0.5), size: 45.0,),
                    ),
                  ),
                ],
                )

              ),
            ],
          ),
        ),
      ),
    );
  }

  void pagination() async{
    // log("scrollController.position.pixels="+scrollController.position.pixels.toString());
    // log("scrollController.position.maxScrollExtent"+scrollController.position.maxScrollExtent.toString());
    // log("widget.myDogsResponse!.dogs!.length"+widget.myDogsResponse!.dogs!.length.toString());
    // log("widget.myDogsResponse!.total="+widget.myDogsResponse!.total.toString());
    if ((scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) && (widget.myDogsResponse!.dogs!.length < widget.myDogsResponse!.total)) {
      //log("inside");
      final prefs = await SharedPreferences.getInstance();
      MyDogsResponse newResponse = await WebService().mydogs(prefs.getString('emailid'),4,(page+1)*4,prefs.getString('token'));
      log(newResponse.toJson().toString());
      setState(() {
        page += 1;
        if(newResponse!=null && newResponse!.dogs!=null && newResponse!.dogs!.isNotEmpty) {
          widget.myDogsResponse!.dogs!.addAll(newResponse!.dogs!);
        }
      });
    }
  }
}
