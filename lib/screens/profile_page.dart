import 'package:app/screens/create_screens/settings_page.dart';
import 'package:app/screens/login_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'create_screens/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

String nameUser = "";
String descriptionsUser = "";

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  "assets/images/noavatar.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              nameUser == "" ? "Name" : nameUser,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              descriptionsUser == "" ? "Descriptions" : descriptionsUser,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xff707070),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const RowProfile(icon: IconlyBold.profile, label: "Edit Profile"),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(camera: widget.camera),
                      )
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff707070)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const RowProfile(icon: Icons.poll, label: "Statistics"),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff707070)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const RowProfile(icon: Icons.settings, label: "Settings"),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage()
                      )
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff707070)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const RowProfile(icon: Icons.privacy_tip, label: "Terms & Privacy Policy"),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff707070)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const RowProfile(icon: Icons.logout_outlined, label: "Log Out"),
                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(title: "Login", camera: widget.camera),
                      ),
                      ModalRoute.withName(''),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff707070)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RowProfile extends StatelessWidget {
  final IconData icon;
  final String label;
  const RowProfile({
    super.key,
    required this.icon,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xffffe2d7),
            ),
            child: Icon(icon, size: 30, color: const Color(0xffff9385)),
          ),
          const SizedBox(width: 20),
          Container(
            height: 50,
            width: 200,
            alignment: const Alignment(-1, 0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xff707070),
              ),
            ),
          ),
        ],
      ),
    );
  }
}