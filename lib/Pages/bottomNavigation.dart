import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Pages/others_users_page.dart';
import 'package:to_do/Pages/NewHomePage/new_home_page.dart';
import 'package:to_do/Pages/search_page.dart';

import 'HomePageElements/add_card.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    NewHomePage(),
    SearchPage(),
    Center(child: Text("Settings")),
    OtherUsersPage(),
    Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: const Text(
            'Todo DailyTasks',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:
              FirebaseAuth.instance.currentUser!.photoURL == null
                  ? null
                  : NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              child: FirebaseAuth.instance.currentUser!.photoURL == null
                  ? Text(FirebaseAuth.instance.currentUser!.displayName!)
                  : null,
            ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: false,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent.shade400,
        elevation: 10,
        tooltip: "Add a new task",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showCardDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,


      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.black,
        iconSize: 20,
        currentIndex: _currentIndex,
        elevation: 20,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.group_add_outlined),activeIcon: Icon(Icons.group_add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }

  void _showCardDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AddCard());
  }
}
