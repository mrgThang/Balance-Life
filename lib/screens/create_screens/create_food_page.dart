import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app/screens/create_screens/edit_ingredients_page.dart';
import 'package:app/utils/constants.dart';

import '../../models/food.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class CreateFoodPage extends StatefulWidget {
  const CreateFoodPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<CreateFoodPage> createState() => _CreateFoodPage();
}

class _CreateFoodPage extends State<CreateFoodPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Food _food = Food();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

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
              onPressed: () async {
                _food.name = _nameController.text;
                _food.description = _descriptionController.text;
                int food_id = await createFoods(_food) as int;
                await uploadImageForTheFood(_food, food_id, widget.imagePath);
                fToast.showToast(
                  toastDuration: Duration(seconds: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.05,
                        MediaQuery.of(context).size.height * 0.02,
                        MediaQuery.of(context).size.height * 0.05,
                        MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text(
                        "Create new food successfully!",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  gravity: ToastGravity.CENTER,
                );
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
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
                      TextButton(
                        onPressed: () async {
                          _food.name = _nameController.text;
                          _food.description = _descriptionController.text;
                          _food = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => EditIngredientsPage(meal: _food,),
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, -1.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                          setState(() {});
                        },
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
                          padding: EdgeInsets.all(10.0),
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
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.width * 2),
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
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: "Enter food's name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter food's name";
                            }
                            return null;
                          },
                          style: TextStyle(color: Color(APP_COLORS.GRAY),),
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
                          controller: _descriptionController,
                          textAlign: TextAlign.start,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
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
                          style: TextStyle(color: Color(APP_COLORS.GRAY),),
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
                        Visibility(
                          visible: _food.ingredients.isNotEmpty,
                          child: Table(
                            // border: TableBorder.all(color: Colors.black),
                            columnWidths: {
                              0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.10),
                            },
                            children: [
                              ..._food.ingredients.map((e) => TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        MediaQuery.of(context).size.height * 0.03,
                                        0,
                                        0,
                                      ),
                                      child: Text(
                                        e.getBeautifyServing(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(APP_COLORS.GRAY),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    )),
              )),
        ));
  }
}
