import 'dart:async';
import 'dart:developer';
import 'dart:io' as i;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image/network.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pwd_app/models/MyDogsResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/ProfileScreen/profile_screen.dart';
import 'package:pwd_app/screens/addDogScreen/addDog_screen.dart';
import 'package:pwd_app/screens/categories/categoriesList.dart';
import 'package:pwd_app/screens/landingScreen/components/home_screen.dart';
import 'package:pwd_app/screens/login/login_screen.dart';
import 'package:pwd_app/screens/myDogsScreen/myDogs_screen.dart';
import 'package:pwd_app/screens/planScreen/plan_screen.dart';
import 'package:pwd_app/screens/savedVideos/saved_videos_screen.dart';
import 'package:pwd_app/screens/searchScreen/search_screen.dart';
import 'package:pwd_app/screens/supportScreen/support_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  final currentIndex;
  const LandingScreen({Key? key, required this.currentIndex});



  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  var _currentIndex = 0;

  var tabs = [
    HomeScreen(),
    CategoriesList(),
    SearchVideoScreen(),
    AddDogScreen(),
    ProfileScreen(),
    SupportScreen(),
  ];

  Future<String> read (String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key) ?? "";
  }

  String name = "";
  String contact = "";
  String profileImageUrl = "";
  String profileImagePath = "";

  void initState(){
    _currentIndex = widget.currentIndex;
    read('name').then((value) => setState((){
      name = value;
    }));

    read('contact').then((value) => setState((){
      contact = value;
    }));

    read('profileImageUrl').then((value) => setState((){
      profileImageUrl = value;
    }));

    read('profileImage').then((value) => setState((){
      profileImagePath = value;
    }));



    super.initState();
  }

  @override
  void dispose() {
    print("close");
    super.dispose();
  }

  getHomeResponse() async{



  }


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        onDrawerChanged: (isOpened) {
          if(isOpened){
            setState(() {

              read('name').then((value) => setState((){
                name = value;
              }));

              read('contact').then((value) => setState((){
                contact = value;
              }));

              read('profileImageUrl').then((value) => setState((){
                profileImageUrl = value;
              }));

              read('profileImage').then((value) => setState((){
                profileImagePath = value;
              }));

            });
          }
          else{
            print("yup its closed "+Get.currentRoute);
            print(_currentIndex);
            if(_currentIndex==0){
              Navigator.pop(context);
              Get.offAll(()=>LandingScreen(currentIndex:0));
            }
            else if(_currentIndex==2){
              Navigator.pop(context);
              Get.offAll(()=>LandingScreen(currentIndex:2));
            }

          }
        },
        body:tabs[_currentIndex],
        backgroundColor: Colors.black,
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4), fontSize: 16),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(72),
                    child: (profileImageUrl.trim()=="" || profileImageUrl==null)? (profileImagePath.trim().isEmpty?Image.asset(
                        'assets/10935330651582806320-128.png',
                        fit: BoxFit.contain, height: 120, width: 120,color: Colors.grey):Image.file(i.File(profileImagePath),fit: BoxFit.cover, height: 152, width: 152)):
                    new Image(image:new NetworkImageWithRetry(profileImageUrl),fit: BoxFit.cover, height: 152, width: 152,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 4),
                  child: Text("Welcome", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),),
                ),
                Text(name, style: TextStyle(color: Colors.white, fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(contact, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                ),
                Padding(padding: EdgeInsets.all(48)),
                InkWell(
                  onTap: (){
                    Get.to(ProfileScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle_outlined, color: Colors.white.withOpacity(0.4),),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("Profile", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    final prefs = await SharedPreferences.getInstance();
                    final MyDogsResponse response = await WebService().mydogs(prefs.getString('emailid')!,4,0,prefs.getString('token')!);
                    log("response="+response.toJson().toString());
                    Get.to(MyDogsScreen(myDogsResponse: response),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Image.asset('assets/126333676916257259133595.png', color: Colors.white.withOpacity(0.4), height: 24, width: 24,),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("My Dogs", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: InkWell (
                    onTap: () {
                      Get.to(SavedVideoScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.white.withOpacity(0.4),),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text("Favourites", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    final prefs = await SharedPreferences.getInstance();
                    final SubscriptionPlans plansResponse = await WebService().subscriptionPlans(prefs.getString('emailid')!,prefs.getString('token')!);
                    log(plansResponse.toJson().toString());
                    Get.to(PlanScreen(plans: plansResponse),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.tv, color: Colors.white.withOpacity(0.4),),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("Membership", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(SupportScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.headphones, color: Colors.white.withOpacity(0.4),),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("Support", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 1,),
                InkWell(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    prefs.commit();
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.signOut();
                    Get.off(()=>LoginScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white.withOpacity(0.4),),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("Logout", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              read('name').then((value) => setState((){
                name = value;
              }));

              read('contact').then((value) => setState((){
                contact = value;
              }));

            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff191919),
          selectedItemColor: Colors.yellow[700],
          unselectedItemColor: Colors.white.withOpacity(0.4),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard), label: "Add Dog"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: "Account"),

          ],
        ),
      ),
    );
  }
}
