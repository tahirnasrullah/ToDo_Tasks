import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do/services/auth.dart';


class OrLoginWith extends StatelessWidget {
  final String subtitle;
  final String inkWellText;
  final Widget toPage;

  const OrLoginWith({super.key, required this.subtitle, required this.inkWellText, required this.toPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Or Login with',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                AuthMethords().signInWithGoogle(context);
              },
              icon: const FaIcon(FontAwesomeIcons.google, size: 60,),
            ),
            const SizedBox(width: 40),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.apple, size: 60,),
            ),
          ],
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subtitle,
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
}


