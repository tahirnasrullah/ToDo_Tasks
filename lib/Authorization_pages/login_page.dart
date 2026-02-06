import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Authorization_pages/forget_password-page.dart';
import 'package:to_do/Pages/bottomNavigation.dart';
import 'package:to_do/authorization_elements/Or_login_with.dart';
import '../authorization_elements/Text_Field_Form.dart';
import 'package:to_do/Authorization_pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = "", password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

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
                              email = emailController.text.trim();
                              password = passwordController.text.trim();
                            });

                            userLogin(); // move inside validation
                          }
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
                              builder: (context) => ForgetPasswordPage(),
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
                        SignupPage(),
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

  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Logged in Successfully",
            style: TextStyle(fontSize: 12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
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
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void checkLogin() async {
    var prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      });
    }
  }

}
