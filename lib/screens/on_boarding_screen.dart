import 'package:flutter/material.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:provider/provider.dart';

import '../auth.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final UtilManager utilManager = UtilManager();
  List<String> images = [
    "images/onboarding0.jpg",
    "images/onboarding1.jpg",
    "images/onboarding2.jpg"
  ];
  List<String> titles = [
    "Shop your daily necessary!",
    "Fresh grocery to your doorstep!",
    "Easy and online payment"
  ];
  List<String> subTitles = [
    "A modern shopping system to make it easier for you",
    "Home delivery and track your order to make sure it arrive to the destinations.",
    "Trouble free and online payment any card payment is available"
  ];
  int pageNo = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final providerData = Provider.of<GoToPageProvider>(context, listen: false);
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            // Empty Space
            SizedBox(
              height: screenSize.height,
              width: screenSize.width,
            ),

            // Title and Button Container
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.white,
                height: 500,
                width: screenSize.width,
                child: Column(
                  // Titles and Buttons

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 150),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      child: customCarousel(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 300,
                      child: Text(
                        titles[pageNo],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 300,
                      child: Text(
                        subTitles[pageNo],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black26,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 50, 194, 122),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: utilManager.customButton(
                          height: 60,
                          width: 150,
                          color: const Color.fromARGB(255, 50, 194, 122),
                          borderRadius: 80,
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 40,
                            color: Colors.white,
                          ),
                          onTap: () {
                            pageNo < 2
                                ? pageNo++
                                : providerData.goToPage(
                                    context,
                                    page: const AuthPage(),
                                  );
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Image
            ClipPath(
              clipper: _BoxClipper(atWidth: 0, atHeight: 500),
              child: Container(
                color: Colors.blue,
                height: 500,
                width: double.infinity,
                child: Image.asset(
                  images[pageNo],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: utilManager.customTextButton(
                  width: 80,
                  height: 30,
                  fontSize: 18,
                  buttonText: "Skip",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customCarousel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(images.length, (index) {
        if (index == pageNo) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 50, 194, 122),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              width: 20,
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 50, 194, 122),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        }
      }),
    );
  }
}

class _BoxClipper extends CustomClipper<Path> {
  final double atHeight;
  final double atWidth;

  _BoxClipper({this.atWidth = 0, this.atHeight = 0});

  @override
  Path getClip(Size size) {
    double screenWidth = size.width;
    // double screenHeight = size.height;
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(atWidth, atHeight);
    path.quadraticBezierTo(
      (screenWidth + atWidth) * 0.5,
      atHeight - 100,
      screenWidth,
      atHeight,
    );
    path.lineTo(screenWidth, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
