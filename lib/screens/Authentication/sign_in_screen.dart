import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maanecommerceui/screens/Authentication/auth.dart';
import 'package:maanecommerceui/custom_widgets/custom_switch.dart';
import 'package:maanecommerceui/providers/go_to_page.dart';
import 'package:maanecommerceui/screens/Home/homepage.dart';
import 'package:maanecommerceui/screens/Authentication/sign_up_screen.dart';
import '../../custom_widgets/icon_logo.dart';
import '../../custom_widgets/my_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  UtilManager utilManager = UtilManager();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color darkGreen = const Color.fromARGB(255, 52, 78, 65);
  Color mainGreen = const Color.fromARGB(255, 50, 194, 122);
  bool switchOn = false;
  bool obscureText = true;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenSize.height - 30,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 26,
                      color: Color.fromARGB(255, 93, 93, 93),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in to your account",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  signInForm(screenSize: screenSize),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Divider(
                          color: Color.fromARGB(70, 50, 194, 122),
                          thickness: 2,
                        ),
                      ),
                      Text("Or"),
                      SizedBox(
                        width: 150,
                        child: Divider(
                          color: Color.fromARGB(70, 50, 194, 122),
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  extraSignIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInForm({required Size screenSize}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          utilManager.customTextField(
            labelText: "Email",
            hintText: "example@mail.com",
            prefixIcon: const Icon(Icons.email_outlined),
            controller: emailController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            validator: (value) => _validateInput(value, "Email"),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Password",
            hintText: "Use Alphabets, Numbers and Signs.",
            controller: passwordController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.lock_outline),
            obscureText: obscureText,
            suffixIcon: IconButton(
              onPressed: () {
                obscureText = !obscureText;
                setState(() {});
              },
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) => _validateInput(value, "Password"),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSwitch(
                value: switchOn,
                enableColor: const Color.fromARGB(255, 50, 194, 122),
                onChanged: (value) {
                  switchOn = value;
                  setState(() {});
                },
              ),
              const Text(
                "Remember Me",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
              SizedBox(width: screenSize.width * 0.1),
              RichText(
                text: TextSpan(
                  text: "Forgot Password?",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 50, 194, 122),
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          utilManager.customTextButton(
            buttonText: "Login",
            width: screenSize.width,
            textColor: Colors.white,
            splashColor: Colors.white,
            color: const Color.fromARGB(255, 50, 194, 122),
            borderRadius: 80,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  EasyLoading.show(status: "Signing in...");
                  UserCredential user = await _auth
                      .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                  EasyLoading.dismiss();
                  if (user.user != null) {
                    EasyLoading.showSuccess('Signed in');
                    emailController.clear();
                    passwordController.clear();
                    if (context.mounted) {
                      GoToPageProvider().goToPage(context, page: const Homepage());
                    }
                  }
                } on FirebaseAuthException catch (error) {
                  if (error.code == 'wrong-password') {
                    EasyLoading.showError('Please type correct password');
                  } else if (error.code == 'user-not-found') {
                    EasyLoading.showError('No user with this email!');
                  } else if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
                    EasyLoading.showError('Please, input correct credentials or Sign Up');
                  } else{
                    EasyLoading.showError(error.code.toString());
                  }
                } catch (e) {
                  EasyLoading.showError(e.toString());
                }
              }
            },
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Sign Up",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 194, 122),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget extraSignIn() {
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          utilManager.customButton(
            width: 80,
            height: 80,
            color: const Color.fromARGB(255, 253, 247, 247),
            splashColor: const Color.fromARGB(255, 52, 78, 65),
            child: Image.asset(
              "images/apple.png",
              scale: 3,
            ),
            onTap: () async {
              // try {
              //   EasyLoading.show(status: "Signing in...");
              //   await signInWithGoogle();
              //   EasyLoading.dismiss();
              // } catch (e) {
              //   EasyLoading.showError(e.toString());
              // }
            },
          ),
          utilManager.customButton(
            width: 80,
            height: 80,
            color: const Color.fromARGB(255, 253, 247, 247),
            splashColor: const Color.fromARGB(255, 52, 78, 65),
            child: Image.asset(
              "images/google.png",
              scale: 3,
            ),
            onTap: () async {
              try {
                EasyLoading.show(status: "Signing in...");
                await signInWithGoogle();
                EasyLoading.dismiss();
                if(context.mounted) GoToPageProvider().goToPage(context, page: const AuthPage());
              } catch (e) {
                EasyLoading.showError(e.toString());
              }
            },
          ),
          utilManager.customButton(
            width: 80,
            height: 80,
            color: const Color.fromARGB(255, 253, 247, 247),
            splashColor: const Color.fromARGB(255, 52, 78, 65),
            child: Image.asset(
              "images/facebook.png",
              scale: 2.2,
            ),
            onTap: () async {
              // try {
              //   EasyLoading.show(status: "Signing in...");
              //   await signInWithGoogle();
              //   EasyLoading.dismiss();
              // } catch (e) {
              //   EasyLoading.showError(e.toString());
              // }
            },
          ),
        ],
      ),
    );
  }

  String? _validateInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field is required.';
    } else if (field == 'Email' && !isValidEmail(value)) {
      return 'Please enter a valid email address.';
    } else if (field == 'Password' && !isValidPassword(value)) {
      return 'Password must contain both letters and numbers.';
    }
    return null;
  }

  bool isValidEmail(String email) {
    // Use a regex pattern to validate the email format.
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Replace this with your password validation logic.
    // This example requires at least one letter and one number.
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }
}
