import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/database.dart';

class Greegings extends StatefulWidget {
  const Greegings({super.key});

  @override
  State<Greegings> createState() => _GreegingsState();
}

class _GreegingsState extends State<Greegings> {
  @override
  Widget build(BuildContext context) {
    TaskService taskService = TaskService();

    return StreamBuilder<int>(
      stream: taskService.assignedTaskCount(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello! Good Morning, ${FirebaseAuth.instance.currentUser!.displayName} 👋",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'You have ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                children: [
                  TextSpan(
                    text: '${snapshot.data} tasks',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: '\nthis month 👍'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController searchController;

  const SearchField({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      cursorColor: Colors.grey,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        alignLabelWithHint: true,
        hint: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            Text("Search", style: TextStyle(color: Colors.grey)),
          ],
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

Widget taskStatusButton(buttonColor,text,onpressed,{icon}) {
  return SizedBox(
    width: 80,
    height: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onpressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: buttonColor),
              borderRadius: BorderRadius.circular(25),
              color: buttonColor.withOpacity(0.2),
            ),
            child: Center(
              child: FaIcon(icon,size: 20, color: buttonColor),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(text, style: TextStyle(color: buttonColor, fontSize: 12, fontWeight: FontWeight.w800))
      ],
    ),
  );
}
