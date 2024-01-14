import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanecommerceui/providers/cart_provider.dart';
import 'package:maanecommerceui/screens/Authentication/auth.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/icon_logo.dart';
import '../../providers/profile_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      Provider.of<ProductProvider>(context, listen: false)
          .getProductData()
          .then(
        (value) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getFavouriteProducts();
          Provider.of<CartProvider>(context, listen: false).getAllCartItems();
          Provider.of<ProfileProvider>(context, listen: false)
              .updateUserData()
              .then(
            (value) {
              Future.delayed(Duration.zero, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ),
                );
              });
            },
          );
        },
      );
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        );
      });
    }
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
