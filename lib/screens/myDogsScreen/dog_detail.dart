// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image/network.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/MyDogsResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/planScreen/planInfo_screen.dart';

class DogDetail extends StatefulWidget {

  final Dogs dog;

  DogDetail({Key? key, required this.dog});

  _DogDetail createState() => _DogDetail();

}

class _DogDetail extends State<DogDetail>{

  buildDogGalleryImage(String imageUrl){
    return Flexible(flex: 2,child: Container(margin: EdgeInsets.all(8.0),child: new Image(image:new NetworkImageWithRetry(imageUrl))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
          color: Colors.black,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  Row(
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
                          "Dog Detail",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  child: new Image(image:new NetworkImageWithRetry(widget.dog!.dogImages![0]),height: 300.0,fit: BoxFit.fill),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(widget.dog!.dogName!,maxLines: 4,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.yellow[700],fontSize: 15.0,fontWeight: FontWeight.bold),)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.dog!.gender!,style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("|",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("DOB: "+widget.dog!.dob!,style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("|",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Weight: "+widget.dog!.weight!,style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: widget.dog!.isVetChecked!?Icon(Icons.check,color: Colors.yellow[700],size: 12.0):Icon(
                        Icons.clear,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:2.0,right: 8.0,top:8.0,bottom:8.0),
                      child: Text("Vet Checked",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: widget.dog!.isPedigree!?Icon(Icons.check,color: Colors.yellow[700],size: 12.0):Icon(
                        Icons.clear,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:2.0,right: 8.0,top:8.0,bottom:8.0),
                      child: Text("Pedigree",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: widget.dog!.isPassport!?Icon(Icons.check,color: Colors.yellow[700],size: 12.0):Icon(
                        Icons.clear,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:2.0,right: 8.0,top:8.0,bottom:8.0),
                      child: Text("Passport",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: widget.dog!.isVaccinated!?Icon(Icons.check,color: Colors.yellow[700],size: 12.0):Icon(
                        Icons.clear,
                        color: Colors.yellow[700],
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:2.0,right: 8.0,top:8.0,bottom:8.0),
                      child: Text("Vaccinated",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 12.0,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.dog!.trainingNotes!, style: TextStyle(color: Colors.yellow[700], fontSize: 12.0),),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Gallery",style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold),),
                  ),
                ),



                (widget.dog!=null && widget.dog!.dogImages!=null && widget.dog!.dogImages!.isNotEmpty)?
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.dog!.dogImages!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return index%3==0?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDogGalleryImage(widget.dog!.dogImages![index]),
                        (index+1<widget.dog!.dogImages!.length)?buildDogGalleryImage(widget.dog!.dogImages![index+1]):Container(),
                        (index+2<widget.dog!.dogImages!.length)?buildDogGalleryImage(widget.dog!.dogImages![index+2]):Container(),
                      ],
                    ):Container();

                  },
                ): Container(
                    margin: EdgeInsets.only(top: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No images were added by you!!", style: TextStyle(color: Colors.white.withOpacity(0.5)),),

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
          ),)
    );
  }
}
