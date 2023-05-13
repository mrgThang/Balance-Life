import 'package:app/screens/control_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../profile_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile Page",
          style: TextStyle(
            color: Color(0xff707070),
          )
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2, color: Color(0xff707070)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ControlPage(camera: widget.camera, i: 4),
              )
            );
          },
        ),
      ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: TextField(
                controller: controller1,
                focusNode: nodeOne,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  )
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(nodeTwo);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
              child: TextField(
                controller: controller2,
                focusNode: nodeTwo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Descriptions",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  )
                ),
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller1.text != "") {
                  nameUser = controller1.text;
                }
                if (controller2.text != "") {
                  descriptionsUser = controller2.text;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ControlPage(camera: widget.camera, i: 4),
                  )
                );
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}