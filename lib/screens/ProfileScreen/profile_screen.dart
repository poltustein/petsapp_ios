import 'dart:developer';
import 'dart:io' as i;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_image/network.dart';
import 'package:pwd_app/models/login/login.dart';
import 'package:pwd_app/screens/landingScreen/components/home_screen.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/verifyotp/verify_otp_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final picker = ImagePicker();
  bool imageIsSet = false;

  Future getImageFromSource(ImageSource source) async {
    final pickedImages;
    final cameraImage;

    if (source == ImageSource.gallery) {
      pickedImages =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 10);
      setState(() {
        if (pickedImages != null) {
          profileImageAssetPath = pickedImages!.path;
          pickedFile = pickedImages;
          imageIsSet = true;
        } else
          imageIsSet = false;
      });
    } else {
      cameraImage = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (cameraImage != null) {
          profileImageAssetPath = cameraImage!.path;
          pickedFile = cameraImage;
          imageIsSet = true;
        } else
          imageIsSet = false;
      });
    }

    log("Image selected");
    Navigator.pop(context);
  }

  Future<String> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key) ?? "";
  }

  String name = "";
  String contact = "";
  String token = "";
  String emailid = "";
  String profileImageUrl = "";
  String profileImageAssetPath = "";
  PickedFile pickedFile = new PickedFile("");

  void initState() {
    read('name').then((value) => setState(() {
          name = value;
        }));

    read('token').then((value) => setState(() {
          token = value;
        }));

    read('emailid').then((value) => setState(() {
          emailid = value;
        }));

    read('contact').then((value) => setState(() {
          contact = value.trim()=="No Contact"?"":value;
        }));

    read('profileImageUrl').then((value) => setState(() {
          profileImageUrl = value;
        }));
    print(Get.currentRoute);
    super.initState();
  }

  final emailTE = TextEditingController();
  final phoneTE = TextEditingController();
  final nameTE = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final ProgressDialog pr = ProgressDialog(context);

    emailTE.text = emailid;
    phoneTE.text = contact;
    nameTE.text = name;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Material(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
            ),

            Positioned(
              top: -15.0,
              left: 5.0,
              child: InkWell(
                onTap: () {
                  //Get.off(()=>LandingScreen(),transition: Transition.leftToRight,duration: const Duration(milliseconds: 800));
                  Get.back();
                  log(Get.currentRoute);
                },
                child: !Get.currentRoute.endsWith("/LandingScreen")
                    ? Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 45.0, left: 8.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ),

            // FractionallySizedBox(
            //     heightFactor: 1,
            //     child: Image.asset(
            //       'assets/Protection Dogs Worldwide-90.jpg',
            //       fit: BoxFit.cover,
            //     )),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(152),
                      child: (profileImageUrl.trim() == "" ||
                              profileImageUrl == null ||
                              imageIsSet)
                          ? (profileImageAssetPath.trim().isEmpty
                              ? Image.asset(
                                  'assets/10935330651582806320-128.png',
                                  fit: BoxFit.cover,
                                  height: 152,
                                  width: 152,
                                  color: Colors.grey)
                              : Image.file(i.File(profileImageAssetPath),
                                  fit: BoxFit.cover, height: 152, width: 152))
                          : new Image(
                              image: NetworkImageWithRetry(profileImageUrl),
                              fit: BoxFit.cover,
                              height: 152,
                              width: 152,
                            ),
                    ),
                  ),
                  Positioned.fill(
                      top: 152,
                      left: 90,
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  new AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text('Pick an Image source'),
                                    content: Text('Pick an Image source'),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          await getImageFromSource(
                                              ImageSource.camera);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  child: Icon(
                                                    Icons.camera_alt_rounded,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  )),
                                              Spacer(flex: 1),
                                              Flexible(
                                                  flex: 2,
                                                  child: Text("Camera",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.5)))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await getImageFromSource(
                                              ImageSource.gallery);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  child: Icon(
                                                    Icons.folder,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  )),
                                              Spacer(flex: 1),
                                              Flexible(
                                                  flex: 2,
                                                  child: Text("Gallery",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.5)))),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt_rounded,
                              size: 35, color: Colors.white),
                        ),
                      )),
                ]),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: const Color(0xff191919),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        controller: nameTE,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'name',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4))),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: const Color(0xff191919),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        controller: emailTE,
                        enabled: false,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: emailid,
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4))),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: const Color(0xff191919),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneTE,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contact",
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4))),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                    height: 60,
                    minWidth: double.infinity,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (nameTE.text.isNotEmpty && phoneTE.text.isNotEmpty) {
                        // pr.style(
                        //     message: 'Updating profile.. Please wait',
                        //     borderRadius: 10.0,
                        //     backgroundColor: Colors.black,
                        //     progressWidget: CircularProgressIndicator(),
                        //     elevation: 10.0,
                        //     insetAnimCurve: Curves.easeInOut,
                        //     progress: 0.0,
                        //     maxProgress: 100.0,
                        //     progressTextStyle: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 13.0,
                        //         fontWeight: FontWeight.w400),
                        //     messageTextStyle: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 19.0,
                        //         fontWeight: FontWeight.w600));

                        //await pr.show();
                        final networkResponse = await WebService().updateUser(
                            nameTE.text, emailTE.text, phoneTE.text, token);
                        if (networkResponse.status == "SUCCESS") {
                          final prefs = await SharedPreferences.getInstance();
                          if (pickedFile != null && imageIsSet){
                            final imageResponse = await WebService()
                                .addProfileImage(
                                emailTE.text, token, pickedFile);
                            if(imageResponse!=null)
                              prefs.setString('profileImageUrl', imageResponse.url!);
                          }
                          prefs.setString('name', nameTE.text);
                          prefs.setString('contact', phoneTE.text);

                          if(profileImageAssetPath!=null && profileImageAssetPath.trim().isNotEmpty){
                            prefs.setString(
                                'profileImage', profileImageAssetPath);
                          }

                          prefs.commit();
                          log('pressed update!!');
                          Get.back();
                        }
                        //pr.hide();
                        Fluttertoast.showToast(msg: networkResponse.reason!,
                            toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      } else {

                        Fluttertoast.showToast(msg: "Please fill in the details",
                            toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      }
                      log("out of update");
                    },
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Text(
                      "Update",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
