import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Authorization_pages/forget_password-page.dart';
import 'package:to_do/home_page.dart';
import 'package:to_do/authorization_elements/Or_login_with.dart';
import '../authorization_elements/Text_Field_Form.dart';
import 'package:to_do/Authorization_pages/signup_page.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = "", password = "";

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => home_page()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Logged in Successfully", style: TextStyle(fontSize: 12)),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == 'invalid-credential') {
        message = "Email or password is incorrect";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'user-disabled') {
        message = "This account has been disabled";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(message, style: TextStyle(fontSize: 12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 150, color: Colors.grey),
            Center(
              child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Login Page',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text_Field_Form(
                        controller: Email_controller,
                        errorText: 'Require Your E-mail',
                        labelText: 'E-mail',
                      ),
                      SizedBox(height: 10),
                      Text_Field_Form(
                        controller: Password_controller,
                        errorText: 'Require Your Password',
                        labelText: 'Password',
                        isPassword: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = Email_controller.text;
                              password = Password_controller.text;
                            });
                          }
                          userLogin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forget_password_page(),
                            ),
                          );
                        },
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 60),
                      Or_login_with(
                        "Don't have an account? ",
                        "Sign Up",
                        signup_page(),
                        context,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
