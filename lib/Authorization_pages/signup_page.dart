import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/authorization_elements/Or_login_with.dart';
import 'package:to_do/home_page.dart';
import '../authorization_elements/Text_Field_Form.dart';

import '../services/database.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = "", username = "", password = "";

  Future<void> registration() async {
    if (password != "" && userNameController != "" && emailController != "") {
      try {
        UserCredential _ = await FirebaseAuth.instance
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
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        await FirebaseAuth.instance.currentUser!.updateDisplayName(username);

        Map<String, dynamic> userInfoMap = {
          "email": email,
          "username": username,
          "uid": FirebaseAuth.instance.currentUser!.uid,
        };


        await UserDetailDatabase().addUser(FirebaseAuth.instance.currentUser!.uid, userInfoMap);

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
                        controller: userNameController,
                        errorText: 'Require Your Username',
                        labelText: 'Username',
                      ),

                      SizedBox(height: 10),
                      Text_Field_Form(
                        controller: emailController,
                        errorText: 'Require Your E-mail',
                        labelText: 'E-mail',
                      ),
                      SizedBox(height: 10),
                      Text_Field_Form(
                        controller: passwordController,
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
                              email = emailController.text;
                              username = userNameController.text;
                              password = passwordController.text;
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
                        LoginPage(),
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
