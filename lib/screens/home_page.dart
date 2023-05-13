import 'package:app/models/meal.dart';
import 'package:app/screens/control_page.dart';
import 'package:app/screens/create_screens/settings_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../models/food.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/common_functions.dart';
import '../widgets/food_card.dart';
import '../widgets/nutrients_table.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;
  const HomePage({super.key, required this.camera});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  DailyMeals _customerDailyMeals = DailyMeals();
  Meal _customerBreakfast = Meal();
  Meal _customerLunch = Meal();
  Meal _customerDinner = Meal();

  Future<void> getMealsDataOfCustomer() async {
    var dailyMealsData = await getMealsByDate(userId: customer?.id ?? 0, date: DateTime.now(), showDetails: true, showTotals: true);
    _customerDailyMeals = createDailyMealsObjectFromJson(dailyMealsData);
    for(Meal meal in _customerDailyMeals.mealList) {
      if(meal.time == "Breakfast") {
        _customerBreakfast = meal;
      } else if(meal.time == "Lunch") {
        _customerLunch = meal;
      } else {
        _customerDinner = meal;
      }
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    if(currentUser?.role == "Specialist") {
      getMealsDataOfCustomer();
    }
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
                    onPressed: () {},
                  ),
                  const SizedBox(width: 80),
                  IconButton(
                    icon: const Icon(IconlyLight.calendar,size: 30, color: Color(0xff9b9b9b)),
                    onPressed: () {},
                  ),
                  const Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff9b9b9b),
                    ),
                  ),
                  const SizedBox(width: 80),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_outlined, size: 27, color: Color(0xff9b9b9b)),
                    onPressed: () {},
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
                        width: 350 * (limitCalories - 189) / limitCalories,
                        decoration: BoxDecoration(
                          color: const Color(0xff91c788),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 350,
                        alignment: const Alignment(0, 0),
                        child: const Text(
                          "189 Calories left",
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
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            "2242",
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
                            "200",
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
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            "2042",
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
                CircleNutrition(label: "Fats", color1: Colors.red, color2: const Color(0xfffff2f0), a: 56, b: limitFats),
                CircleNutrition(label: "Carbs", color1: Colors.green, color2: const Color(0xffeff7ee), a: 198, b: limitCarbs),
                CircleNutrition(label: "Protein", color1: Colors.yellow, color2: const Color(0xfffff8eb), a: 180, b: limitProtein),
              ],
            ),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerBreakfast.foodList) FoodCard(food: food)
                        ],
                      ),
                    ),
                  ),
                  const Align(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerLunch.foodList) FoodCard(food: food)
                        ],
                      ),
                    ),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (Food food in _customerDinner.foodList) FoodCard(food: food)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  NutrientsTable(
                    vitamins: _customerDailyMeals.getTotalVitamins(),
                    minerals: _customerDailyMeals.getTotalMinerals(),
                    aminoAcids: _customerDailyMeals.getTotalAminoAcids(),
                    fattyAcids: _customerDailyMeals.getTotalFattyAcids(),
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
