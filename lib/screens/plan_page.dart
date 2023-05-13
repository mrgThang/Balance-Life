import 'package:app/screens/view_food_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';
import '../widgets/food_card.dart';

class PlanPage extends StatefulWidget {
  final String? label;
  const PlanPage({super.key, this.label});

  @override
  State<PlanPage> createState() => _PlanPage();
}

class _PlanPage extends State<PlanPage> {
  TextEditingController nameController = TextEditingController();
  List<dynamic> searchList = [];
  List<String> chosenList = [];
  List<dynamic> foodList = [];
  Meal _meal = Meal();

  Future<void> getMealsDataOfUser() async {
    var dailyMealsData = await getMealsByDate(userId: currentUser?.id ?? 0, date: DateTime.now(), showDetails: true, showTotals: true);
    DailyMeals customerDailyMeals = createDailyMealsObjectFromJson(dailyMealsData);
    for(Meal meal in customerDailyMeals.mealList) {
      if(meal.time == (widget.label ?? "Breakfast")) {
        _meal = meal;
      }
    }
    setState(() {

    });
  }

  void setAllState() {
    setState((){print(11111);});
  }

  Future<void> getAllFoodsForSearching() async {
    foodList = await getAllFoods();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    if(currentUser?.role == "Normal") {
      getMealsDataOfUser();
      getAllFoodsForSearching();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.label ?? "Breakfast",
                style: const TextStyle(
                  color: Color(0xff91c788),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
                MediaQuery.of(context).size.width * 0.1,
                MediaQuery.of(context).size.height * 0.004,
              ),
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xffa7a7a7),
                ),
                decoration: InputDecoration(
                  hintText: "Search for foods",
                  hintStyle: const TextStyle(color: Colors.grey),
                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: const Icon(IconlyBold.close_square),
                    onPressed: () {
                      searchList = [];
                      nameController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {

                      });
                    }
                  ),
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: const Icon(IconlyLight.search),
                    onPressed: () {},
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true, //<-- SEE HERE
                  fillColor: const Color(APP_COLORS.SEARCH_BAR_THEME),
                ),
                onChanged: (query) {
                  List<dynamic> d = [];
                  if (query.isNotEmpty) {
                    for (var i = 0; i < foodList.length; i++) {
                      String a = foodList[i]["food_name"].toLowerCase();
                      String b = query.toLowerCase();
                      if (a.startsWith(b)) {
                        d.add(foodList[i]);
                      }
                    }
                  }
                  setState(() {
                    searchList = d;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: const Alignment(-0.8, -1),
              child: const Text(
                "Search Food",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: searchList.isEmpty,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
                child: Text(
                  "No Results",
                  style: TextStyle(
                    color: Color(APP_COLORS.GREEN),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ),
            Visibility(
              visible: searchList.isNotEmpty,
              child: Column(
                children: [
                  for (var i = 0; i < searchList.length; i++)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                                _meal.foodList = await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => ViewFoodPage(
                                      food: createFoodObjectFromJson(searchList[i]),
                                      command: "Add",
                                      foodList: _meal.foodList,
                                    ),
                                    transitionDuration: const Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
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
                                await updateMeals(meal: _meal);
                                setState(() {

                                });
                              },
                            child: Text(
                              searchList[i]["food_name"],
                              style: const TextStyle(
                                color: Color(APP_COLORS.GREEN),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward, size: 25),
                            color: const Color(APP_COLORS.GREEN),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              alignment: const Alignment(-0.8, -1),
              child: const Text(
                "Your chosen food",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (Food food in _meal.foodList) FoodCard(food: food, meal: _meal, callback: setAllState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}