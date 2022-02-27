import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pwd_app/screens/login/login_screen.dart';

import '../../main.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildFullscreenImage(String image, String text) {
    return Stack(children: [
      Image.asset(
        image,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
      Container(
        color: Colors.black.withOpacity(0.5),
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 115),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    ]);
  }

  Widget globalBottomChild() {
    if (introKey.currentState?.getPagesLength() != null) {
      if (introKey.currentState?.controller.page?.round() ==
          introKey.currentState!.getPagesLength() - 1) {
        return MaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          onPressed: () {
            setState(() {
              Get.off(LoginScreen());
            });
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          color: Colors.yellow[700],
          child: const Text(
            "Get started",
            style: TextStyle(fontSize: 18),
          ),
        );
      } else {
        return MaterialButton(
          onPressed: () {
            setState(() {
              introKey.currentState?.next();
            });
          },
          shape: const CircleBorder(),
          color: Colors.yellow[700],
          child: const Icon(Icons.arrow_forward),
        );
      }
    } else {
      return MaterialButton(
        onPressed: () {
          setState(() {
            introKey.currentState?.next();
          });
        },
        shape: const CircleBorder(),
        color: Colors.yellow[700],
        child: const Icon(Icons.arrow_forward),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      onChange: (_) {
        setState(() {});
      },
      key: introKey,
      globalBackgroundColor: Colors.transparent,
      globalFooter: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: SizedBox(
          height: 60,
          child: globalBottomChild(),
        ),
      ),
      pages: [
        PageViewModel(

          bodyWidget: Container(),
          titleWidget: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top:50.0),
              child: Text("An Inside to the life at Protection Dogs Worldwide",textAlign: TextAlign.center, style:TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )),
          ),
          image: _buildFullscreenImage('assets/Protection Dogs Worldwide-4.jpg',
              ""),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          bodyWidget: Container(),
          titleWidget: Container(
            alignment: Alignment.center,
           margin: EdgeInsets.only(top:50.0),
            child: Text("The Ultimate Personal & Family Protection Dogs",textAlign: TextAlign.center, style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            )),
          ),
          image: _buildFullscreenImage(
              'assets/Protection Dogs Worldwide-76.jpg',
              ""),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          bodyWidget: Container(),
          titleWidget: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top:50.0),
            child: Text("Elite Family & Personal Protection Dogs Supplier",textAlign: TextAlign.center, style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            )),
          ),
          image: _buildFullscreenImage(
              'assets/Protection Dogs Worldwide-203.jpg',
              ""),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          bodyWidget: Container(),
          titleWidget: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top:50.0),
            child: Text("Personal & Family Protection Dogs",textAlign: TextAlign.center, style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            )),
          ),
          image: _buildFullscreenImage(
              'assets/Protection Dogs Worldwide-257.jpg',
              ""),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
      ],
      showDoneButton: false,
      showSkipButton: false,
      showNextButton: false,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
          activeColor: Colors.white,
          size: Size(10.0, 10.0),
          color: Colors.white,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          spacing: EdgeInsets.symmetric(horizontal: 8, vertical: 100)),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
