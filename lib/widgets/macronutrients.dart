import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Macronutrients extends StatelessWidget{
  final String name;
  final double value;
  final String tail;

  Macronutrients({super.key, required this.name, required this.value, required this.tail});

  String format() {
    if (tail == "cal") {
      double new_value = value * 100;
      if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
        return "${new_value.toStringAsFixed(0)}k${tail}";
      }
      return "${new_value.toStringAsFixed(1)}k${tail}";
    } else {
      double new_value = value / 10;
      if (new_value >= 1000) {
        new_value = new_value / 1000;
        if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
          return "${new_value.toStringAsFixed(0)}${tail}";
        }
        return "${new_value.toStringAsFixed(1)}${tail}";
      }
      if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
        return "${new_value.toStringAsFixed(0)}m${tail}";
      }
      return "${new_value.toStringAsFixed(1)}m${tail}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name == "Carbohydrates" ? "Carbs" : name,
          style: TextStyle(
            color: Color(APP_COLORS.PINK),
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
          format(),
          style: TextStyle(
            color: Color(APP_COLORS.PINK),
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}