import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authorization_pages/login_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: [
          const ListTile(
            title: Text("Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
          ),

          ListTile(
            leading: const Icon(Icons.logout,color: Colors.red,),
            title: const Text("Logout",style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
            onTap: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              var prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
            },
          ),


        ]
    );
  }
}
