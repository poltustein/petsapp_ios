import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/login/login_screen.dart';
import 'package:pwd_app/screens/signup/signup_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:toast/toast.dart';

class VerifyOTPScreen extends StatelessWidget {
  final String email;

  const VerifyOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Material(
      child: Stack(
        children: [
          FractionallySizedBox(
              heightFactor: 1,
              child: Image.asset(
                'assets/Protection Dogs Worldwide-90.jpg',
                fit: BoxFit.cover,
              )),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.75,
                  widthFactor: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "OTP has been sent to your email ID",
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  onPressed: () async {
                    if (otpController.text.isNotEmpty) {
                      final networkResponse = await WebService().verifyOTP(
                          email, otpController.text);
                      if (networkResponse?.status == "SUCCESS") {
                        Get.to(LoginScreen(),transition: Transition.downToUp,duration: const Duration(milliseconds: 800));
                      }
                      Toast.show(networkResponse?.reason, context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                  color: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Landing - HomePage, SideBar (Normal), Choose Your Plan (onClick of BUY NOW - HomePage), MyDogs (onClick of MyDogs on SideBar)
