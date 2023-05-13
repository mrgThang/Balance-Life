import 'dart:convert';
import 'dart:io' as io;

import 'package:app/models/ingredient.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/user_model.dart';

const URL = 'http://10.0.2.2:8000/';
var url = '10.0.2.2:8000';

Future<dynamic> getDetailIngredient(String ingredient) async {
  final url = Uri.parse('${URL}ingredients/');
  Map<String, dynamic> data = {
    "page": 1,
    "pageSize": 10,
    "show_details": true,
    "search_input": ingredient
  };
  final response = await http.post(
    url,
    headers: <String, String> {
      'Content-type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if(response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body)[0];
  } else {
    print('Get detail ingredient failed with status: ${response.statusCode}');
  }
}

Future<dynamic> createFoods(Food food) async {
  final url = Uri.parse('${URL}foods/create/');
  Map<String, dynamic> data = {
    "food_name": food.name,
    "food_description": food.description,
    "user_id": currentUser?.id,
    "ingredient_set": []
  };
  for(Ingredient i in food.ingredients) {
    data["ingredient_set"].add(
        {
          "ingredient_name": i.name,
          "amount": (i.serving * i.adjustFraction).round()
        }
    );
  }
  final response = await http.post(
    url,
    headers: <String, String> {
      'Content-type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if(response.statusCode == 200) {
    print(jsonDecode(response.body));
    return jsonDecode(response.body)["data"]["id"];
  } else {
    print('Create food failed with status: ${response.statusCode}');
  }
}

Future<dynamic> getAllFoods() async {
  Map<String, dynamic> data = {
    "show_details": true,
    "show_total": false,
    "search_input": "",
    "page": 1,
    "page_size": 100
  };
  var res = await sendPostRequest(
    endpoint: "foods/",
    body: data,
  );
  var jsonRes = jsonDecode(res);
  return jsonRes;
}


Future<dynamic> uploadImageForTheFood(Food food, int foodId, String imagePath) async {
  final url = Uri.parse('${URL}foods/$foodId/upload_image/');
  final bytes = io.File(imagePath).readAsBytesSync();
  String img64 = base64Encode(bytes);

  Map<String, dynamic> data = {
    "file": {
      "filename": "${food.name}.jpeg",
      "content": img64
    }
  };
  final response = await http.post(
    url,
    headers: <String, String> {
      'Content-type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if(response.statusCode == 200) {
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  } else {
    print('Upload food image failed with status: ${response.statusCode}');
  }
}


Future<dynamic> getMealsByDate({required int userId, required DateTime date,
  required bool showDetails, required bool showTotals}) async {
  Map<String, dynamic> data = {
    "user_id": userId,
    "search_input": "",
    "show_details": showDetails,
    "show_total": showTotals,
    "date": DateFormat('dd-MM-yyyy').format(date).toString()
  };
  var res = await sendPostRequest(
    endpoint: "/meals/bydate/",
    body: data,
  );
  var jsonRes = jsonDecode(res);
  return jsonRes;
}

Future<dynamic> updateMeals({Meal? meal}) async {
  if(meal == null) {
    return "Meal is null";
  }
  Map<String, dynamic> data = {
    "food_set": []
  };
  for(Food food in meal.foodList) {
    data["food_set"].add({
      "food_id": food.foodId,
      "amount": 100
    });
  }
  var res = await sendPutRequest(
    endpoint: "/meals/${meal.mealId}/update/",
    body: data,
  );
  return res;
}

Future<String> sendPostRequest({endpoint, body}) async {
  final headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  try {
    final response = await http.post(Uri.http(url, endpoint),
        headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) throw Exception(response.body);
    return response.body;
  } catch (e) {
    debugPrint(e.toString());
    return e.toString();
  }
}

Future<String> sendPutRequest({endpoint, body}) async {
  final headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  try {
    final response = await http.put(Uri.http(url, endpoint),
        headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) throw Exception(response.body);
    return response.body;
  } catch (e) {
    debugPrint(e.toString());
    return e.toString();
  }
}
