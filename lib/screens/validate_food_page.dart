import 'package:app/models/user_model.dart';
import 'package:app/screens/chat_screens/user_detail_page.dart';
import 'package:app/screens/view_food_page.dart';
import 'package:flutter/material.dart';

import '../models/food.dart';
import '../services/api_service.dart';

class ValidateFoodPage extends StatefulWidget {
  final List foodList;
  const ValidateFoodPage({
    super.key, required this.foodList,
  });

  @override
  State<ValidateFoodPage> createState() => _ValidateFoodPage();
}

class _ValidateFoodPage extends State<ValidateFoodPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              for (int i = 0; i < widget.foodList.length; i++)
                FoodCard(
                  food: widget.foodList[i],
                ),
            ]
          ),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  Food food;
  FoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 28, 8, 0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ViewFoodPage(food: food, command: "Yes"),
              transitionDuration: Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(-6, 10),
                blurRadius: 10,
                spreadRadius: 4,
              )
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 6, 12, 6),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      'http://10.0.2.2:8000${food.imageUrl}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            food.name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            food.description,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
