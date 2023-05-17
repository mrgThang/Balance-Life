import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

bool isDarkMode = false;
bool isMoreDetails = false;
List<String> languageList = ["English", "Tiếng Việt"];
String dropdownValue = languageList.first;
int limitCalories = 2250;
int limitFats = 68;
int limitCarbs = 243;
int limitProtein = 213;

class _SettingsPage extends State<SettingsPage> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings Page",
          style: TextStyle(
            color: Color(0xff707070),
          )
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2, color: Color(0xff707070)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: isDarkMode == false ? const OffButton() : const OnButton(),
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "More Details",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: isMoreDetails == false ? const OffButton() : const OnButton(),
                    onTap: () {
                      setState(() {
                        isMoreDetails = !isMoreDetails;
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Language",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    alignment: const Alignment(1, 0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: languageList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Limited Calories",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 90,
                    alignment: const Alignment(1, 0),
                    child: TextField(
                      controller: controller1,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "$limitCalories"
                      ),
                      onEditingComplete: () {
                        if (controller1.text != "") {
                          setState(() {
                            limitCalories = int.parse(controller1.text);
                            controller1.text = "";
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Limited Fats",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 90,
                    alignment: const Alignment(1, 0),
                    child: TextField(
                      controller: controller2,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "$limitFats"
                      ),
                      onEditingComplete: () {
                        if (controller2.text != "") {
                          setState(() {
                            limitFats = int.parse(controller2.text);
                            controller2.text = "";
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Limited Carbs",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 90,
                    alignment: const Alignment(1, 0),
                    child: TextField(
                      controller: controller3,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "$limitCarbs"
                      ),
                      onEditingComplete: () {
                        if (controller3.text != "") {
                          setState(() {
                            limitCarbs = int.parse(controller3.text);
                            controller3.text = "";
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    alignment: const Alignment(-1, 0),
                    child: const Text(
                      "Limited Protein",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 90,
                    alignment: const Alignment(1, 0),
                    child: TextField(
                      controller: controller4,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "$limitProtein"
                      ),
                      onEditingComplete: () {
                        if (controller4.text != "") {
                          setState(() {
                            limitProtein = int.parse(controller4.text);
                            controller4.text = "";
                          });
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OffButton extends StatelessWidget {
  const OffButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 30,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class OnButton extends StatelessWidget {
  const OnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 30,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}