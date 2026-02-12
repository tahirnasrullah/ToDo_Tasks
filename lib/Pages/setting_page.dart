import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authorization_pages/login_page.dart';
import '../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Theme.of(context).textTheme.titleLarge?.color),
            ),
          ),

          // THEME SWITCH
          ListTile(
            leading: Icon(
              isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            title: Text(
              "Switch Theme",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:Theme.of(context).textTheme.titleLarge?.color),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });

                // Change global theme
                MyApp.of(context)?.changeTheme(value);
              },
            ),
          ),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              var prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
