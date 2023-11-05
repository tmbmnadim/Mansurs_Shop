import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maanecommerceui/firebase_options.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:maanecommerceui/providers/product_provider.dart';
import 'package:maanecommerceui/providers/user_profile_provider.dart';
import 'package:maanecommerceui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => GoToPageProvider()),
      ],
      child: MaterialApp(
        title: "MN Shopping",
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: const SplashScreen(),
      ),
    ),
  );
}
