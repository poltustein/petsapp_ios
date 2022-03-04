import 'dart:convert';
import 'dart:developer';

import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pwd_app/models/PaypalScreen.dart';
import 'package:pwd_app/models/SubscriptionInit.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/screens/landingScreen/landing_screen.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/card.dart' as carder;
import 'dart:developer' as logger;
import 'package:http/http.dart' as http;
import 'package:pwd_app/models/SubscriptionResponse.dart';

import '../../main.dart';

class PaymentScreen extends StatefulWidget {
  final Plans plan;
  final int selectedIndex;
  final String subscriptionPlanId;

  PaymentScreen(
      {Key? key,
      required this.plan,
      required this.selectedIndex,
      required this.subscriptionPlanId});

  _PaymentScreen createState() => new _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          child: Material(
              color: Colors.black,
              child: SingleChildScrollView(
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
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Payment Method",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Select Payment Method",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: Text(
                          "Choose Your Payment Mode",
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      margin: EdgeInsets.all(15.0),
                      child: carder.Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child:
                            Wrap(direction: Axis.horizontal, children: <Widget>[
                          Stack(children: [
                            Positioned.fill(
                                child: Container(
                                    color: Colors.black.withOpacity(0.8))),
                            Container(
                                height: 200.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Total Payment",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white
                                                  .withOpacity(0.5))),
                                      Text(
                                          widget
                                              .plan
                                              .planCosts![widget.selectedIndex]!
                                              .planCost!
                                              .split(" ")[0],
                                          style: TextStyle(
                                              fontSize: 35.0,
                                              color: Colors.yellow,
                                              fontWeight: FontWeight.bold)),
                                      Text("Premium Plan",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ))
                          ]),
                        ]),
                      ),
                    ),

                    //  Platform.isIOS?Padding(
                    //    padding: const EdgeInsets.all(8.0),
                    //    child: Container(
                    //     margin: EdgeInsets.all(15.0),
                    //     decoration: BoxDecoration(
                    //         border: Border(
                    //           top: BorderSide.none,
                    //           bottom: BorderSide(width: 1.0, color: Colors.yellow),
                    //         ),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(bottom: 15.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Expanded(flex: 2,child: Image.asset('assets/2560px-Apple_Pay_logo.svg.png', height: 15, width: 25, color: Colors.white )),
                    //           Expanded(flex: 6,child: Text('Apple Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                    //           Expanded(flex: 2, child: Icon(Icons.arrow_forward_ios, color: Colors.yellow,)),
                    //         ],
                    //       ),
                    //     ),
                    // ),
                    //  ):Container(),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.yellow)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            Get.dialog(
                              Center(
                                child: CircularProgressIndicator(
                                    color: Colors.yellow),
                              ),
                            );
                            SubscriptionInit? subscriptionInit =
                                await WebService().createSubscription(
                                    prefs.getString('emailid')!,
                                    widget
                                        .plan
                                        .planCosts![widget.selectedIndex]!
                                        .singlePlanId!,
                                    prefs.getString('token')!);
                            if (Get.isDialogOpen == true) {
                              Get.back();
                            }
                            if (subscriptionInit != null &&
                                subscriptionInit.clientSecret != null) {
                              bool isSubscribed =
                                  await makePayment(subscriptionInit);
                              if (isSubscribed) {
                                SubscriptionResponse response =
                                    await WebService().subscribe(
                                        prefs.getString('emailid')!,
                                        prefs.getString('token')!,
                                        widget.plan!.planId!,
                                        widget.subscriptionPlanId!);
                                if (response.status == 'SUCCESS') {
                                  prefs.setBool('isSubscribed', true);
                                  prefs.commit();
                                } else {
                                  prefs.setBool('isSubscribed', false);
                                  prefs.commit();
                                }
                              } else {
                                prefs.setBool('isSubscribed', false);
                                prefs.commit();
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Icon(Icons.credit_card_outlined,
                                        size: 25, color: Colors.white)),
                                Expanded(
                                    flex: 6,
                                    child: Text('Credit Card',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white))),
                                Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.yellow,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.yellow)),
                        ),
                        child: InkWell(
                          onTap: () async {
                            print(widget.plan.planCosts![widget.selectedIndex]!
                                .planCost!);
                            print(
                                "selected=" + widget.selectedIndex.toString());
                            Get.to(() => PaypalScreen(
                                planCost: widget
                                    .plan
                                    .planCosts![widget.selectedIndex]!
                                    .planCost!));

                            // if(isSubscribed){
                            //   SubscriptionResponse response = await WebService().subscribe(prefs.getString('emailid'), prefs.getString('token'), widget.plan!.planId!, widget.subscriptionPlanId!);
                            //   if(response.status=='SUCCESS'){
                            //     prefs.setBool('isSubscribed', true);
                            //     prefs.commit();
                            //   }
                            //   else{
                            //     prefs.setBool('isSubscribed', false);
                            //     prefs.commit();
                            //   }
                            // }
                            // else{
                            //   prefs.setBool('isSubscribed', false);
                            //   prefs.commit();
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Icon(Icons.credit_card_outlined,
                                        size: 25, color: Colors.white)),
                                Expanded(
                                    flex: 6,
                                    child: Text('Paypal',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white))),
                                Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.yellow,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> makePayment(SubscriptionInit sub) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: sub!.clientSecret,
              applePay: false,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'Protection Dogs Worldwide'));

      return displayPaymentSheet(sub);
    } catch (e) {
      print('exception ' + e.toString());
    }
    return false;
  }

  Future<bool> displayPaymentSheet(SubscriptionInit sub) async {
    try {
      print("inside displayPaymentSheet");
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(msg: "Paid successfully!!");
      Get.offAll(() => LandingScreen(currentIndex: 0),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 800));
      return true;
    } on StripeError catch (e) {
      print(e.toString());
    }
    return false;
  }

  calculateAmount(String amount) {
    print('amount=' + amount.split(' ')[0].substring(1));
    print('amount=' + amount.split(' ')[0].substring(1));
    final price =
        (double.parse(amount.split(' ')[0].substring(1)) * 100).round();
    return price.toString();
  }

  // createPaymentIntent(String amount, String currency) async{
  //   try{
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': 'USD',
  //       'payment_method_types[]': 'card'
  //     };
  //
  //     var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //     body: body,
  //       headers:{
  //        'Authorization':'Bearer sk_test_51HZcwOD761eomLmXcnR4JaEaBrcq6QtzVdVOq09fPcObqRBpG29JyzbboJrPDv6eIh5tdznvqPklr69aUrN6qA1i00xVcJcDZ7',
  //         'Content-type':'application/x-www-form-urlencoded'
  //       });
  //     print(response.body.toString());
  //       return jsonDecode(response.body.toString());
  //   }catch(e){
  //     print('exception '+e.toString());
  //   }
  // }

}
