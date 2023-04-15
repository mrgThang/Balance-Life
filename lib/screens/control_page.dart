import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:app/screens/home_page.dart';
import 'package:app/screens/plan_page.dart';
import 'package:app/screens/camera_page.dart';
import 'package:app/screens/chat_page.dart';
import 'package:app/screens/profile_page.dart';


class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPage();
}

final List<Widget> _children = [
  const HomePage(),
  const PlanPage(),
  const CameraPage(),
  const ChatPage(),
  const ProfilePage(),
];

class _ControlPage extends State<ControlPage> {

  int _currentIndex = 0;

  final List<Icon> _lightIcon = [
    const Icon(IconlyLight.home),
    const Icon(IconlyLight.calendar),
    const Icon(IconlyLight.camera),
    const Icon(IconlyLight.chat),
    const Icon(IconlyLight.profile),
  ];

  final List<Icon> _boldIcon = [
    const Icon(IconlyBold.home),
    const Icon(IconlyBold.calendar),
    const Icon(IconlyBold.camera),
    const Icon(IconlyBold.chat),
    const Icon(IconlyBold.profile),
  ];

  final List<Icon> _currentIcon = [
    const Icon(IconlyBold.home),
    const Icon(IconlyLight.calendar),
    const Icon(IconlyLight.camera),
    const Icon(IconlyLight.chat),
    const Icon(IconlyLight.profile),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIcon[_currentIndex] = _lightIcon[_currentIndex];
      _currentIndex = index;
      _currentIcon[_currentIndex] = _boldIcon[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _currentIcon[0],
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _currentIcon[1],
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: _currentIcon[2],
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: _currentIcon[3],
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: _currentIcon[4],
            label: 'Profile',
          )
        ],
      ),
    );
  }
}