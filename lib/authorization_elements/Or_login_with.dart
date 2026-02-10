import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do/services/auth.dart';

Widget Or_login_with(Subtitle, inkWellText, toPage, context) {
  return Column(
    children: [
      Text(
        'Or Login with',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              AuthMethords().signInWithGoogle(context);
            },
            icon: FaIcon(FontAwesomeIcons.google, size: 60,color: Colors.black),
          ),
          SizedBox(width: 40),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.apple, size: 60,color: Colors.black,),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Subtitle,
            style: TextStyle(fontSize: 16),
          ),
          InkWell(
            child: Text(
              inkWellText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurpleAccent.shade700,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => toPage,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}