import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalScreen extends StatefulWidget {
  final String planCost;

  PaypalScreen({Key? key, required this.planCost});

  _PaypalScreen createState() => new _PaypalScreen();
}

class _PaypalScreen extends State<PaypalScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                ),
                onTap: () {
                  Get.back();
                },
              ),
              title: Text("Pay with Paypal"),
            ),
            body: WebView(
              initialUrl: Uri.encodeFull(
                  "http://protectiondogs.club/paypal_subscriptions_payment_with_php/index.php?planCost=" +
                      widget.planCost),
              javascriptMode: JavascriptMode.unrestricted,
            )));
  }
}
