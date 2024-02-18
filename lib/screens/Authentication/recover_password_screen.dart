import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../custom_widgets/my_widgets.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UtilManager utilManager = UtilManager();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void forgotPassword() async {
    try {
      EasyLoading.show(status: "Sending...");
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      EasyLoading.dismiss();
      if(context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recover Password",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26,
                      color: Color.fromARGB(255, 93, 93, 93),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Enter Your Email Address to recover your password!",
                    textAlign: TextAlign.left,
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
          // Email Field
          utilManager.customTextField(
            labelText: "Email Address",
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

          // Sign Up Button
          utilManager.customTextButton(
            buttonText: "Send Reset Email",
            fontSize: 20,
            height: 50,
            width: screenSize.width,
            textColor: Colors.white,
            splashColor: Colors.white,
            color: const Color.fromARGB(255, 50, 194, 122),
            borderRadius: 80,
            onTap: () async {
              forgotPassword();
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
    }
    return null;
  }

  bool isValidEmail(String email) {
    // Use a regex pattern to validate the email format.
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailPattern).hasMatch(email);
  }
}
