import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:pwd_app/models/AuthenticationProvider.dart';
import 'package:pwd_app/screens/landingScreen/components/home_screen.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/login/forgot_password.dart';
import 'package:pwd_app/screens/signup/signup_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool isPasswordShow = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please sign in to your account",
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
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            obscureText: isPasswordShow ? false : true,
                            controller: passwordController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPasswordShow = !isPasswordShow;
                                          //passwordController.text = passwordController.text;
                                        });
                                      },
                                      child: isPasswordShow
                                          ? Icon(
                                              Icons.visibility,
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                            ),
                                    )),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Get.to(ForgotPassword(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 800));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        child: Text("Forgot password?",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4))),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 32),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          final networkResponse = await WebService().loginUser(
                              emailController.text, passwordController.text, "NORMAL","","");
                          if (networkResponse.status == "SUCCESS") {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(
                                'emailid', networkResponse.emailId!);
                            prefs.setString('name', networkResponse.name!);
                            prefs.setString(
                                'contact', networkResponse.contact!);
                            prefs.setString('token', networkResponse.token!);
                            prefs.setString('profileImageUrl',
                                networkResponse.profileImageUrl!);
                            prefs.setBool('isLoggedIn', true);
                            prefs.commit();
                            log("login done");
                            Get.offAll(() => LandingScreen(currentIndex:0),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 800));
                          }
                          Toast.show(networkResponse.reason!, context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                    margin: EdgeInsets.only(top: 5.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign In with ",
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              googleSignIn.signIn().then((value) async{
                                GoogleSignInAccount val = value!;
                                final networkResponse = await WebService()
                                    .loginUser(val!.email!,
                                        "", "GOOGLE", val!.displayName!=null?val!.displayName!:" ", val!.photoUrl!=null?val!.photoUrl!:"");
                                if (networkResponse.status == "SUCCESS") {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      'emailid', networkResponse.emailId!);
                                  prefs.setString(
                                      'name', networkResponse.name!);
                                  prefs.setString(
                                      'contact', networkResponse.contact!=null?networkResponse.contact!:" No Contact");
                                  prefs.setString(
                                      'token', networkResponse.token!);
                                  prefs.setString('profileImageUrl',
                                      networkResponse.profileImageUrl!);
                                  prefs.setBool('isLoggedIn', true);
                                  prefs.commit();
                                  log("login done");
                                  Future.delayed(Duration.zero, () {
                                    Get.offAll(()=>LandingScreen(currentIndex:0),
                                        transition: Transition.fadeIn,
                                        duration:
                                        const Duration(milliseconds: 800));
                                  });


                                  Toast.show(networkResponse.reason!, context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                }
                                else{
                                  Toast.show(networkResponse.reason!, context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);

                                  googleSignIn.signOut();
                                }

                              });
                            },
                            child: Image.asset('assets/google.png',
                                height: 24, width: 24),
                          ),

                          InkWell(
                            onTap: () {
                                //context.read<AuthenticationProvider>().signInWithApple();
                            },
                            child: Container(

                              child: Image.asset('assets/apple.png',
                                  height: 24, width: 24),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(5.0, -30.0, 0.0),
                    margin: EdgeInsets.only(top: 10.0),
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
                              Get.to(SignupScreen(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 800));
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
