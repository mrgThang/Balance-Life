import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class PlanPage extends StatefulWidget {
  final String? label;
  const PlanPage({super.key, this.label});

  @override
  State<PlanPage> createState() => _PlanPage();
}

class _PlanPage extends State<PlanPage> {
  TextEditingController nameController = TextEditingController();
  List<String> searchList = [];
  List<String> chosenList = [];

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
            Container(
              height: 50,
              width: 340,
              decoration: BoxDecoration(
                color: const Color(0xffe1e1e1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xffa7a7a7),
                ),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xffa7a7a7),
                    size: 40.0,
                  ),
                  hintText: "What do you want to eat today?",
                  hintStyle: TextStyle(
                    color: Color(0xffa7a7a7),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  List<String> d = [];
                  if (query.isNotEmpty) {
                    for (var i = 0; i < INGREDIENTS_DATA.length; i++) {
                      String a = INGREDIENTS_DATA[i].toLowerCase();
                      String b = query.toLowerCase();
                      if (a.contains(b)) {
                        d.add(INGREDIENTS_DATA[i]);
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
                  for (var i = 0; i < chosenList.length; i++) ChosenFood(label: chosenList[i])
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: const Alignment(-0.8, -1),
              child: const Text(
                "Search Results",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (var i = 0; i < searchList.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (chosenList.contains(searchList[i])) {} else {chosenList.add(searchList[i]);}
                        });
                      },
                      child: Text(
                        searchList[i],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward, size: 25),
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

class ChosenFood extends StatelessWidget {
  final String label;
  const ChosenFood({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: const Alignment(-0.9, -1),
                child: Text(
                  label,
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