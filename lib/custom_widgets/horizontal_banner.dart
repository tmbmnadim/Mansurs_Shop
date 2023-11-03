import 'package:flutter/material.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';

class BannerWithText extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final String title;
  final String image;
  final String discount;
  final Function() onPressed;

  const BannerWithText({
    super.key,
    this.width = 370,
    this.height = 200,
    this.backgroundColor = Colors.green,
    required this.title,
    required this.image,
    required this.discount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      width: width,
      height: height,
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: width * 0.5,
          ),
          Container(
            width: width * 0.6,
            height: width * 0.6,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(25),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(25),
              ),
              child: Image.asset(
                'images/onboarding0.jpg', // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: ClipPath(
              clipper: _BoxClipper(),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  top: 15,
                  bottom: 15,
                ),
                width: width * 0.55,
                height: width * 0.53,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(25),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: discount, style: const TextStyle(fontSize: 35)),
                      const TextSpan(
                          text: " OFF", style: TextStyle(fontSize: 22)),
                    ])),
                    const SizedBox(height: 10),
                    UtilManager().customTextButton(
                      width: 125,
                      height: 45,
                      buttonText: 'Explore All',
                      textColor: backgroundColor,
                      borderRadius: 50,
                      fontSize: 18,
                      onTap: onPressed,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxClipper extends CustomClipper<Path> {
  _BoxClipper();

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(width * 0.2, height * 0.5, 0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
