import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
                        width: 350 * 0.9, // % calo left sẽ đổi ở đây
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
            const Plan(linkImage: "https://reviewed-com-res.cloudinary.com/image/fetch/s---oGP6J6d--/b_white,c_fill,cs_srgb,f_auto,fl_progressive.strip_profile,g_auto,h_729,q_auto,w_972/https://reviewed-production.s3.amazonaws.com/1568123038734/Bfast.png", label: "Breakfast", x: 0.8, y: 0.9),
            const Plan(linkImage: "https://img.vietcetera.com/wp-content/uploads/2017/07/Local-Lunch-Featured.jpg", label: "Lunch", x: -0.5, y: 0.9),
            const Plan(linkImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeml6HU53NPLRy_90C9RRb9-O0gBEQnYB5OA&usqp=CAU", label: "Dinner", x: 0.8, y: 0.9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(IconlyBold.home, size: 40, color: Color(0xff91c788)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(IconlyLight.calendar, size: 40, color: Color(0xff9b9b9b)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(IconlyBold.camera, size: 40, color: Color(0xff91c788)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(IconlyLight.chat,size: 40, color: Color(0xff9b9b9b)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(IconlyLight.profile, size: 40, color: Color(0xff9b9b9b)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CircleNutrition(label: "Fats", color1: Colors.red, color2: Color(0xfffff2f0), a: 56, b: 68),
                CircleNutrition(label: "Carbs", color1: Colors.green, color2: Color(0xffeff7ee), a: 198, b: 243),
                CircleNutrition(label: "Fats", color1: Colors.yellow, color2: Color(0xfffff8eb), a: 180, b: 213),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Plan extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // navigate here
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
              child: Image.network( // Khi nào kết nối với backend thì đổi cái này
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
              backgroundColor: color2,
              valueColor: AlwaysStoppedAnimation<Color>(color1),
              // value: double.parse(a) / double.parse(b),
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