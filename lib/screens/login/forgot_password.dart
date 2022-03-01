import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/login/change_password.dart';
import 'package:pwd_app/screens/signup/signup_screen.dart';
import 'package:pwd_app/webservice/Token.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPassword createState() => _ForgotPassword();
}


class _ForgotPassword extends State<ForgotPassword> {


  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Material(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  'assets/Protection Dogs Worldwide-90.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please enter your registered emailid",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white.withOpacity(0.4)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 32),
                  // ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (emailController.text.isNotEmpty) {

                          final networkResponse = await WebService().forgotPassword(emailController.text, Token.preLoginToken);
                          if (networkResponse.status == "SUCCESS") {
                            final prefs = await SharedPreferences.getInstance();
                            log("forgot password otp sent");
                            Get.to(()=>ChangePassword(emailId: emailController.text),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                          }
                          Fluttertoast.showToast(msg: networkResponse.reason!,
                              toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                      },
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Text(
                        "Send OTP",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                      ),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                  //   child: MaterialButton(
                  //     height: 60,
                  //     minWidth: double.infinity,
                  //     onPressed: () {},
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(32)),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.add_to_home_screen_outlined),
                  //         Text(
                  //           "Sign In with Google",
                  //           style: TextStyle(
                  //               fontSize: 18, fontWeight: FontWeight.bold),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Container(
                    transform:  Matrix4.translationValues(5.0, -30.0, 0.0),
                    margin: EdgeInsets.only(top:10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(SignupScreen());
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.yellow[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
