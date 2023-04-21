import 'package:app/widgets/nutrients.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../utils/constants.dart';
import '../../widgets/macronutrients.dart';

class ConfigValuePage extends StatefulWidget {
  const ConfigValuePage(
      {super.key, required this.ingredientName, required this.ingredientData});

  final String ingredientName;
  final ingredientData;

  @override
  State<ConfigValuePage> createState() => _ConfigValuePage();
}

class _ConfigValuePage extends State<ConfigValuePage> {
  late final List _macronutrient = <Macronutrients>[];
  late final List _vitamins = <Nutrients>[];
  late final List _minerals = <Nutrients>[];
  late final List _aminioAcids = <Nutrients>[];
  late final List _fattyAcids = <Nutrients>[];

  @override
  void initState() {
    List name = ["Calories", "Proteins", "Fat", "Carbohydrates"];
    List tail = ["cal", "g", "g", "g"];
    for (int i = 0; i < 4; ++i) {
      _macronutrient.add(Macronutrients(
          name: name[i],
          value: widget.ingredientData[name[i].toString().toLowerCase()],
          tail: tail[i]));
    }
    for (int i = 0; i < VITAMIN_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _vitamins.add(nutrientData[VITAMIN_NAMES[i]] != null
          ? Nutrients(
              VITAMIN_NAMES[i],
              nutrientData[VITAMIN_NAMES[i]]["ammount"],
              nutrientData[VITAMIN_NAMES[i]]["rda"],
            )
          : Nutrients(
              VITAMIN_NAMES[i],
              0,
              1,
            ));
    }
    for (int i = 0; i < MINERAL_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _minerals.add(nutrientData[MINERAL_NAMES[i]] != null
          ? Nutrients(
        MINERAL_NAMES[i],
        nutrientData[MINERAL_NAMES[i]]["ammount"],
        nutrientData[MINERAL_NAMES[i]]["rda"],
      )
          : Nutrients(
        MINERAL_NAMES[i],
        0,
        1,
      ));
    }
    for (int i = 0; i < AMINO_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _aminioAcids.add(nutrientData[AMINO_ACIDS_NAMES[i]] != null
          ? Nutrients(
        AMINO_ACIDS_NAMES[i],
        nutrientData[AMINO_ACIDS_NAMES[i]]["ammount"],
        nutrientData[AMINO_ACIDS_NAMES[i]]["rda"],
      )
          : Nutrients(
        AMINO_ACIDS_NAMES[i],
        0,
        1,
      ));
    }
    for (int i = 0; i < FATTY_ACIDS_NAMES.length; ++i) {
      var nutrientData = widget.ingredientData["nutrient_set"];
      _fattyAcids.add(nutrientData[FATTY_ACIDS_NAMES[i]] != null
          ? Nutrients(
        FATTY_ACIDS_NAMES[i],
        nutrientData[FATTY_ACIDS_NAMES[i]]["ammount"],
        nutrientData[FATTY_ACIDS_NAMES[i]]["rda"],
      )
          : Nutrients(
        FATTY_ACIDS_NAMES[i],
        0,
        1,
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ingredientName,
              style: const TextStyle(
                color: Colors.black,
              )),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(IconlyLight.arrow_left_2,
                color: Color(APP_COLORS.GRAY)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Text(
                  "${widget.ingredientName}'s nutrient",
                  style: TextStyle(
                    color: Color(APP_COLORS.GREEN),
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
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
                      _macronutrient[0],
                      _macronutrient[1],
                      _macronutrient[2],
                      _macronutrient[3]
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Text(
                  "Vitamins",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              NutrientsGroup(list: _vitamins),
              Center(
                child: Text(
                  "Minerals",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              NutrientsGroup(list: _minerals),
              Center(
                child: Text(
                  "Essential Amino Acids",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              NutrientsGroup(list: _aminioAcids),
              Center(
                child: Text(
                  "Essential Fatty Acids",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              NutrientsGroup(list: _fattyAcids),
            ],
          ),
        ));
  }
}
