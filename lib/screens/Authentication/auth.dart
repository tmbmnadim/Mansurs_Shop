import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maanecommerceui/providers/profile_provider.dart';
import 'package:maanecommerceui/screens/Profile/get_user_data_screen.dart';
import 'package:maanecommerceui/screens/Home/home.dart';
import 'package:maanecommerceui/screens/Authentication/sign_in_screen.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel user;

  void _getData() async {
    Provider.of<ProfileProvider>(context, listen: false).updateUserData();
    ProfileProvider userProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    user = userProvider.user;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          //User Logged in
          if (snapshot.hasData) {
            if ((user.fullName ?? "").isNotEmpty) {
              return const Home();
            } else {
              return const UserDetailsInput();
            }
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
