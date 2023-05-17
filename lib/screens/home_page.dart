import 'package:app/models/meal.dart';
import 'package:app/screens/control_page.dart';
import 'package:app/screens/create_screens/settings_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/common_functions.dart';
import '../widgets/food_card.dart';
import '../widgets/nutrients_table.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  const HomePage({super.key, required this.camera, this.restorationId});

  final String? restorationId;


  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  DailyMeals _dailyMeals = DailyMeals();
  Meal _customerBreakfast = Meal();
  Meal _customerLunch = Meal();
  Meal _customerDinner = Meal();

  final RestorableDateTime _selectedDate =
  RestorableDateTime(currentDate);
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
      await getMealsData();
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

  Future<void> getMealsData() async {
    _dailyMeals = DailyMeals();
    _customerBreakfast = Meal();
    _customerLunch = Meal();
    _customerDinner = Meal();
    int? userId = currentUser?.role == "Normal" ? currentUser?.id : customer?.id;
    var dailyMealsData = await
      getMealsByDate(userId: userId ?? 0, date: currentDate, showDetails: true, showTotals: true);
    List<DailyMeals> listDailyMeals = createDailyMealsObjectFromJson(dailyMealsData);
    for (DailyMeals dailyMeals in listDailyMeals) {
      if(dailyMeals.mealList.isNotEmpty) {
        _dailyMeals = dailyMeals;
      }
    }
    for(Meal meal in _dailyMeals.mealList) {
      if(meal.time == "Breakfast") {
        _customerBreakfast = meal;
      } else if(meal.time == "Lunch") {
        _customerLunch = meal;
      } else {
        _customerDinner = meal;
      }
    }
    _dailyMeals.getTotalMacroNutrientsValue();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getMealsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Visibility(
              visible: currentUser?.role == "Specialist",
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Text(
                  "${customer?.get_full_name() ?? ""} Profile",
                  style: const TextStyle(
                    color: Color(0xff91c788),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined, size: 27, color: Color(0xff9b9b9b)),
                    onPressed: () async {
                      currentDate = currentDate.subtract(Duration(days: 1));
                      await getMealsData();
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
                      await getMealsData();
                      setState(() {

                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                color: const Color(0xffeff7ee),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width:
                        (limitCalories > _dailyMeals.getTotal("Calories")) ?
                        350 * _dailyMeals.getTotal("Calories") / limitCalories :
                        350,
                        decoration: BoxDecoration(
                          color: const Color(0xff91c788),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 350,
                        alignment: const Alignment(0, 0),
                        child: Text(
                          (limitCalories > _dailyMeals.getTotal("Calories")) ?
                          "${(limitCalories - _dailyMeals.getTotal("Calories")).toStringAsFixed(0)} Calories left" :
                          "You have exceeded max Calories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            _dailyMeals.getTotal("Calories").toStringAsFixed(0),
                            style: TextStyle(
                              color: Color(0xff8edd5f),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Consumed",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            "0",
                            style: TextStyle(
                              color: Color(0xffd75a5a),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Burned",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            _dailyMeals.getTotal("Calories").toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Net",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: currentUser?.role == "Normal",
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Text(
                      "Your Plan",
                      style: TextStyle(
                        color: Color(0xff91c788),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Plan(
                    linkImage:
                        "https://reviewed-com-res.cloudinary.com/image/fetch/s---oGP6J6d--/b_white,c_fill,cs_srgb,f_auto,fl_progressive.strip_profile,g_auto,h_729,q_auto,w_972/https://reviewed-production.s3.amazonaws.com/1568123038734/Bfast.png",
                    label: "Breakfast",
                    x: 0.8,
                    y: 0.9,
                    camera: widget.camera,
                  ),
                  Plan(
                    linkImage:
                        "https://img.vietcetera.com/wp-content/uploads/2017/07/Local-Lunch-Featured.jpg",
                    label: "Lunch",
                    x: -0.5,
                    y: 0.9,
                    camera: widget.camera,
                  ),
                  Plan(
                    linkImage:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeml6HU53NPLRy_90C9RRb9-O0gBEQnYB5OA&usqp=CAU",
                    label: "Dinner",
                    x: 0.8,
                    y: 0.9,
                    camera: widget.camera,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Text(
                "Food Diary",
                style: TextStyle(
                  color: Color(0xff91c788),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleNutrition(label: "Fats", color1: Colors.red, color2: const Color(0xfffff2f0), a: _dailyMeals.getTotal("Fat").toInt(), b: limitFats),
                CircleNutrition(label: "Carbs", color1: Colors.green, color2: const Color(0xffeff7ee), a: _dailyMeals.getTotal("Carbohydrates").toInt(), b: limitCarbs),
                CircleNutrition(label: "Protein", color1: Colors.yellow, color2: const Color(0xfffff8eb), a: _dailyMeals.getTotal("Proteins").toInt(), b: limitProtein),
              ],
            ),
            SizedBox(height: 50),
            Visibility(
              visible: currentUser?.role == "Specialist",
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 30),
                      child: Text(
                        "Breakfast",
                        style: TextStyle(
                          color: Color(0xff91c788),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_customerBreakfast.foodList.length > 0) Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerBreakfast.foodList) FoodCard(food: food, callback: setState,)
                        ],
                      ),
                    ),
                  ) else Text(
                    "No food yet.",
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 30),
                      child: Text(
                        "Lunch",
                        style: TextStyle(
                          color: Color(0xff91c788),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_customerLunch.foodList.length > 0) Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerLunch.foodList) FoodCard(food: food, callback: setState)
                        ],
                      ),
                    ),
                  ) else Text (
                    "No food yet.",
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 30),
                      child: Text(
                        "Dinner",
                        style: TextStyle(
                          color: Color(0xff91c788),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_customerDinner.foodList.length > 0) Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerDinner.foodList) FoodCard(food: food, callback: setState)
                        ],
                      ),
                    ),
                  ) else Text(
                    "No food yet.",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: _dailyMeals.mealList.isNotEmpty,
                    child: NutrientsTable(
                      vitamins: _dailyMeals.getTotalVitamins(),
                      minerals: _dailyMeals.getTotalMinerals(),
                      aminoAcids: _dailyMeals.getTotalAminoAcids(),
                      fattyAcids: _dailyMeals.getTotalFattyAcids(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Plan extends StatelessWidget {
  final CameraDescription camera;
  final String linkImage;
  final String label;
  final double x;
  final double y;
  const Plan({
    Key? key,
    required this.linkImage,
    required this.label,
    required this.x,
    required this.y,
    required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlPage(
              plan: label,
              camera: camera,
              i: 1,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Stack(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                linkImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 100,
              alignment: Alignment(x, y),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleNutrition extends StatelessWidget {
  final String label;
  final Color color1;
  final Color color2;
  final int a;
  final int b;
  const CircleNutrition({
    Key? key,
    required this.label,
    required this.color1,
    required this.color2,
    required this.a,
    required this.b
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(color1),
              value: a / b,
            ),
          ),
          Text(
            "$a/${b}g",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
