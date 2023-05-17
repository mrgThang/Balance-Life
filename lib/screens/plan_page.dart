import 'package:app/screens/view_food_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';
import '../widgets/food_card.dart';

class PlanPage extends StatefulWidget {
  final String? label;
  const PlanPage({super.key, this.restorationId, this.label});

  final String? restorationId;


  @override
  State<PlanPage> createState() => _PlanPage();
}

class _PlanPage extends State<PlanPage> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  TextEditingController nameController = TextEditingController();
  List<dynamic> searchList = [];
  List<String> chosenList = [];
  List<dynamic> foodList = [];
  Meal _meal = Meal();
  List<String> list = <String>['Breakfast', 'Lunch', 'Dinner'];
  String dropdownValue = 'Breakfast';

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2022),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  Future<void> _selectDate(DateTime? newSelectedDate) async {
    if (newSelectedDate != null) {
      currentDate = newSelectedDate;
      if(currentUser?.role == "Specialist") {
        await getMealsDataOfUser();
      }
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  String getDisplayOfDate() {
    if (DateFormat.yMd().format(currentDate).toString()
        == DateFormat.yMd().format(DateTime.now()).toString()) {
      return "Today";
    }
    return DateFormat.yMd().format(currentDate).toString();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  Future<void> getMealsDataOfUser() async {
    var dailyMealsData = await getMealsByDate(userId: currentUser?.id ?? 0, date: currentDate, showDetails: true, showTotals: true);
    List<DailyMeals> listDailyMeals = createDailyMealsObjectFromJson(dailyMealsData);
    DailyMeals customerDailyMeals = DailyMeals();
    for (DailyMeals dailyMeals in listDailyMeals) {
      if(dailyMeals.mealList.isNotEmpty) {
        customerDailyMeals = dailyMeals;
      }
    }
    _meal = Meal();
    for(Meal meal in customerDailyMeals.mealList) {
      if(meal.time == (dropdownValue ?? 'Breakfast')) {
        _meal = meal;
      }
    }
    setState(() {

    });
  }

  void setAllState() {
    setState((){});
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
    dropdownValue = (widget.label ?? 'Breakfast')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Visibility(
              visible: currentUser?.role == "Normal",
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_outlined, size: 27, color: Color(0xff9b9b9b)),
                      onPressed: () async {
                        currentDate = currentDate.subtract(Duration(days: 1));
                        await getMealsDataOfUser();
                        setState(() {

                        });
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(IconlyLight.calendar,size: 30, color: Color(0xff9b9b9b)),
                            onPressed: () {
                              _restorableDatePickerRouteFuture.present();
                            }
                        ),
                        Text(
                          getDisplayOfDate(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff9b9b9b),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_outlined, size: 27, color: Color(0xff9b9b9b)),
                      onPressed: () async {
                        currentDate = currentDate.add(Duration(days: 1));
                        await getMealsDataOfUser();
                        setState(() {

                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: currentUser?.role == "Normal",
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(
                  color: Color(APP_COLORS.GREEN),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String? value) async {
                  dropdownValue = value!;
                  await getMealsDataOfUser();
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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