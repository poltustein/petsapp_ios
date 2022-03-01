// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/planScreen/planInfo_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanScreen extends StatefulWidget {

  final SubscriptionPlans plans;
   int selectedPlanIndex = -1;

  PlanScreen({Key? key, required this.plans});

  _PlanScreen createState() => _PlanScreen();

}

class _PlanScreen extends State<PlanScreen>{

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
                        "Choose a plan",
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
                child: Text("Choose Your Plan", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Best Plans For You", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),),
              ),

              Stack(
                alignment : AlignmentDirectional.topStart,
                overflow: Overflow.visible,
                children: [
                  ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      setState((){
                        widget.selectedPlanIndex = index;
                      });

                    },
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                        decoration: widget.selectedPlanIndex == index ? BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16)
                        ): BoxDecoration(),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Color(0xff191919),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                               children: [
                                 Spacer(),
                                 Container(

                                  child: Padding(
                                    padding: const EdgeInsets.only(top:15.0),
                                    child: Container(
                                      transform: widget.plans!.plans![index].isActive!?Matrix4.translationValues(5.0, -10.0, 0.0):Matrix4.translationValues(5.0, -10.0, 0.0),
                                      child: Card(
                                        color: widget.plans!.plans![index].isActive!?Colors.lightGreenAccent:Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            children: [
                                              Container(child: widget.plans!.plans![index].isActive!?Icon(Icons.check, size: 15.0):null),
                                              Text(widget.plans!.plans![index].isActive!?"Activated":widget.plans!.plans![index].planDiscount!, style: const TextStyle(fontSize: 15.0))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            ),


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0, top: 24),
                                        child: Card(
                                          margin: EdgeInsets.only(left:10.0),
                                          shape: CircleBorder(),
                                          color: Colors.yellow[700],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: widget.plans!.plans![index].planUrl!="" ?Image.network(widget.plans!.plans![index].planUrl!, height: 56.0,width: 56.0,):Icon(Icons.star_outline_rounded,size:56),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 35.0,top:5.0),
                                        child: Text(widget.plans!=null?(widget.plans.plans!=null?(widget.plans.plans?[index]?.planName ?? " "):" "):" ", style: TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 50, top: 16),
                                    child: Container(
                                      width: 2,
                                      height: 125,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 36.0, left: 50),
                                    child: Container(
                                      height: 115.0,
                                      width: 350.0,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.0),
                                            child: Row(
                                              children: [
                                                Text(widget.plans!=null?(widget.plans.plans!=null?(widget.plans.plans?[index]?.planCostString?.split(" ")[0] ?? " "):" "):" ", style: TextStyle(color: Colors.yellow[700], fontSize: 32),),
                                                Text(widget.plans!=null?(widget.plans.plans!=null?(widget.plans.plans?[index]?.planCostString?.split(" ")[1] ?? " "):" "):" ", style: TextStyle(color: Colors.white, fontSize: 32),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 00.0),
                                              child: Text(widget.plans!=null?(widget.plans.plans!=null?(widget.plans.plans?[index]?.planCostString?.split(" ")[2] ?? " "):" "):" ", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),)
                                          ),
                                         Container(
                                           margin: EdgeInsets.only(left: 5.0),
                                           child: ListView.builder(
                                             physics: ScrollPhysics(),
                                             shrinkWrap: true,
                                             itemBuilder: (context,counter){
                                             return Row(
                                               children: [
                                                 Flexible(flex: 2,child: Icon(Icons.check, color: Colors.white, size: 12)),
                                                 Flexible(flex: 8,child: Text(widget.plans!.plans![index].planDescriptions![counter], style: TextStyle(color: Colors.white, fontSize: 10))),
                                               ],
                                                  );},
                                             itemCount: widget.plans!.plans![index]!.planDescriptions!.length,
                                           ),
                                         )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left:5.0,top:10.0,bottom: 16.0, right:16.0),
                              child:widget.plans!.plans![index].isActive!? MaterialButton(
                                onPressed: () async{
                                  final prefs = await SharedPreferences.getInstance();
                                  if(prefs.getBool('isSubscribed')==null || prefs.getBool('isSubscribed')!){
                                   final response =  await WebService().unsubscribe(prefs.getString('emailid')!, prefs.getString('token')!);
                                   if(response!=null && response.status=='SUCCESS'){
                                     prefs.setBool('isSubscribed', false);
                                     prefs.commit();
                                     setState(() {
                                       widget.plans!.plans![index].isActive = false;
                                     });

                                   }
                                   if(response!=null && response.reason!=null && response.reason!.isNotEmpty)
                                    Fluttertoast.showToast(msg: response.reason!,
                                       toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                                   else{
                                     Fluttertoast.showToast(msg: "Could not unsubscribe. Please try again later!!",
                                         toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);

                                   }
                                  }

                                }, color: Colors.white, child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: Text("Cancel"),
                              ), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),

                              ):null,
                            )
                          ],
                        ),
                      ),
                    ),
                  );},
                  itemCount: widget.plans.plans!.length,
                ),

                ]
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top:6.0,left:16.0,bottom:16.0,right:16.0),
                  child: MaterialButton(
                    onPressed: (){
                    log("button clicked!!="+ widget.selectedPlanIndex.toString());
                    Get.to(widget.selectedPlanIndex >= 0 ? PlanInfoScreen(plan: widget.plans!.plans![widget.selectedPlanIndex], selections: List.filled(widget.plans!.plans![widget.selectedPlanIndex].planCosts!.length, false), subscriptionPlanId: widget.plans!.plans![widget.selectedPlanIndex].planId!) : widget.plans!.plans!.length<=1?PlanInfoScreen(plan: widget.plans!.plans![0], selections: List.filled(widget.plans!.plans![0].planCosts!.length, false),subscriptionPlanId: widget.plans!.plans![0].planId!): null );
                  }, child: Text("Buy Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),), minWidth: double.infinity, color: Colors.yellow[700], height: 60, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("*No contract no cancellation fee", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),),
              )
            ],

        ),
      ),)
    );
  }
}
