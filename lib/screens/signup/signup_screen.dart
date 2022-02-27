import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/login/login_screen.dart';
import 'package:pwd_app/screens/verifyotp/verify_otp_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:toast/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);


  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  bool isPasswordShow = false;
  final emailTE = TextEditingController();
  final passwordTE = TextEditingController();
  final phoneTE = TextEditingController();
  final nameTE = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: const Text(
                            "Create new account",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Please fill in the form to continue",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white.withOpacity(0.4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
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
                                hintText: "Full Name",
                                hintStyle:
                                    TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: emailTE,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email Address",
                                hintStyle:
                                    TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: phoneTE,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone Number",
                                hintStyle:
                                    TextStyle(color: Colors.white.withOpacity(0.4))),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: const Color(0xff191919),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: passwordTE,
                            obscureText: isPasswordShow?false:true,
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
                                    ),),
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
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 32),
                  // ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                        height: 60,
                        minWidth: double.infinity,
                        onPressed: () async {
                          if (nameTE.text.isNotEmpty &&
                              emailTE.text.isNotEmpty &&
                              phoneTE.text.isNotEmpty &&
                              passwordTE.text.isNotEmpty) {
                            final networkResponse = await WebService().signupUser(nameTE.text, emailTE.text,
                                phoneTE.text, passwordTE.text);
                            if (networkResponse.status == "SUCCESS") {
                              Get.to(VerifyOTPScreen(email: emailTE.text,),transition: Transition.downToUp,duration: const Duration(milliseconds: 800));
                            }
                            Toast.show(networkResponse.reason!, context,
                                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          }
                        },
                        color: Colors.yellow[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
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
                              Get.to(LoginScreen(),transition: Transition.fadeIn,duration: const Duration(milliseconds: 800));
                            },
                            child: Text(
                              "Sign In",
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
