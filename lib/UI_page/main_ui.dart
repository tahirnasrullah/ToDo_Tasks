

import 'package:flutter/material.dart';

import 'Education_ListView.dart';
import 'grid_career.dart';
import 'listview_tile_career.dart';
import 'wrap_education.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI_Project',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var education_list = [
      {
        'degree': 'Bs English',
        'university': 'GIFT University, Gujranwala',
        'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQd5zE0X2Owj9N25lRREwugldPjW0UfeWcEuQ&s',
      },
      {
        'degree': 'ICS (Statics)',
        'university': 'GIFT College, Gujranwala',
        'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9u54h-YV7ddCwyLtEcbdWuepY2lOxTt6WTA&s',
      },
      {
        'degree': 'Matric',
        'university': 'JDIHS (Jadeed Dastgir Ideal High School), Gujranwala',
        'image':
        'https://blogger.googleusercontent.com/img/a/AVvXsEibCMsAKyOeI6hGpWGfnAz6Nsaa256QiV7SRYhp5g9oTjfTmmfoXX8fFVD4PF-bmQdZAeltLExJK41HyUILZS4LPUGisnU1cEX2Pb1JWMVZvPlZzlYP_TjG3h6hb1i1Vurm7NxOdKsSS7hHM_QAt8gm8wk4mk9Kwzr5NdwPtJdCbTGxIwBkWIpeHfvfuw=w468-h117',
      },

    ];

    var career_list = [
      {
        'job': 'Flutter Stack Engineer',
        'company': 'ABC Company, Islamabad',
        'experience': '02 years',
        'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFOjd8PDhGm8LFLAVy8Jw8QkT5RWABDyvMBg&s',
      },
      {
        'job': 'Frontend Developer',
        'company': 'XYZ Company, Lahore',
        'experience': '0.5 years',
        'image':
        'https://www.shutterstock.com/image-vector/xyz-logo-design-260nw-1134856919.jpg',
      },
      {
        'job': 'Flutter Developer',
        'company': 'QRS Company, Gujranwala',
        'experience': '01 years',
        'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHQwq2GT7ul9FbzODBpSyuBYPV2qVDFnp8sw&s',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'My Personal Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Education History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Education_ListView(education_list),
              SizedBox(height: 20),
              Text(
                'My Career History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(height: 400, child: GridViewCareer(career_list)),
              SizedBox(height: 20),
              Text(
                'My Education History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              wrap_education(education_list),
              SizedBox(height: 10),
              Text(
                'My Career History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 250, child: lisview_tile_career(career_list)),
            ],
          ),
        ),
      ),
    );
  }
}
