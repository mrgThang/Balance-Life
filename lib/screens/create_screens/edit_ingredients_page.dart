import 'package:app/screens/create_screens/config_value_page.dart';
import 'package:app/services/api_service.dart';
import 'package:app/widgets/macronutrients.dart';
import 'package:app/widgets/nutrients.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../models/food.dart';
import '../../utils/constants.dart';
import '../../models/ingredient.dart';
import '../../widgets/chart.dart';

class EditIngredientsPage extends StatefulWidget {
  const EditIngredientsPage({super.key, required this.food});

  final Food food;

  @override
  State<EditIngredientsPage> createState() => _EditIngredientsPage();
}

class _EditIngredientsPage extends State<EditIngredientsPage> {
  late List<Macronutrients> _totalMacronutrients = <Macronutrients>[];
  late List<Nutrients> _totalVitamins = <Nutrients>[];
  late List<Nutrients> _totalMinerals = <Nutrients>[];
  late List<Nutrients> _totalAminoAcids = <Nutrients>[];
  late List<Nutrients> _totalFattyAcids = <Nutrients>[];

  @override
  void initState() {
    super.initState();
    if(widget.food.ingredients.isNotEmpty) {
      _totalMacronutrients = widget.food.getTotalMacronutrients();
      _totalVitamins = widget.food.getTotalVitamins();
      _totalMinerals = widget.food.getTotalMinerals();
      _totalAminoAcids = widget.food.getTotalAminoAcids();
      _totalFattyAcids = widget.food.getTotalFattyAcids();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name,
            style: const TextStyle(
              color: Color(APP_COLORS.GREEN),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2,
              color: Color(APP_COLORS.GRAY)),
          onPressed: () {
            Navigator.of(context).pop(widget.food);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
              ),
              child: RawAutocomplete<String>(
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      setState(() {
                        // Set the selectedOption based on the value entered by the user
                      });
                      onFieldSubmitted();
                    },
                    decoration: InputDecoration(
                      hintText: 'Add new ingredients...',
                      hintStyle: TextStyle(color: Colors.grey),
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: Icon(IconlyBold.close_square),
                        onPressed: () => textEditingController.clear(),
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: Icon(IconlyLight.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true, //<-- SEE HERE
                      fillColor: Color(APP_COLORS.SEARCH_BAR_THEME),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) => Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20.0)),
                    ),
                    child: Container(
                      height: 52.0 * options.length,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        shrinkWrap: false,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(APP_COLORS.SEARCH_BAR_THEME),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return INGREDIENTS_DATA.where((String option) {
                    return option
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) async {
                  var data = await getDetailIngredient(selection);
                  widget.food.ingredients = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ConfigValuePage(
                        ingredientData: data,
                        ingredientList: widget.food.ingredients,
                        indexIngredientList: widget.food.ingredients.length,
                        isNew: true,
                      ),
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(widget.food.ingredients.isNotEmpty) {
                    _totalMacronutrients =
                    await widget.food.getTotalMacronutrients();
                    _totalVitamins = await widget.food.getTotalVitamins();
                    _totalMinerals = await widget.food.getTotalMinerals();
                    _totalAminoAcids = await widget.food.getTotalAminoAcids();
                    _totalFattyAcids = await widget.food.getTotalFattyAcids();
                  }
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
              ),
              child: Table(
                // border: TableBorder.all(color: Colors.black),
                columnWidths: {
                  0: FlexColumnWidth(MediaQuery.of(context).size.width * 0.10),
                  1: FlexColumnWidth(MediaQuery.of(context).size.width * 0.10),
                },
                children: [
                  ...widget.food.ingredients.map((e) => TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                        ),
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(
                              e.getBeautifyServing(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TableCell(
                            child: TextButton(
                              child: Text("Change"),
                              onPressed: () async {
                                widget.food.ingredients = await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => ConfigValuePage(
                                      ingredientList: widget.food.ingredients,
                                      indexIngredientList: widget.food.ingredients.indexOf(e),
                                      isNew: false,
                                    ),
                                    transitionDuration: Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                if(widget.food.ingredients.isNotEmpty) {
                                  _totalMacronutrients =
                                  await widget.food.getTotalMacronutrients();
                                  _totalVitamins = await widget.food.getTotalVitamins();
                                  _totalMinerals = await widget.food.getTotalMinerals();
                                  _totalAminoAcids = await widget.food.getTotalAminoAcids();
                                  _totalFattyAcids = await widget.food.getTotalFattyAcids();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            MacroNutrientsGroup(list: _totalMacronutrients),
            Visibility(
              visible: _totalMacronutrients.length > 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: MacronutrientsPieChart(macronutrients: _totalMacronutrients),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Visibility(
              visible: !_totalVitamins.isEmpty,
              child: Center(
                child: Text(
                  "Vitamins",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _totalVitamins),
            Visibility(
              visible: !_totalMinerals.isEmpty,
              child: Center(
                child: Text(
                  "Minerals",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _totalMinerals),
            Visibility(
              visible: !_totalAminoAcids.isEmpty,
              child: Center(
                child: Text(
                  "Essential Amino Acids",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _totalAminoAcids),
            Visibility(
              visible: !_totalFattyAcids.isEmpty,
              child: Center(
                child: Text(
                  "Essential Fatty Acids",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            NutrientsGroup(list: _totalFattyAcids),
          ]),
        ),
      ),
    );
  }
}
