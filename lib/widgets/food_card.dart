import 'package:app/models/meal.dart';
import 'package:app/screens/view_food_page.dart';
import 'package:flutter/material.dart';

import '../models/food.dart';
import '../services/api_service.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final Meal? meal;
  final Function callback;
  FoodCard({
    Key? key,
    required this.food, this.meal, required this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ViewFoodPage(food: food, command: "Remove", foodList: meal?.foodList),
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
        await updateMeals(meal: meal);
        callback();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xfff4f4f4),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: food.imageUrl != ""
                    ? Image.network(
                        'http://10.0.2.2:8000${food.imageUrl}',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 200,
                      )
                    : null,
              ),
              const SizedBox(height: 5),
              Container(
                alignment: const Alignment(-0.9, -1),
                child: Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
