import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:iconly/iconly.dart';

class CreateFoodPage extends StatefulWidget {
  const CreateFoodPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<CreateFoodPage> createState() => _CreateFoodPage();
}

class _CreateFoodPage extends State<CreateFoodPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Food',
              style: TextStyle(
                color: Color(APP_COLORS.GREEN),
              )),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(IconlyLight.arrow_left_2,
                color: Color(APP_COLORS.GRAY)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(APP_COLORS.GRAY),
              ),
              child: const Text("OK"),
            ),
          ],
        ),
        bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.grey.shade300), // Set the width and color of the border
                      ),
                    ),
                    child: BottomAppBar(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => const Color(APP_COLORS.GREEN)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Edit Ingredients',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]))))),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(File(widget.imagePath)),
                            ))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const Text('Name',
                        style: TextStyle(
                          color: Color(APP_COLORS.GREEN),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter food's name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter food's name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const Text('Descriptions',
                        style: TextStyle(
                          color: Color(APP_COLORS.GREEN),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter food's descriptions...",
                        alignLabelWithHint: false,
                        contentPadding: EdgeInsets.only(top: 40, left: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter food's descriptions...";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const Text('Ingredients',
                        style: TextStyle(
                          color: Color(APP_COLORS.GREEN),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ))));
  }
}
