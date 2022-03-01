// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CardPaymentScreen extends StatefulWidget {

  final Plans plan;
  final int selectedIndex;

  CardPaymentScreen({Key? key, required this.plan, required this.selectedIndex});

  _CardPaymentScreen createState() => new _CardPaymentScreen();
}

// payment_screen.dart
class _CardPaymentScreen extends State<CardPaymentScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CardField(
            onCardChanged: (card) {
              print(card);
            },
          ),
          TextButton(
            onPressed: () async {

              final prefs = await SharedPreferences.getInstance();
              final subscriptionInit = await WebService().createSubscription(prefs.getString('emailid')!, widget.plan.planCosts![widget.selectedIndex]!.singlePlanId!, prefs.getString('token')!);
              Stripe.publishableKey = 'pk_test_51KKmYLSJ36bDoZ0gjiPAXmbmqVln4V3h6NAqmAJXu4Y8p7Py2u7KA3u5s4BhlbtMd2H9a5YgEpYjTThakXRdjLJC00wNStX3dI';
              final paymentMethod =
              await Stripe.instance.createPaymentMethod(PaymentMethodParams.card());
               Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(customerId: subscriptionInit.customerId, applePay: false, setupIntentClientSecret: subscriptionInit.clientSecret, merchantDisplayName: "Protection Dogs Worldwide",style: ThemeMode.dark,
                 testEnv: true,merchantCountryCode: 'UK'));
                Stripe.instance.presentPaymentSheet();
               },
            child: Text('pay'),
          )
        ],
      ),
    );
  }
}