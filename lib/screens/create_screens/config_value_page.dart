import 'dart:async';

import 'package:app/widgets/nutrients.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/ingredient.dart';
import '../../utils/constants.dart';
import '../../widgets/macronutrients.dart';

class ConfigValuePage extends StatefulWidget {
  ConfigValuePage(
      {super.key, required this.ingredientName, required this.ingredientData, required this.ingredientList});

  final String ingredientName;
  final ingredientData;
  List<Ingredient> ingredientList;


  @override
  State<ConfigValuePage> createState() => _ConfigValuePage();
}

class _ConfigValuePage extends State<ConfigValuePage> {
  late List _macronutrient = <Macronutrients>[];
  late List _vitamins = <Nutrients>[];
  late List _minerals = <Nutrients>[];
  late List _aminioAcids = <Nutrients>[];
  late List _fattyAcids = <Nutrients>[];
  late int _serving;
  late double _adjustFraction;
  late Timer timer;

  void _configValue() {
    List name = ["Calories", "Proteins", "Fat", "Carbohydrates"];
    List tail = ["cal", "g", "g", "g"];

    _macronutrient = <Macronutrients>[];
    _vitamins = <Nutrients>[];
    _minerals = <Nutrients>[];
    _aminioAcids = <Nutrients>[];
    _fattyAcids = <Nutrients>[];

    for (int i = 0; i < 4; ++i) {
      _macronutrient.add(Macronutrients(
          name: name[i],
          value: widget.ingredientData[name[i].toString().toLowerCase()],
          tail: tail[i],
          adjustFaction: _adjustFraction,
        )
      );
    }
    for (int i = 0; i < VITAMIN_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _vitamins.add(nutrientData[VITAMIN_NAMES[i]] != null
          ? Nutrients(
        VITAMIN_NAMES[i],
        nutrientData[VITAMIN_NAMES[i]]["ammount"],
        nutrientData[VITAMIN_NAMES[i]]["rda"],
        _adjustFraction,
      )
          : Nutrients(
        VITAMIN_NAMES[i],
        0,
        1,
        _adjustFraction,
      ));
    }
    for (int i = 0; i < MINERAL_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _minerals.add(nutrientData[MINERAL_NAMES[i]] != null
          ? Nutrients(
        MINERAL_NAMES[i],
        nutrientData[MINERAL_NAMES[i]]["ammount"],
        nutrientData[MINERAL_NAMES[i]]["rda"],
        _adjustFraction,
      )
          : Nutrients(
        MINERAL_NAMES[i],
        0,
        1,
        _adjustFraction,
      ));
    }
    for (int i = 0; i < AMINO_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _aminioAcids.add(nutrientData[AMINO_ACIDS_NAMES[i]] != null
          ? Nutrients(
        AMINO_ACIDS_NAMES[i],
        nutrientData[AMINO_ACIDS_NAMES[i]]["ammount"],
        nutrientData[AMINO_ACIDS_NAMES[i]]["rda"],
        _adjustFraction,
      )
          : Nutrients(
        AMINO_ACIDS_NAMES[i],
        0,
        1,
        _adjustFraction,
      ));
    }
    for (int i = 0; i < FATTY_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _fattyAcids.add(nutrientData[FATTY_ACIDS_NAMES[i]] != null
          ? Nutrients(
        FATTY_ACIDS_NAMES[i],
        nutrientData[FATTY_ACIDS_NAMES[i]]["ammount"],
        nutrientData[FATTY_ACIDS_NAMES[i]]["rda"],
        _adjustFraction,
      )
          : Nutrients(
        FATTY_ACIDS_NAMES[i],
        0,
        1,
        _adjustFraction,
      ));
    }
  }

  @override
  void initState() {
    _serving = widget.ingredientData["serving"];
    _adjustFraction = 1.0;
    _configValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredientName,
            style: const TextStyle(
              color: Colors.black,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2,
              color: Color(APP_COLORS.GRAY)),
          onPressed: () => Navigator.of(context).pop(widget.ingredientList),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              widget.ingredientList.add(
                new Ingredient(
                  name: widget.ingredientName,
                  serving: widget.ingredientData["serving"],
                  macronutrient: _macronutrient,
                  vitamins: _vitamins,
                  minerals: _minerals,
                  aminioAcids: _aminioAcids,
                  fattyAcids: _fattyAcids,
                  adjustFraction: _adjustFraction,
                )
              );
              Navigator.of(context).pop(widget.ingredientList);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(APP_COLORS.GRAY),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Text(
                "${widget.ingredientName}'s nutrient",
                style: TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              color: Color(APP_COLORS.LIGHT_PINK),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.height * 0.03,
                  0,
                  MediaQuery.of(context).size.height * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _macronutrient[0],
                    _macronutrient[1],
                    _macronutrient[2],
                    _macronutrient[3]
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Text(
                "Vitamins",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _vitamins),
            Center(
              child: Text(
                "Minerals",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _minerals),
            Center(
              child: Text(
                "Essential Amino Acids",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _aminioAcids),
            Center(
              child: Text(
                "Essential Fatty Acids",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _fattyAcids),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Material(
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 20, offset: Offset(10, -1))
                ],
              ),
              child: BottomAppBar(
                color: Color(APP_COLORS.GREEN_BOTTOM_BAR),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTapDown: (TapDownDetails detail) {
                        timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                          setState(() {
                            _serving -= 10;
                            _adjustFraction = _serving / widget.ingredientData["serving"];
                            _configValue();
                          });
                        });
                      },
                      onTapUp: (TapUpDetails detail) {
                        timer.cancel();
                      },
                      onTap: () {
                        setState(() {
                          _serving -= 10;
                          _adjustFraction = _serving / widget.ingredientData["serving"];
                          _configValue();
                        });
                      },
                      child: Icon(
                        Icons.remove_circle,
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Text(
                          _serving.toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Text(
                        "grams",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    GestureDetector(
                      onTapDown: (TapDownDetails detail) {
                        timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                          setState(() {
                            _serving += 10;
                            _adjustFraction = _serving / widget.ingredientData["serving"];
                            _configValue();
                          });
                        });
                      },
                      onTapUp: (TapUpDetails detail) {
                        timer.cancel();
                      },
                      onTap: () {
                        setState(() {
                          _serving += 10;
                          _adjustFraction = _serving / widget.ingredientData["serving"];
                          _configValue();
                        });
                      },
                      child: Icon(
                        Icons.add_circle,
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
