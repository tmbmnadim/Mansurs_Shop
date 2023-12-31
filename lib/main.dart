import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/firebase_options.dart';
import 'package:maanecommerceui/providers/cart_provider.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:maanecommerceui/providers/orders_provider.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/providers/profile_provider.dart';
import 'package:maanecommerceui/screens/Start%20Screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => GoToPageProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: "MN Shopping",
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        )),
        home: const SplashScreen(),
      ),
    ),
  );
}
