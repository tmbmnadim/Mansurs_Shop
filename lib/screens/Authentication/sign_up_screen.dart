import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maanecommerceui/screens/Profile/get_user_data_screen.dart';
import 'package:maanecommerceui/screens/Authentication/sign_in_screen.dart';
import '../../custom_widgets/icon_logo.dart';
import '../../custom_widgets/my_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UtilManager utilManager = UtilManager();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool consent = false;
  bool obscureText = true;
  bool obscureTextConf = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Color darkGreen = const Color.fromARGB(255, 52, 78, 65);

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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(
                    size: 120,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Let's get started!",
                    style: TextStyle(
                      fontSize: 26,
                      color: Color.fromARGB(255, 93, 93, 93),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Please enter your valid data in order to create a new account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  signUpForm(screenSize: screenSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpForm({required Size screenSize}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name Field
          utilManager.customTextField(
            labelText: "Full name",
            hintText: "Mansur Nadim",
            controller: fullNameController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.person_3_outlined),
            validator: (value) => _validateInput(value, "Full Name"),
          ),
          const SizedBox(height: 10),
          // Email Field
          utilManager.customTextField(
            labelText: "Email",
            hintText: "example@mail.com",
            controller: emailController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) => _validateInput(value, "Email"),
          ),
          const SizedBox(height: 10),
          // Password Field
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
          utilManager.customTextField(
            labelText: "Confirm Password",
            hintText: "Use Alphabets, Numbers and Signs.",
            controller: confirmPasswordController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.lock_outline),
            obscureText: obscureTextConf,
            suffixIcon: IconButton(
              onPressed: () {
                obscureTextConf = !obscureTextConf;
                setState(() {});
              },
              icon: Icon(
                obscureTextConf ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) => _validateInput(value, "Confirm Password"),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: consent,
                checkColor: Colors.white,
                activeColor: const Color.fromARGB(255, 50, 194, 122),
                onChanged: (value) {
                  consent = value!;
                  setState(() {});
                },
              ),
              SizedBox(
                width: screenSize.width * 0.75,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "I agree with the ",
                      ),
                      TextSpan(
                        text: "Terms and Services ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 50, 194, 122),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: "& ",
                      ),
                      TextSpan(
                        text: "Privacy Policy.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sign Up Button
          utilManager.customTextButton(
            buttonText: "Sign Up",
            fontSize: 20,
            height: 50,
            width: screenSize.width,
            textColor: Colors.white,
            splashColor: Colors.white,
            color: const Color.fromARGB(255, 50, 194, 122),
            borderRadius: 80,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (consent) {
                  try {
                    EasyLoading.show(status: "Creating User...");
                    UserCredential user =
                        await _auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (user.user != null) {
                      EasyLoading.showSuccess('Signed up');

                      emailController.clear();
                      passwordController.clear();
                      if (context.mounted && (FirebaseAuth.instance.currentUser?.uid!=null)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsInput(
                              fullName: fullNameController.text,
                            ),
                          ),
                        );
                      }
                    } else {
                      EasyLoading.showError('Something is Wrong');
                    }
                  } on FirebaseAuthException catch (error) {
                    if (error.code == 'weak-password') {
                      EasyLoading.showError(
                          'The password provided is too weak.');
                    } else if (error.code == 'email-already-in-use') {
                      EasyLoading.showError(
                          'A account already exists for that email.');
                    }
                  } catch (e) {
                    EasyLoading.showError(e.toString());
                  }
                } else {
                  EasyLoading.showError(
                      "You must agree to the terms and conditions to use our service");
                }
              }
            },
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              text: "Already Have an Account? ",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Sign In",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 50, 194, 122),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      EasyLoading.show(status: "Loading...");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
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

  bool isPasswordConfirmed(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  String? _validateInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field is required.';
    } else if (field == 'Email' && !isValidEmail(value)) {
      return 'Please enter a valid email address.';
    } else if (field == 'Password' && !isValidPassword(value)) {
      return 'Password must contain both letters and numbers.';
    } else if (field == 'Confirm Password' &&
        !isPasswordConfirmed(value, passwordController.text)) {
      return 'Please Type the password correctly as Password field';
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
