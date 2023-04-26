import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:app/screens/home_page.dart';
import 'package:app/screens/plan_page.dart';
import 'package:app/screens/create_screens/camera_page.dart';
import 'package:app/screens/chat_page.dart';
import 'package:app/screens/profile_page.dart';


class ControlPage extends StatefulWidget {
  const ControlPage({super.key, required this.camera, this.plan, this.i});

  final CameraDescription camera;
  final String? plan;
  final int? i;

  @override
  State<ControlPage> createState() => _ControlPage();
}

class _ControlPage extends State<ControlPage> {

  int _currentIndex = 0;

  late List<Widget> _children;

  final List<Widget> _currentTitle = [
    const Text('Home Page'),
    const Text('Plan Page'),
    const Text('Camera Page'),
    const Text('Chat Page'),
    const Text('Profile Page'),
  ];

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
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CameraPage(camera: widget.camera),
        ),
      );
      return;
    }
    setState(() {
      _currentIcon[_currentIndex] = _lightIcon[_currentIndex];
      _currentIndex = index;
      _currentIcon[_currentIndex] = _boldIcon[_currentIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.i != null) {
      _currentIcon[_currentIndex] = _lightIcon[_currentIndex];
      _currentIndex = widget.i!;
      _currentIcon[_currentIndex] = _boldIcon[_currentIndex];
    }
    _children = [
      HomePage(camera: widget.camera),
      PlanPage(label: widget.plan),
      CameraPage(camera: widget.camera),
      ChatPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentTitle[_currentIndex],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
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