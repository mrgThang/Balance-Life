import 'package:app/widgets/nutrients.dart';
import 'package:flutter/material.dart';

class NutrientsTable extends StatelessWidget {
  final List<Nutrients> vitamins;
  final List<Nutrients> minerals;
  final List<Nutrients> aminoAcids;
  final List<Nutrients> fattyAcids;

  const NutrientsTable({
    Key? key, required this.vitamins, required this.minerals, required this.aminoAcids, required this.fattyAcids,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
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
        NutrientsGroup(list: vitamins),
        const Center(
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
        NutrientsGroup(list: minerals),
        const Center(
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
        NutrientsGroup(list: aminoAcids),
        const Center(
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
        NutrientsGroup(list: fattyAcids),
      ],
    );
  }
}