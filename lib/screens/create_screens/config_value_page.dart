import 'dart:async';

import 'package:app/widgets/nutrients.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/ingredient.dart';
import '../../utils/constants.dart';
import '../../widgets/macronutrients.dart';

class ConfigValuePage extends StatefulWidget {
  ConfigValuePage({
    super.key,
    this.ingredientData = Null,
    required this.ingredientList,
    required this.indexIngredientList,
    required this.isNew,
  });

  final ingredientData;
  final List<Ingredient> ingredientList;
  final int indexIngredientList;
  final bool isNew;

  @override
  State<ConfigValuePage> createState() => _ConfigValuePage();
}

class _ConfigValuePage extends State<ConfigValuePage> {
  late int _currentServing;
  late Timer _timer;
  late Ingredient _currentIngredient;

  void _configNewValue() {
    String name = widget.ingredientData["ingredient_name"];
    int serving = widget.ingredientData["serving"];
    double adjustFraction = 1.0;

    List macronutrientName = ["Calories", "Proteins", "Fat", "Carbohydrates"];
    List macronutrientTail = ["cal", "g", "g", "g"];

    List macronutrient = <Macronutrients>[];
    List vitamins = <Nutrients>[];
    List minerals = <Nutrients>[];
    List aminioAcids = <Nutrients>[];
    List fattyAcids = <Nutrients>[];

    for (int i = 0; i < 4; ++i) {
      macronutrient.add(Macronutrients(
        macronutrientName[i],
        widget.ingredientData[macronutrientName[i].toString().toLowerCase()],
        macronutrientTail[i],
        adjustFraction,
      ));
    }
    for (int i = 0; i < VITAMIN_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      vitamins.add(nutrientData[VITAMIN_NAMES[i]] != null
          ? Nutrients(
              VITAMIN_NAMES[i],
              nutrientData[VITAMIN_NAMES[i]]["ammount"],
              nutrientData[VITAMIN_NAMES[i]]["rda"],
              adjustFraction,
            )
          : Nutrients(
              VITAMIN_NAMES[i],
              0,
              1,
              adjustFraction,
            ));
    }
    for (int i = 0; i < MINERAL_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      minerals.add(nutrientData[MINERAL_NAMES[i]] != null
          ? Nutrients(
              MINERAL_NAMES[i],
              nutrientData[MINERAL_NAMES[i]]["ammount"],
              nutrientData[MINERAL_NAMES[i]]["rda"],
              adjustFraction,
            )
          : Nutrients(
              MINERAL_NAMES[i],
              0,
              1,
              adjustFraction,
            ));
    }
    for (int i = 0; i < AMINO_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      aminioAcids.add(nutrientData[AMINO_ACIDS_NAMES[i]] != null
          ? Nutrients(
              AMINO_ACIDS_NAMES[i],
              nutrientData[AMINO_ACIDS_NAMES[i]]["ammount"],
              nutrientData[AMINO_ACIDS_NAMES[i]]["rda"],
              adjustFraction,
            )
          : Nutrients(
              AMINO_ACIDS_NAMES[i],
              0,
              1,
              adjustFraction,
            ));
    }
    for (int i = 0; i < FATTY_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      fattyAcids.add(nutrientData[FATTY_ACIDS_NAMES[i]] != null
          ? Nutrients(
              FATTY_ACIDS_NAMES[i],
              nutrientData[FATTY_ACIDS_NAMES[i]]["ammount"],
              nutrientData[FATTY_ACIDS_NAMES[i]]["rda"],
              adjustFraction,
            )
          : Nutrients(
              FATTY_ACIDS_NAMES[i],
              0,
              1,
              adjustFraction,
            ));
    }

    _currentIngredient = Ingredient(
        name: name,
        serving: serving,
        currentServing: serving,
        macronutrient: macronutrient,
        vitamins: vitamins,
        minerals: minerals,
        aminioAcids: aminioAcids,
        fattyAcids: fattyAcids,
        adjustFraction: adjustFraction);
    _currentServing = serving;
  }

  void _configOldValue() {
    _currentIngredient = widget.ingredientList[widget.indexIngredientList];
    _currentServing = _currentIngredient.currentServing;
  }

  @override
  void initState() {
    if (widget.isNew) {
      _configNewValue();
    } else {
      _configOldValue();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIngredient.name,
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
              if (widget.isNew) {
                widget.ingredientList.add(_currentIngredient);
              } else {
                widget.ingredientList[widget.indexIngredientList] =
                    _currentIngredient;
              }
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
                "${_currentIngredient.name}'s nutrient",
                style: TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            MacroNutrientsGroup(list: _currentIngredient.macronutrient),
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
            NutrientsGroup(list: _currentIngredient.vitamins),
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
            NutrientsGroup(list: _currentIngredient.minerals),
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
            NutrientsGroup(list: _currentIngredient.aminioAcids),
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
            NutrientsGroup(list: _currentIngredient.fattyAcids),
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
                      color: Colors.grey,
                      blurRadius: 20,
                      offset: Offset(10, -1))
                ],
              ),
              child: BottomAppBar(
                color: Color(APP_COLORS.GREEN_BOTTOM_BAR),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTapDown: (TapDownDetails detail) {
                        _timer =
                            Timer.periodic(Duration(milliseconds: 100), (t) {
                          setState(() {
                            _currentServing -= 10;
                            _currentIngredient.setAdjustFraction(
                                _currentServing,
                                _currentServing / _currentIngredient.serving);
                          });
                        });
                      },
                      onTapUp: (TapUpDetails detail) {
                        _timer.cancel();
                      },
                      onTap: () {
                        setState(() {
                          _currentServing -= 10;
                          _currentIngredient.setAdjustFraction(_currentServing,
                              _currentServing / _currentIngredient.serving);
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
                          _currentServing.toString(),
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
                        _timer =
                            Timer.periodic(Duration(milliseconds: 100), (t) {
                          setState(() {
                            _currentServing += 10;
                            _currentIngredient.setAdjustFraction(
                                _currentServing,
                                _currentServing / _currentIngredient.serving);
                          });
                        });
                      },
                      onTapUp: (TapUpDetails detail) {
                        _timer.cancel();
                      },
                      onTap: () {
                        setState(() {
                          _currentServing += 10;
                          _currentIngredient.setAdjustFraction(_currentServing,
                              _currentServing / _currentIngredient.serving);
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
