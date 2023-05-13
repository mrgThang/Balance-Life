import 'package:app/models/ingredient.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../widgets/macronutrients.dart';
import '../widgets/nutrients.dart';
import 'constants.dart';

String processLastTime(String timestamp) {
  DateTime parsedDate = DateTime.parse(timestamp).toLocal();
  var timeNow = DateTime.now();
  Duration duration = timeNow.difference(parsedDate);
  if (duration.inHours < 24) {
    int hour = parsedDate.hour;
    int minute = parsedDate.minute;
    String suffix = "AM";
    if (hour > 12) {
      hour -= 12;
      suffix = "PM";
    }
    String time =
        minute < 10 ? "$hour:0$minute $suffix" : "$hour:$minute $suffix";
    return time;
  }
  if (duration.inDays < 7) {
    return DateFormat.E().format(parsedDate);
  }
  if (duration.inDays < 365) {
    return DateFormat.MMMd().format(parsedDate);
  }
  return '${DateFormat.MMMd().format(parsedDate)}, ${parsedDate.year}';
}

String processMessageTime(String timestamp) {
  DateTime parsedDate = DateTime.parse(timestamp).toLocal();
  var timeNow = DateTime.now();
  Duration duration = timeNow.difference(parsedDate);
  int hour = parsedDate.hour;
  int minute = parsedDate.minute;
  String suffix = "AM";
  if (hour > 12) {
    hour -= 12;
    suffix = "PM";
  }
  String time =
      minute < 10 ? "$hour:0$minute $suffix" : "$hour:$minute $suffix";
  String ret = "";
  if (duration.inHours < 24) {
    return time;
  } else if (duration.inDays < 7) {
    ret = DateFormat.E().format(parsedDate);
  } else if (duration.inDays < 365) {
    ret = DateFormat.MMMd().format(parsedDate);
  } else {
    ret = '${DateFormat.MMMd().format(parsedDate)}, ${parsedDate.year}';
  }

  return "$ret $time";
}

DailyMeals createDailyMealsObjectFromJson(data) {
  DailyMeals dailyMeals = DailyMeals();
  for (var mealData in data["meals"]) {
    Meal currentMeal = createMealObjectFromJson(mealData);
    dailyMeals.mealList.add(currentMeal);
  }
  return dailyMeals;
}

Meal createMealObjectFromJson(data) {
  Meal meal = Meal();
  meal.mealId = data["id"];
  meal.time = data["time"];
  meal.userId = data["user_id"];
  for (var foodData in data["food_set"]) {
    Food currentFood = createFoodObjectFromJson(foodData);
    meal.foodList.add(currentFood);
  }
  return meal;
}

Food createFoodObjectFromJson(data) {
  print(data);
  Food food = Food();
  food.name = data["food_name"];
  // food.description = data["description"];
  if (data["image"] != null) {
    food.imageUrl = data["image"];
  }
  food.foodId = data["id"];
  for(var ingredientData in data["ingredient_set"]) {
    Ingredient currentIngredient = createIngredientObjectFromJson(ingredientData);
    food.ingredients.add(currentIngredient);
  }
  return food;
}

Ingredient createIngredientObjectFromJson(data) {
  String name = data["ingredient_name"];
  double serving = data["serving"].toDouble();
  double currentServing = data["amount"];
  double adjustFraction = (currentServing / serving).toDouble();

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
      data[macronutrientName[i].toString().toLowerCase()],
      macronutrientTail[i],
      adjustFraction,
    ));
  }
  for (int i = 0; i < VITAMIN_NAMES.length; ++i) {
    var nutrientData = data["nutrient_set"];
    vitamins.add(nutrientData[VITAMIN_NAMES[i]] != null
        ? Nutrients(
      VITAMIN_NAMES[i],
      nutrientData[VITAMIN_NAMES[i]]["amount"],
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
    var nutrientData = data["nutrient_set"];
    minerals.add(nutrientData[MINERAL_NAMES[i]] != null
        ? Nutrients(
      MINERAL_NAMES[i],
      nutrientData[MINERAL_NAMES[i]]["amount"],
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
    var nutrientData = data["nutrient_set"];
    aminioAcids.add(nutrientData[AMINO_ACIDS_NAMES[i]] != null
        ? Nutrients(
      AMINO_ACIDS_NAMES[i],
      nutrientData[AMINO_ACIDS_NAMES[i]]["amount"],
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
    var nutrientData = data["nutrient_set"];
    fattyAcids.add(nutrientData[FATTY_ACIDS_NAMES[i]] != null
        ? Nutrients(
      FATTY_ACIDS_NAMES[i],
      nutrientData[FATTY_ACIDS_NAMES[i]]["amount"],
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

  Ingredient ingredient = Ingredient(
      name: name,
      serving: serving.toInt(),
      currentServing: currentServing.toInt(),
      macronutrient: macronutrient,
      vitamins: vitamins,
      minerals: minerals,
      aminioAcids: aminioAcids,
      fattyAcids: fattyAcids,
      adjustFraction: adjustFraction
  );
  return ingredient;
}
