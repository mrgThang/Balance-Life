import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/macronutrients.dart';
import '../widgets/nutrients.dart';

class Ingredient {
  String name = "";
  int serving = 0;
  List macronutrient = <Macronutrients>[];
  List vitamins = <Nutrients>[];
  List minerals = <Nutrients>[];
  List aminioAcids = <Nutrients>[];
  List fattyAcids = <Nutrients>[];
  double adjustFraction = 0;
  Ingredient(
      {required this.name,
      required this.serving,
      required this.macronutrient,
      required this.vitamins,
      required this.minerals,
      required this.aminioAcids,
      required this.fattyAcids,
      required this.adjustFraction});
}
