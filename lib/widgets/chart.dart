import 'package:app/widgets/macronutrients.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../utils/constants.dart';

class MacronutrientsPieChart extends StatelessWidget {
  final List<Macronutrients> macronutrients;
  MacronutrientsPieChart({super.key, required this.macronutrients});

  Map<String, double> getDataMap() {
    Map<String, double> result = {};
    for (Macronutrients m in macronutrients) {
      if (m.tail == "g") result[m.name] = m.value;
    }
    return result;
  }

  final colorList = <Color>[
    const Color(APP_COLORS.PROTEIN_PIE_CHART),
    const Color(APP_COLORS.FAT_PIE_CHART),
    const Color(APP_COLORS.CARBS_PIE_CHART),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PieChart(
        animationDuration: const Duration(milliseconds: 1000),
        dataMap: getDataMap(),
        baseChartColor: Colors.grey[300]!,
        colorList: colorList,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: true,
          decimalPlaces: 1,
        ),

      ),
    );
  }
}
