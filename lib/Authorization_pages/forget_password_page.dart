import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Authorization_pages/signup_page.dart';
import 'package:to_do/services/database.dart';
import '../authorization_elements/text_field_form.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final UserDetailDatabase database = UserDetailDatabase();

    // Future<void> resetPassword() async {
    //   try {
    //     await FirebaseAuth.instance.sendPasswordResetEmail(
    //       email: emailController.text.trim(),
    //     );
    //
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           'If this email exists, a reset link has been sent.',
    //           style: TextStyle(fontSize: 16),
    //         ),
    //       ),
    //     );
    //     Navigator.pop(context);
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == "user-not-found") {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('E-mail not Found', style: TextStyle(fontSize: 16)),
    //         ),
    //       );
    //     }
    //   }
    // }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 200),
                Text(
                  'Forget Password?',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextFieldForm(
                  controller: emailController,
                  errorText: 'Require Your E-mail',
                  labelText: 'E-mail',
                ),
                SizedBox(height: 15),
                Text(
                  'Enter Your E-mail to Reset',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent.shade700,
                    foregroundColor: Colors.white,
                  ),
                  // onPressed: () {
                  //   if (formKey.currentState!.validate()) {
                  //     resetPassword();
                  //   }
                  // },
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final email = emailController.text;

                    bool exists = await database.doesEmailExist(email);
                    log('data==========: $exists');

                    if (!exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email not registered")),
                      );
                      return;
                    }

                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: email,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password reset link sent"),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      String message = "Something went wrong";

                      if (e.code == 'invalid-email') {
                        message = "Invalid email format";
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Reset',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      child: Text(
                        "Create",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
