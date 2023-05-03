import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Nutrients {
  String name = "";
  double value = 0.0;
  String renderValue = "";
  double rda = 0.0;
  int progressColor = 0;
  double adjustFraction = 0.0;

  Nutrients(String name, double value, double rda, double adjustFraction) {
    this.name = name;
    this.value = value != null ? value : 0;
    this.rda = rda != null ? rda : 1;
    setAdjustFraction(adjustFraction);
  }

  void setAdjustFraction(double adjustFraction) {
    this.adjustFraction = adjustFraction;

    if((value * adjustFraction) / rda * 10000 < 100) {
      this.progressColor = APP_COLORS.BLUE_PROGRESS_BAR;
    } else if ((value * adjustFraction) / rda * 10000 < 200) {
      this.progressColor = APP_COLORS.GREEN_PROGRESS_BAR;
    } else {
      this.progressColor = APP_COLORS.RED_PROGRESS_BAR;
    }

    if(value * adjustFraction * 100 >= 1000000000) {
      this.renderValue = (value * adjustFraction * 100 / 1000000000).toStringAsFixed(1) + 'kg';
    } else if(value * adjustFraction * 100 >= 1000000) {
      this.renderValue = (value * adjustFraction * 100 / 1000000).toStringAsFixed(1) + 'g';
    } else if (value * adjustFraction * 100 >= 1000) {
      this.renderValue = (value * adjustFraction * 100 / 1000).toStringAsFixed(1) + 'mg';
    } else {
      this.renderValue = (value * adjustFraction * 100).toStringAsFixed(1) + 'ug';
    }
  }

  Widget buildName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).size.height * 0.004,
        0,
        MediaQuery.of(context).size.height * 0.004,
      ),
      child: Text(
        name,
        style: TextStyle(color: Color(APP_COLORS.BLUE_NUTRIENTS_NAME)),
      ),
    );
  }

  Widget buildValue(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).size.height * 0.004,
          0,
          MediaQuery.of(context).size.height * 0.004,
        ),
        child: Text(textAlign: TextAlign.right, this.renderValue));
  }

  Widget buildProgress(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).size.height * 0.004,
        0,
        MediaQuery.of(context).size.height * 0.004,
      ),
      child: Text(
        textAlign: TextAlign.right,
        '${((value * adjustFraction) / rda * 10000).toStringAsFixed(0)}%',
        style: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }

  Widget buildProgressBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        minHeight: 5,
        backgroundColor: Colors.grey.shade200,
        color: Color(this.progressColor),
        value: ((value * adjustFraction) / rda * 10000).toInt().toDouble() / 100,
      ),
    );
  }
}

class NutrientsGroup extends StatelessWidget {
  const NutrientsGroup({super.key, required this.list});

  final List list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.height * 0.08,
        MediaQuery.of(context).size.height * 0.03,
        MediaQuery.of(context).size.height * 0.08,
        MediaQuery.of(context).size.height * 0.03,
      ),
      child: Table(
          // border: TableBorder.all(color: Colors.black),
          columnWidths: {
            0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.12),
            1: FlexColumnWidth(MediaQuery.of(context).size.width * 0.10),
            2: FlexColumnWidth(MediaQuery.of(context).size.width * 0.06),
            3: FlexColumnWidth(MediaQuery.of(context).size.width * 0.08),
          },
          children: [
            ...list.map((e) => TableRow(
                  children: [
                    TableCell(child: e.buildName(context)),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: e.buildProgressBar(context)),
                    TableCell(child: e.buildProgress(context)),
                    TableCell(child: e.buildValue(context)),
                  ],
                )),
          ]),
    );
  }
}
