import 'dart:developer';

import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:pwd_app/models/SubscriptionInit.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/card.dart' as carder;
import 'dart:developer' as logger;
import 'package:toast/toast.dart';

class SupportScreen extends StatefulWidget {

  SupportScreen({Key? key});

  _SupportScreen createState() => new _SupportScreen();
}

class _SupportScreen extends State<SupportScreen>{

  TextEditingController issueController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.black,
          height: double.infinity,
          width: double.infinity,

          child: SingleChildScrollView(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Get.back();
                    //Get.off(()=>LandingScreen(),transition: Transition.leftToRight,duration: const Duration(milliseconds: 800));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0, left: 8.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Text(
                          "Support",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(margin: EdgeInsets.only(bottom: 15.0),height: 35.0,child: Center(child: Text("Support", style: TextStyle(fontSize: 25.0, color: Colors.white)))),
                Container(
                  height: 250.0,
                  margin: EdgeInsets.all(25.0),
                  child: carder.Card(
                    color: const Color(0xff191919),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        maxLines: 10,
                        keyboardType: TextInputType.text,
                        controller: issueController,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Please fill your issues",
                            hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.4))),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                    height: 60,
                    minWidth: double.infinity,
                    onPressed: () async {
                      if(issueController.text.isNotEmpty){
                        final prefs = await SharedPreferences.getInstance();
                        final issueResponse = await WebService().support(prefs.getString('emailid'), issueController.text, prefs.getString('token'));
                          Toast.show(issueResponse.reason, context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                         }
                      else
                        Toast.show("Please fill in your issue!!", context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    },
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
