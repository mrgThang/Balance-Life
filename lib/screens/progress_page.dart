import 'package:app/services/api_service.dart';
import 'package:app/widgets/statistics.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/meal.dart';
import '../models/user_model.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPage();
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _ProgressPage extends State<ProgressPage> {
  String chartType = "Calories";
  String tail = "Cal";
  List<DailyMeals> _dataSource = [];
  double today = 0;
  double goal = 2250;
  double dailyAvg = 0;
  
  List _statistics = [];

  Future<void> setUpMealsData() async {
    var dailyMealsData = await getMealsByWeek(
        userId: currentUser?.id ?? 0,
        date: DateTime.now().subtract(Duration(days: 6)),
        showDetails: false,
        showTotals: false);
    _dataSource = createDailyMealsObjectFromJson(dailyMealsData);
    for (DailyMeals dailyMeals in _dataSource) {
      if(dailyMeals.mealList.isEmpty) {
        _dataSource.remove(dailyMeals);
        break;
      }
    }
    for (DailyMeals dailyMeals in _dataSource) {
      dailyMeals.getTotalMacroNutrientsValue();
      if (dailyMeals.date == DateTime.now().toString().substring(0, 10)) {
        today = dailyMeals.getTotal(chartType);
      }
      dailyAvg += dailyMeals.getTotal(chartType);
    }
    dailyAvg = dailyAvg / _dataSource.length;
    _statistics = [
      Statistics("Today", today, "Cal"),
      Statistics("Goal", goal, "Cal"),
      Statistics("Daily Avg", dailyAvg, "Cal"),
    ];
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    setUpMealsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress',
            style: TextStyle(
              color: Color(APP_COLORS.GREEN),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2,
              color: Color(APP_COLORS.GRAY)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color(APP_COLORS.GREEN),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chart My:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      onPressed: () {},
                      label: Text(
                        chartType,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      icon: const Icon(
                        IconlyLight.arrow_right_2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChooseButton(
                text: "1 wk",
                open: true,
              ),
              ChooseButton(
                text: "1 m",
                open: false,
              ),
              ChooseButton(
                text: "3 m",
                open: false,
              ),
              ChooseButton(
                text: "6 m",
                open: false,
              ),
              ChooseButton(
                text: "1 yr",
                open: false,
              ),
            ],
          ),
          SizedBox(height: 20,),
          StatisticsGroup(list: _statistics),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.02,
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries>[
                ColumnSeries<DailyMeals, String>(
                  dataSource: _dataSource,
                  xValueMapper: (DailyMeals dailyMeals, _) => dailyMeals.displayDate(),
                  yValueMapper: (DailyMeals dailyMeals, _) => dailyMeals.getTotal(chartType),
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                StackedLineSeries<DailyMeals, String>(
                  dataSource: _dataSource,
                  xValueMapper: (DailyMeals dailyMeals, _) => dailyMeals.displayDate(),
                  yValueMapper: (DailyMeals dailyMeals, _) => goal,

                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseButton extends StatelessWidget {
  final String text;
  final bool open;
  const ChooseButton({super.key, required this.text, required this.open});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: open ? Color(APP_COLORS.GREEN) : Colors.white10,
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            text,
            style: TextStyle(
              color: open ? Colors.white : Color(APP_COLORS.GREEN),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

}
