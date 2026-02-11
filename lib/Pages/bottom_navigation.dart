import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Pages/OthersUsersPage/others_users_page.dart';
import 'package:to_do/Pages/NewHomePage/new_home_page.dart';
import 'package:to_do/Pages/SearchPage/search_page.dart';
import 'package:to_do/Pages/setting_page.dart';

import 'MainPageElements/add_card.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Todo DailyTasks',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20,color: Theme.of(context).textTheme.titleLarge?.color,),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    FirebaseAuth.instance.currentUser!.photoURL == null
                    ? null
                    : NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                child: FirebaseAuth.instance.currentUser!.photoURL == null
                    ? Text(FirebaseAuth.instance.currentUser!.displayName!)
                    : null,
              ),
            ),
          ),
        ],
      ),

      resizeToAvoidBottomInset: false,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        elevation: 10,
        tooltip: "Add a new task",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showCardDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      body: IndexedStack(
        index: _currentIndex,
        children: [
          NewHomePage(onTabChange: changeTab),
          SearchPage(),
          SearchPage(),
          OtherUsersPage(),
          SettingPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Colors.deepPurpleAccent.shade700,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "",),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_add_outlined),
            activeIcon: Icon(Icons.group_add),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }

  void _showCardDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AddCard());
  }
}
