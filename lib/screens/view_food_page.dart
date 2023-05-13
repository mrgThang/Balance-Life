import 'package:app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../models/food.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../widgets/macronutrients.dart';
import '../widgets/nutrients_table.dart';

class ViewFoodPage extends StatefulWidget {
  final Food food;
  final String command;
  final List<Food>? foodList;
  const ViewFoodPage({super.key, required this.food, required this.command, this.foodList});

  @override
  State<ViewFoodPage> createState() => _ViewFoodPage();

}

class _ViewFoodPage extends State<ViewFoodPage> {
  String _commandText = "";

  void _clickCommand() {
    if (currentUser?.role == "Normal") {
      if (widget.foodList != null) {
        print(1111);
        if (widget.command == "Add") {
          widget.foodList?.add(widget.food);
        } else {
          widget.foodList?.remove(widget.food);
        }
        Navigator.of(context).pop(widget.foodList);
      }
    } else {
      // Command for specialist
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentUser?.role == "Normal") {
      if (widget.command == "Add") {
        _commandText = "Add food to meal";
      } else {
        _commandText = "Remove from meal";
      }
    } else {
      _commandText = "Yes";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name,
            style: const TextStyle(
              color: Color(APP_COLORS.GREEN),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2,
              color: Color(APP_COLORS.GRAY)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.width * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: widget.food.imageUrl != ""
                          ? Image.network(
                              'http://10.0.2.2:8000${widget.food.imageUrl}',
                              fit: BoxFit.cover,
                              height: 150,
                              width: 200,
                            )
                          : null,
                    ))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text('Descriptions',
                style: TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(widget.food.description,
                style: const TextStyle(
                  color: Color(APP_COLORS.GRAY),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            MacroNutrientsGroup(list: widget.food.getTotalMacronutrients()),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            MacronutrientsPieChart(macronutrients: widget.food.getTotalMacronutrients()),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text('Ingredients',
                style: TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Visibility(
              visible: widget.food.ingredients.isNotEmpty,
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.10),
                },
                children: [
                  ...widget.food.ingredients.map((e) => TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                MediaQuery.of(context).size.height * 0.03,
                                0,
                                0,
                              ),
                              child: Text(
                                e.getBeautifyServing(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(APP_COLORS.GRAY),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            const Text('Nutrients',
                style: TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            NutrientsTable(
              vitamins: widget.food.getTotalVitamins(),
              minerals: widget.food.getTotalMinerals(),
              aminoAcids: widget.food.getTotalAminoAcids(),
              fattyAcids: widget.food.getTotalFattyAcids(),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey.shade300), // Set the width and color of the border
                    ),
                  ),
                  child: BottomAppBar(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _clickCommand();
                              },
                              style: ButtonStyle(
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0))),
                                backgroundColor: MaterialStateProperty.resolveWith(
                                        (states) => const Color(APP_COLORS.GREEN)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  _commandText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ]))))),
    );
  }
}
