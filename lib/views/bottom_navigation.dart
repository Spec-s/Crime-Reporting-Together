// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, prefer_final_fields, unused_import

import 'package:crimereporting/constants/routes.dart';
import 'package:crimereporting/views/crime_video.dart';
import 'package:crimereporting/views/identify_persons.dart';
import 'package:crimereporting/views/missing_persons.dart';
import 'package:crimereporting/views/wanted_person.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 2;
  // ignore: unused_field
  GlobalKey _bottomNavigationKey = GlobalKey();
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
      appBar: NewGradientAppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginroute, (route) => false);
            },
            icon: Icon(Icons.logout),
          )
        ],
        title: Center(
          child: Text(
            'Crime Reporting Together',
          ),
        ),
        flexibleSpace: Container(
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            // ignore: prefer_const_constructors
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 48, 23, 213),
              Color.fromARGB(255, 59, 187, 80),
            ]),
          ),
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        index: _currentIndex,
        items: [
          Icon(Icons.video_library,
              size: 30, color: Color.fromARGB(255, 9, 184, 30)),
          Icon(Icons.compare, size: 30, color: Color.fromARGB(255, 33, 6, 155)),
          Icon(Icons.person_search,
              size: 30, color: Color.fromARGB(255, 222, 112, 21)),
          Icon(Icons.people, size: 30, color: Color.fromARGB(255, 10, 6, 6)),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),

      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            CrimeVideos(),
            IdentifyPerson(),
            MissingPersonstest(),
            WantedPersons(),
          ],
        ),
      ),
    );
  }
}
