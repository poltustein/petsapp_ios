// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/CategoriesResponse.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/categories/category_video_screen.dart';
import 'package:pwd_app/screens/landingScreen/components/home_screen.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CategoriesList extends StatefulWidget {
  CategoriesList({
    Key? key,
  });

  _CategoriesList createState() => new _CategoriesList();
}

class _CategoriesList extends State<CategoriesList> {

 bool isLoaded = false;
 CategoriesResponse categoriesResponse = new CategoriesResponse();

 @override
 void initState() {
   Future.delayed(Duration.zero, () async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     categoriesResponse = await WebService().getCategories(prefs.getString('emailid'),prefs.getString('token'));
     setState(() {
       isLoaded = true;
     });
   });

   super.initState();
 }

  Widget buildCategoryCard(Categories category){
    return  InkWell(
      onTap: (){
        Get.to(()=>CategoryVideoScreen(category: category!));
      },
      child: Container(
          width: double.infinity,
          decoration:  BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(16)
          ),
          margin: EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(category!.categoryName!, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded==true?SafeArea(
      child: Material(
          color: Colors.black,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(top:35.0,left:15.0,right:15.0,bottom:15.0),
                      child: Text("Choose a Category", style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.white),)
                  ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: categoriesResponse!.categories!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildCategoryCard(categoriesResponse!.categories![index]!);
                  })
                ],
              ),
            ),
          )
      ),
    ):Container();
  }
}
