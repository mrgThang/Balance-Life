
import 'package:app/screens/create_screens/config_value_page.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../utils/constants.dart';

class EditIngredientsPage extends StatefulWidget {
  const EditIngredientsPage({super.key, required this.foodName});

  final String foodName;

  @override
  State<EditIngredientsPage> createState() => _EditIngredientsPage();
}

class _EditIngredientsPage extends State<EditIngredientsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.foodName,
            style: const TextStyle(
              color: Color(APP_COLORS.GREEN),
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2,
              color: Color(APP_COLORS.GRAY)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return INGREDIENTS_DATA.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) async {
          var data = await getDetailIngredient(selection);
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfigValuePage(
                  ingredientName: selection,
                  ingredientData: data,
                )),
          );
        },
      ),
    );
  }
}