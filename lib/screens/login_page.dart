import 'package:app/screens/sign_up_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'control_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title, required this.camera});

  final String title;
  final CameraDescription camera;

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color(0xff77ea7e),
          )
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffe4fbe5),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    ClipOval(
                      clipper: CustomRect1(),
                      child: Container(
                        height: 180,
                        width: 240,
                        color: const Color(0xffe4fbe5),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    ClipOval(
                      clipper: CustomRect2(),
                      child: Container(
                        height: 140,
                        width: 200,
                        color: const Color(0xffecfbe8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Balance ",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff77ea7e),
                    )
                  ),
                  TextSpan(
                    text: "life",
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xffa2ec8e),
                    )
                  )
                ]
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SizedBox(width: 1),
                          Text(
                            "Forgot password?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffa2ec8e),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var body = {
                                "email": emailController.text.toString(),
                                "password": passwordController.text.toString()
                              };
                              try {
                                login(body: body).then((value) {
                                  getUserList().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ControlPage(camera: widget.camera)),
                                    );
                                  });
                                });
                              } catch (e) {
                                // No specified type, handles all
                                print('Something really unknown: $e');
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill input')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff91c788),
                            minimumSize: const Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffa2ec8e),
                  ),
                ),
                GestureDetector(
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff77ea7e),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage()
                      )
                    );
                  },
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}

class CustomRect1 extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(-size.width, -size.height, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class CustomRect2 extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(size.width*2, -size.height, 0, size.height);
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}