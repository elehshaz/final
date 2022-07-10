import 'package:flutter/material.dart';
import '../models/user.dart';
import 'subjectpage.dart';
import 'tutorpage.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user,}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home Page";
  late double screenHeight, screenWidth, ctrWidth;

  @override
  void initState() {
    super.initState();
    tabchildren = [
      SubjectPage(user: widget.user),
      TutorPage(user: widget.user),
      SubjectPage(user: widget.user),
      SubjectPage(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      ctrWidth = screenWidth;
    } else {
      ctrWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 10,
        selectedIconTheme: const IconThemeData(color: Colors.green),
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: ctrWidth * 0.07,
              ),
              label: "Subjects"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: ctrWidth * 0.07,
              ),
              label: "Tutors"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: ctrWidth * 0.07,
              ),
              label: "Subscribe"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_rounded,
                size: ctrWidth * 0.07,
              ),
              label: "Favourite"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Subjects";
      }
      if (_currentIndex == 1) {
        maintitle = "Tutors";
      }
      if (_currentIndex == 2) {
        maintitle = "Subscribe";
      }
      if (_currentIndex == 3) {
        maintitle = "Favourite";
      }
      
    });
  }
}
