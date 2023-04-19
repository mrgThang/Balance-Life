import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Nutrients {
  late final String name;
  late final double value;
  late final double rda;
  late final int progressColor;

  Nutrients(String name, double value, double rda) {
    this.name = name;
    this.value = value != null ? value : 0;
    this.rda = rda != null ? rda : 1;
    if(value / rda * 100 < 1) {
      this.progressColor = APP_COLORS.BLUE_PROGRESS_BAR;
    } else if (value / rda * 100 < 2) {
      this.progressColor = APP_COLORS.GREEN_PROGRESS_BAR;
    } else {
      this.progressColor = APP_COLORS.RED_PROGRESS_BAR;
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
        child:
            Text(textAlign: TextAlign.right, '${value.toStringAsFixed(0)} g'));
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
        '${(value / rda * 10000).toStringAsFixed(0)}%',
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
        value: (value / rda * 10000).toInt().toDouble() / 100,
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
