import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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