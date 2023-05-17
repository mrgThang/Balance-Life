import '../widgets/macronutrients.dart';
import '../widgets/nutrients.dart';
import 'food.dart';
import 'ingredient.dart';

class Meal {
  int mealId = 0;
  String time = "";
  String date = "";
  int userId = 0;
  List<Food> foodList = <Food>[];

  dynamic getTotalMacroNutrients() {
    var total = {};
    for (Food food in foodList) {
      for (Ingredient i in food.ingredients) {
        for (Macronutrients mac in i.macronutrient) {
          if (total[mac.name] == null) {
            total[mac.name] = mac.value * mac.adjustFraction;
          } else {
            total[mac.name] += mac.value * mac.adjustFraction;
          }
        }
      }
    }
    return total;
  }
}

class DailyMeals {
  List<Meal> mealList = <Meal>[];
  String date = "";
  var total = {};

  String displayDate() {
    return date.substring(5, 10);
  }

  double getTotal(type) {
    if (type == "Calories") {
      return total["Calories"] != null ? total["Calories"] * 100 : 0;
    }
    if (type == "Fat") {
      return total["Fat"] != null ? total["Fat"] / 10000 : 0;
    }
    if (type == "Proteins") {
      return total["Proteins"] != null ? total["Proteins"] / 10000 : 0;
    }
    if (type == "Carbohydrates") {
      return total["Carbohydrates"] != null ? total["Carbohydrates"] / 10000 : 0;
    }
    return 0;
  }

  void getTotalMacroNutrientsValue() {
    var total = {};
    for(Meal meal in mealList) {
      date = meal.date;
      var mealTotal = meal.getTotalMacroNutrients();
      mealTotal.forEach((key, value) {
        if (total[key] == null) {
          total[key] = value;
        } else {
          total[key] += value;
        }
      });
    }
    this.total = total;
  }

  List<Macronutrients> getTotalMacronutrients() {
    List<Macronutrients> totalMacronutrients = List<Macronutrients>.generate(4, (index) {
      Macronutrients macronutrients = Macronutrients("", 0, "", 1.0);
      return macronutrients;
    });
    for(Meal meal in mealList) {
      for (Food food in meal.foodList) {
        for (Ingredient i in food.ingredients) {
          List<Macronutrients> currentMacronutrients = List.from(
              i.macronutrient);
          for (int index = 0; index < totalMacronutrients.length; ++index) {
            totalMacronutrients[index].value +=
                currentMacronutrients[index].value *
                    currentMacronutrients[index].adjustFraction;
            totalMacronutrients[index].name =
                currentMacronutrients[index].name.toString();
            totalMacronutrients[index].tail =
                currentMacronutrients[index].tail.toString();
            totalMacronutrients[index].setAdjustFraction(1.0);
          }
        }
      }
    }
    return totalMacronutrients;
  }

  List<Nutrients> getTotalVitamins() {
    List<Nutrients> totalVitamins = List<Nutrients>.generate(13, (index) {
      Nutrients nutrients = Nutrients("", 0.0, 1.0, 1.0);
      return nutrients;
    });
    for(Meal meal in mealList) {
      for (Food food in meal.foodList) {
        for (Ingredient i in food.ingredients) {
          List<Nutrients> currentVitamins = List.from(i.vitamins);
          for (int index = 0; index < totalVitamins.length; ++index) {
            totalVitamins[index].value += currentVitamins[index].value *
                currentVitamins[index].adjustFraction;
            totalVitamins[index].name = currentVitamins[index].name.toString();
            if (currentVitamins[index].value != 0) {
              totalVitamins[index].rda = currentVitamins[index].rda.toDouble();
            }
            totalVitamins[index].setAdjustFraction(1.0);
          }
        }
      }
    }
    return totalVitamins;
  }

  List<Nutrients> getTotalMinerals() {
    List<Nutrients> totalMinerals = List<Nutrients>.generate(14, (index) {
      Nutrients nutrients = Nutrients("", 0.0, 1.0, 1.0);
      return nutrients;
    });
    for(Meal meal in mealList) {
      for (Food food in meal.foodList) {
        for (Ingredient i in food.ingredients) {
          List<Nutrients> currentMinerals = List.from(i.minerals);
          for (int index = 0; index < totalMinerals.length; ++index) {
            totalMinerals[index].value += currentMinerals[index].value *
                currentMinerals[index].adjustFraction;
            totalMinerals[index].name = currentMinerals[index].name.toString();
            if (currentMinerals[index].value != 0) {
              totalMinerals[index].rda = currentMinerals[index].rda.toDouble();
            }
            totalMinerals[index].setAdjustFraction(1.0);
          }
        }
      }
    }
    return totalMinerals;
  }

  List<Nutrients> getTotalAminoAcids() {
    List<Nutrients> totalAminoAcids = List<Nutrients>.generate(9, (index) {
      Nutrients nutrients = Nutrients("", 0.0, 1.0, 1.0);
      return nutrients;
    });
    for(Meal meal in mealList) {
      for (Food food in meal.foodList) {
        for (Ingredient i in food.ingredients) {
          List<Nutrients> currentAminoAcids = List.from(i.aminioAcids);
          for (int index = 0; index < totalAminoAcids.length; ++index) {
            totalAminoAcids[index].value += currentAminoAcids[index].value *
                currentAminoAcids[index].adjustFraction;
            totalAminoAcids[index].name =
                currentAminoAcids[index].name.toString();
            if (currentAminoAcids[index].value != 0) {
              totalAminoAcids[index].rda =
                  currentAminoAcids[index].rda.toDouble();
            }
            totalAminoAcids[index].setAdjustFraction(1.0);
          }
        }
      }
    }
    return totalAminoAcids;
  }

  List<Nutrients> getTotalFattyAcids() {
    List<Nutrients> totalFattyAcids = List<Nutrients>.generate(2, (index) {
      Nutrients nutrients = Nutrients("", 0.0, 1.0, 1.0);
      return nutrients;
    });
    for(Meal meal in mealList) {
      for (Food food in meal.foodList) {
        for (Ingredient i in food.ingredients) {
          List<Nutrients> currentFattyAcids = List.from(i.fattyAcids);
          for (int index = 0; index < totalFattyAcids.length; ++index) {
            totalFattyAcids[index].value += currentFattyAcids[index].value *
                currentFattyAcids[index].adjustFraction;
            totalFattyAcids[index].name =
                currentFattyAcids[index].name.toString();
            if (currentFattyAcids[index].value != 0) {
              totalFattyAcids[index].rda =
                  currentFattyAcids[index].rda.toDouble();
            }
            totalFattyAcids[index].setAdjustFraction(1.0);
          }
        }
      }
    }
    return totalFattyAcids;
  }
}