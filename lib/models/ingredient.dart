import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/macronutrients.dart';
import '../widgets/nutrients.dart';

class Ingredient {
  String name = "";
  int serving = 0;
  int currentServing = 0;
  List macronutrient = <Macronutrients>[];
  List vitamins = <Nutrients>[];
  List minerals = <Nutrients>[];
  List aminioAcids = <Nutrients>[];
  List fattyAcids = <Nutrients>[];
  double adjustFraction = 0;
  Ingredient(
      {required this.name,
      required this.serving,
      required this.currentServing,
      required this.macronutrient,
      required this.vitamins,
      required this.minerals,
      required this.aminioAcids,
      required this.fattyAcids,
      required this.adjustFraction});

  String getBeautifyServing() {
    return this.currentServing.toString() + "g - " + this.name;
  }

  void setAdjustFraction(int currentServing, double adjustFraction) {
    this.currentServing = currentServing;
    this.adjustFraction = adjustFraction;
    for(Macronutrients mu in this.macronutrient) {
      mu.setAdjustFraction(adjustFraction);
    }
    for(Nutrients n in this.vitamins) {
      n.setAdjustFraction(adjustFraction);
    }
    for(Nutrients n in this.minerals) {
      n.setAdjustFraction(adjustFraction);
    }
    for(Nutrients n in this.aminioAcids) {
      n.setAdjustFraction(adjustFraction);
    }
    for(Nutrients n in this.fattyAcids) {
      n.setAdjustFraction(adjustFraction);
    }
  }
}
