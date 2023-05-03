import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/macronutrients.dart';
import '../widgets/nutrients.dart';
import 'ingredient.dart';

class Food {
  String name = "";
  String description = "";
  List<Ingredient> ingredients = <Ingredient>[];

  List<Macronutrients> getTotalMacronutrients() {
    List<Macronutrients> totalMacronutrients = <Macronutrients>[
      Macronutrients("", 0, "", 1.0),
      Macronutrients("", 0, "", 1.0),
      Macronutrients("", 0, "", 1.0),
      Macronutrients("", 0, "", 1.0)
    ];
    for(Ingredient i in ingredients) {
      List<Macronutrients> currentMacronutrients = List.from(i.macronutrient);
      for(int index = 0; index < totalMacronutrients.length; ++index) {
        totalMacronutrients[index].value += currentMacronutrients[index].value * currentMacronutrients[index].adjustFraction;
        totalMacronutrients[index].name = currentMacronutrients[index].name.toString();
        totalMacronutrients[index].tail = currentMacronutrients[index].tail.toString();
        totalMacronutrients[index].setAdjustFraction(1.0);
      }
    }
    return totalMacronutrients;
  }

  List<Nutrients> getTotalVitamins() {
    List<Nutrients> totalVitamins = <Nutrients>[
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
    ];
    for(Ingredient i in ingredients) {
      List<Nutrients> currentVitamins = List.from(i.vitamins);
      for(int index = 0; index < totalVitamins.length; ++index) {
        totalVitamins[index].value += currentVitamins[index].value * currentVitamins[index].adjustFraction;
        totalVitamins[index].name = currentVitamins[index].name.toString();
        if(currentVitamins[index].value != 0) {
          totalVitamins[index].rda = currentVitamins[index].rda.toDouble();
        }
        totalVitamins[index].setAdjustFraction(1.0);
      }
    }
    return totalVitamins;
  }

  List<Nutrients> getTotalMinerals() {
    List<Nutrients> totalMinerals = <Nutrients>[
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
    ];
    for(Ingredient i in ingredients) {
      List<Nutrients> currentMinerals = List.from(i.minerals);
      for(int index = 0; index < totalMinerals.length; ++index) {
        totalMinerals[index].value += currentMinerals[index].value * currentMinerals[index].adjustFraction;
        totalMinerals[index].name = currentMinerals[index].name.toString();
        if(currentMinerals[index].value != 0) {
          totalMinerals[index].rda = currentMinerals[index].rda.toDouble();
        }
        totalMinerals[index].setAdjustFraction(1.0);
      }
    }
    return totalMinerals;
  }

  List<Nutrients> getTotalAminoAcids() {
    List<Nutrients> totalAminoAcids = <Nutrients>[
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
    ];
    for(Ingredient i in ingredients) {
      List<Nutrients> currentAminoAcids = List.from(i.aminioAcids);
      for(int index = 0; index < totalAminoAcids.length; ++index) {
        totalAminoAcids[index].value += currentAminoAcids[index].value * currentAminoAcids[index].adjustFraction;
        totalAminoAcids[index].name = currentAminoAcids[index].name.toString();
        if(currentAminoAcids[index].value != 0) {
          totalAminoAcids[index].rda = currentAminoAcids[index].rda.toDouble();
        }
        totalAminoAcids[index].setAdjustFraction(1.0);
      }
    }
    return totalAminoAcids;
  }

  List<Nutrients> getTotalFattyAcids() {
    List<Nutrients> totalFattyAcids = <Nutrients>[
      Nutrients("", 0.0, 1.0, 1.0),
      Nutrients("", 0.0, 1.0, 1.0),
    ];
    for(Ingredient i in ingredients) {
      List<Nutrients> currentFattyAcids = List.from(i.fattyAcids);
      for(int index = 0; index < totalFattyAcids.length; ++index) {
        totalFattyAcids[index].value += currentFattyAcids[index].value * currentFattyAcids[index].adjustFraction;
        totalFattyAcids[index].name = currentFattyAcids[index].name.toString();
        if(currentFattyAcids[index].value != 0) {
          totalFattyAcids[index].rda = currentFattyAcids[index].rda.toDouble();
        }
        totalFattyAcids[index].setAdjustFraction(1.0);
      }
    }
    return totalFattyAcids;
  }
}
