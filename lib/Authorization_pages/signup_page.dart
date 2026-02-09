import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/authorization_elements/Or_login_with.dart';
import '../authorization_elements/Text_Field_Form.dart';
import '../Pages/bottomNavigation.dart';
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
  UserDetailDatabase userDb = UserDetailDatabase();

  String email = "", username = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.shade200,
                    Colors.deepPurpleAccent.shade700,
                  ],
                ),
              ),
            ),
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
                          backgroundColor: Colors.deepPurpleAccent.shade700,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text.trim();
                              username = userNameController.text.trim();
                              password = passwordController.text.trim();
                            });

                            registration(); // CALL HERE ONLY
                          }
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

  Future<void> registration() async {
    if (passwordController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email, password: password);

        User? user = userCredential.user; // STORE USER

        if (user != null) {
          await user.updateDisplayName(username);

          Map<String, dynamic> userInfoMap = {
            "email": email,
            "username": username,
            "uid": user.uid,
          };

          await userDb.addUser(user.uid, userInfoMap);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered Successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
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
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
