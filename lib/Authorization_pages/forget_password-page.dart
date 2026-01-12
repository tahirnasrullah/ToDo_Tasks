import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Authorization_pages/signup_page.dart';
import '../authorization_elements/Text_Field_Form.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _email_controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    String email = "";
    resetPassword() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        SnackBar(
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 16),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          SnackBar(
            content: Text('E-mail not Found', style: TextStyle(fontSize: 16)),
          );
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black),
          Center(
            child: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 200),
                    Text(
                      'Forget Password?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text_Field_Form(
                      controller: _email_controller,
                      errorText: 'Require Your E-mail',
                      labelText: 'E-mail',
                      labelColor: Colors.white,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Enter Your E-mail to Reset',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = _email_controller.text;
                          });
                        }
                        resetPassword();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        InkWell(
                          child: Text(
                            "Create",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
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
        ],
      ),
    );
  }
}
