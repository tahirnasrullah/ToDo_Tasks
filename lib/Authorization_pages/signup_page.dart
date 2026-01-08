import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/authorization_elements/Or_login_with.dart';
import 'package:to_do/home_page.dart';
import '../authorization_elements/Text_Field_Form.dart';

import 'login_page.dart';

class signup_page extends StatefulWidget {
  const signup_page({super.key});

  @override
  State<signup_page> createState() => _signup_pageState();
}

class _signup_pageState extends State<signup_page> {
  TextEditingController UserName_controller = TextEditingController();
  TextEditingController Email_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = "", username = "", password = "";

  registration() async {
    if (password != "" && UserName_controller != "" && Email_controller != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registered Successfully',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => home_page()),
        );
      } on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == "weak-password") {
          message = "Password Provided is too weak";
        } else if (e.code == "email-already-in-use") {
          message = "E-mail already in use";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(message, style: TextStyle(fontSize: 12)),
          ),
        );
      }
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
                        'SignUp Page',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text_Field_Form(
                        controller: UserName_controller,
                        errorText: 'Require Your Username',
                        labelText: 'Username',
                      ),

                      SizedBox(height: 10),
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
                        isPassword: true
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
                              username = UserName_controller.text;
                              password = Password_controller.text;
                            });
                          }
                          registration();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      Or_login_with(
                        "Already have an account? ",
                        "Login",
                        login_page(),
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
