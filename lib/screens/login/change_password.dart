import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/login/login_screen.dart';
import 'package:pwd_app/screens/signup/signup_screen.dart';
import 'package:pwd_app/webservice/Token.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  
   final String emailId;
   ChangePassword({Key? key, required this.emailId});
  

  @override
  _ChangePassword createState() => _ChangePassword();
}


class _ChangePassword extends State<ChangePassword> {

  bool isPasswordShow = false;
  bool isVerifyPasswordShow = false;
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

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
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "We sent an otp to your registered emailid",
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
                            controller: otpController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "OTP",
                                hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),


                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            obscureText: isPasswordShow?false:true,
                            controller: passwordController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: InkWell(
                                      onTap: (){
                                        setState(() {
                                          isPasswordShow = !isPasswordShow;
                                          //passwordController.text = passwordController.text;
                                        });

                                      },
                                      child: isPasswordShow?Icon(
                                        Icons.visibility,
                                        color: Colors.white.withOpacity(0.4),
                                      ):Icon(
                                        Icons.visibility_off,
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    )),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),



                  //
                  // Flexible(
                  //   flex: 1,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Card(
                  //       color: const Color(0xff191919),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(32)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 24),
                  //         child: TextFormField(
                  //           controller: passwordController,
                  //           cursorColor: Colors.white,
                  //           decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText: "Paswword",
                  //               hintStyle:
                  //               TextStyle(color: Colors.white.withOpacity(0.4))),
                  //           style: const TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            obscureText: isVerifyPasswordShow?false:true,
                            controller: verifyPasswordController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: InkWell(
                                      onTap: (){
                                        setState(() {
                                          isVerifyPasswordShow = !isVerifyPasswordShow;
                                          //passwordController.text = passwordController.text;
                                        });

                                      },
                                      child: isVerifyPasswordShow?Icon(
                                        Icons.visibility,
                                        color: Colors.white.withOpacity(0.4),
                                      ):Icon(
                                        Icons.visibility_off,
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                    )),
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Flexible(
                  //   flex: 1,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: Card(
                  //       color: const Color(0xff191919),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(32)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 24),
                  //         child: TextFormField(
                  //           controller: verifyPasswordController,
                  //           cursorColor: Colors.white,
                  //           decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText: "Confirm Password",
                  //               hintStyle:
                  //               TextStyle(color: Colors.white.withOpacity(0.4))),
                  //           style: const TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

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
                        if (otpController.text.isNotEmpty && passwordController.text.isNotEmpty && verifyPasswordController.text.isNotEmpty) {
                          if(passwordController.text == verifyPasswordController.text){
                            final networkResponse = await WebService().changePassword(widget.emailId, passwordController.text, otpController.text , Token.preLoginToken);
                            if (networkResponse.status == "SUCCESS") {
                              log("forgot password otp confirmed");
                              Get.off(()=>LoginScreen(),transition: Transition.rightToLeft,duration: const Duration(milliseconds: 800));
                            }
                            Fluttertoast.showToast(msg: networkResponse.reason!,
                                toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);

                          }
                          else{
                            Fluttertoast.showToast(msg: "Password fields do not match",
                                toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                          }

                        }
                        else{
                          Fluttertoast.showToast(msg: "Please fill in all the details!!",
                              toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                      },
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Text(
                        "Reset Password",
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
