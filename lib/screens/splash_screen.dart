import 'package:flutter/material.dart';
import 'package:maanecommerceui/auth.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/icon_logo.dart';
import '../providers/user_profile_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false)
        .updateProductData()
        .then(
          (value) => Provider.of<UserProfileProvider>(context, listen: false)
              .updateUserData()
              .then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ),
                ),
              ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 194, 122),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 2,
                    blurRadius: 10,
                    blurStyle: BlurStyle.inner,
                  ),
                ],
                borderRadius: BorderRadius.circular(100),
              ),
              child: const LeafIcon(),
            ),
          ),
          const SafeArea(
            child: LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
