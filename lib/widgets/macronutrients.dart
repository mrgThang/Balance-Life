import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Macronutrients extends StatelessWidget{
  String name = "";
  double value = 0.0;
  String tail = "";
  double adjustFraction = 0.0;
  String renderString = "";

  Macronutrients(String name, double value, String tail, double adjustFaction) {
    this.name = name;
    this.value = value;
    this.tail = tail;
    setAdjustFraction(adjustFaction);
  }

  void setAdjustFraction(double adjustFraction) {
    this.adjustFraction = adjustFraction;
    if (this.tail == "cal") {
      double new_value = this.value * 100 * adjustFraction;
      if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
        this.renderString = "${new_value.toStringAsFixed(0)}k${this.tail}";
      }
      this.renderString = "${new_value.toStringAsFixed(1)}k${this.tail}";
    } else {
      double new_value = this.value / 10 * adjustFraction;
      if (new_value >= 1000) {
        new_value = new_value / 1000;
        if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
          this.renderString = "${new_value.toStringAsFixed(0)}${this.tail}";
        }
        this.renderString = "${new_value.toStringAsFixed(1)}${this.tail}";
      }
      if (new_value.toStringAsFixed(1) == "${new_value.toStringAsFixed(0)}.0") {
        this.renderString = "${new_value.toStringAsFixed(0)}m${this.tail}";
      }
      this.renderString = "${new_value.toStringAsFixed(1)}m${this.tail}";
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
          this.renderString,
          style: TextStyle(
            color: Color(APP_COLORS.PINK),
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class MacroNutrientsGroup extends StatelessWidget {
  const MacroNutrientsGroup({super.key, required this.list});

  final List list;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !list.isEmpty,
      child: Container(
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
              ...list.map((e) => e.build(context))
            ],
          ),
        ),
      ),
    );
  }
}
