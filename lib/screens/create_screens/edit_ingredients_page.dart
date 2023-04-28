import 'package:app/screens/create_screens/config_value_page.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../utils/constants.dart';
import '../../models/ingredient.dart';

class EditIngredientsPage extends StatefulWidget {
  const EditIngredientsPage({super.key, required this.foodName});

  final String foodName;

  @override
  State<EditIngredientsPage> createState() => _EditIngredientsPage();
}

class _EditIngredientsPage extends State<EditIngredientsPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    List<Ingredient> _ingredients = <Ingredient>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName,
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
      body: Column(children: [
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
                    onPressed: () {
                      setState(() {
                        print("length: ${_ingredients.length}");
                      });
                    },
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
              _ingredients = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigValuePage(
                    ingredientName: selection,
                    ingredientData: data,
                    ingredientList: _ingredients,
                  ),
                )
              );
              setState(() {
                print("length: ${_ingredients.length}");
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              final String name = _ingredients.elementAt(index).name;
              return Text(name);
            },
          ),
        ),
      ]),
    );
  }
}
