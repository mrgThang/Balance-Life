import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Statistics extends StatelessWidget{
  String name = "";
  double value = 0.0;
  String tail = "";


  Statistics(String name, double value, String tail) {
    this.name = name;
    this.value = value;
    this.tail = tail;
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
          "${this.value.toStringAsFixed(0)} ${this.tail}",
          style: TextStyle(
            color: Color(APP_COLORS.PINK),
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class StatisticsGroup extends StatelessWidget {
  const StatisticsGroup({super.key, required this.list});

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
