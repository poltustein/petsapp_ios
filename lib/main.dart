// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/screens/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

SharedPreferences prefs;
void main() async {
   // await runZonedGuarded(
   //      () async {
      WidgetsFlutterBinding.ensureInitialized();
      Stripe.publishableKey = 'pk_test_51HZcwOD761eomLmXw32b4tGqZiAWIM6sqgQXg6sHNMITeONOiGWbkvlmnoEuTCHjdh1QNcqfTerbknIPQjDfnvbu00UFYfiM4g';
      await Stripe.instance.applySettings();
      prefs = await SharedPreferences.getInstance();
      runApp(const App());
      HttpOverrides.global = MyHttpOverrides();

  //   },
  //       (error, st) => print(error),
  // );

}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );


    return GetMaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: (prefs.getBool('isLoggedIn')!=null && prefs.getBool('isLoggedIn'))?const LandingScreen(currentIndex: 0,):const OnBoardingPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
