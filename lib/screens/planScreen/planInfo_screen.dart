// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/planScreen/payment_screen.dart';


class PlanInfoScreen extends StatefulWidget {

  final Plans plan;
  final List<bool> selections;
  final String subscriptionPlanId;

  PlanInfoScreen({Key? key, required this.plan, required this.selections, required this.subscriptionPlanId});

  _PlanInfoScreen createState() => new _PlanInfoScreen();
}

class _PlanInfoScreen extends State<PlanInfoScreen>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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


              Padding(
                padding: const EdgeInsets.only(left: 8.0,top:8.0),
                child: Text(widget.plan!.planName!, style: TextStyle(fontSize: 25.0,color: Colors.white,fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
                child: Text("Subscription Plan", style: TextStyle(fontSize: 25.0,color: Colors.white,fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("to Protection Dogs Worldwide", style: TextStyle(fontSize: 15.0,  color: Colors.grey),),
              ),
              Container(
                height: 250.0,
                width: double.infinity,
                margin: EdgeInsets.all(3.0),
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Wrap(
                      direction: Axis.horizontal,
                    children: <Widget>[
                      Stack(
                          children: [
                            Image.asset("assets/plan_screen_image.jpg",fit: BoxFit.cover),
                            //Positioned.fill(child: Container(color: Colors.pink.withOpacity(0.5))),
                            Container(
                                margin: EdgeInsets.only(top:97.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                      margin: EdgeInsets.only(left:10.0),
                                      shape: CircleBorder(),
                                      color: Colors.yellow[700],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.star_rounded,size:56,color:Colors.black),
                                      )
                                  ),
                                )
                            )
                          ]),
                    ]
                  ),
                ),
              ),

              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index){
                    return Container(
                      margin: const EdgeInsets.only(left:35.0,top:15.0,bottom:15.0,),
                      child: InkWell(
                        onTap: (){
                          setState((){
                            widget.selections[index] = true;
                            for(int i=0;i<widget.selections.length;i++){
                              if(i!=index)
                              widget.selections[i] = false;
                            }
                            log("tapped");
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:10.0, right: 20.0),
                          decoration: widget.selections[index]? BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                              ),
                            borderRadius: BorderRadius.circular(16)
                          ): BoxDecoration(),
                          child: Row(
                            children: [
                              Flexible(flex: 1 ,child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.selections[index]?Icon(Icons.check_circle,size:35,color:Colors.yellow):Icon(Icons.circle_outlined,size:35,color:Colors.yellow),
                              )),
                              Flexible(flex: 4, child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.plan.planCosts![index]!.planCost!, style: TextStyle(fontSize: 25.0,color: Colors.white,fontWeight: FontWeight.bold),),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                itemCount: widget.plan!.planCosts!.length,
              ),

              Padding(
                padding: const EdgeInsets.only(top:6.0,left:16.0,bottom:16.0,right:16.0),
                child: Container(
                  margin: EdgeInsets.all(15.0),
                    child: MaterialButton(onPressed: (){
                      int selectedPlanIndex = -1;
                      for(int i=0;i<widget.selections.length;i++)
                      {
                        if (widget.selections[i]){
                          selectedPlanIndex = i;
                          print("selected index= "+selectedPlanIndex.toString());
                          break;
                        }
                      };
                      if(selectedPlanIndex>=0) {
                        Get.to(PaymentScreen(plan: widget.plan!, selectedIndex: selectedPlanIndex, subscriptionPlanId: widget.subscriptionPlanId,));
                      }
                    }, child: Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),), minWidth: double.infinity, color: Colors.yellow[700], height: 60, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),)),
              )
            ],
          ),
        )
      ),
    );
  }
}
