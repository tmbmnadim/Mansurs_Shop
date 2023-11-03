import 'package:flutter/material.dart';
import '../custom_widgets/my_widgets.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  UtilManager utilManager = UtilManager();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscureText = true;
  bool obscureTextConf = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          const SizedBox(height: 10),

          // Sign Up Button
          utilManager.customTextButton(
            buttonText: "Set New Password",
            fontSize: 20,
            height: 50,
            width: screenSize.width,
            textColor: Colors.white,
            splashColor: Colors.white,
            color: const Color.fromARGB(255, 50, 194, 122),
            borderRadius: 80,
            onTap: () async {},
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
    } else if (field == 'Password' && !isValidPassword(value)) {
      return 'Password must contain both letters and numbers.';
    } else if (field == 'Confirm Password' &&
        !isPasswordConfirmed(value, passwordController.text)) {
      return 'Please Type the password correctly as Password field';
    }
    return null;
  }

  bool isValidPassword(String password) {
    // Replace this with your password validation logic.
    // This example requires at least one letter and one number.
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }
}
