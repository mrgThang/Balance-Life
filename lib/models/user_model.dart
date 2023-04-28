import 'dart:convert';

import '../services/api_service.dart';
import '../utils/common_functions.dart';

class User {
  final int id;
  String first_name;
  String last_name;
  final String imageUrl;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.imageUrl,
  });

  String get_full_name() {
    return '${first_name} ${last_name}';
  }
}

User? currentUser;
List<User> userList = [];
Map<int, User> user_by_id = {};

User json_to_user(json) {
  var noavatarpicture = 'http://${url}images/profile_image/noavatar.png';
  var imageUrl = noavatarpicture;
  if (json['profile_image'] != null) {
    imageUrl = 'http://$url${json['profile_image']}';
  }
  User user = User(
    id: json['id'],
    first_name: json['first_name'],
    last_name: json['last_name'],
    imageUrl: imageUrl,
  );
  return user;
}

List<User> json_to_users(json) {
  List<User> users = [];
  for (var userjson in json) {
    var user = json_to_user(userjson);
    if (user.id != currentUser!.id) {
      users.add(user);
    }
  }
  return users;
}

Future<List<User>> getUserList() async {
  if (currentUser == null) {
    throw Exception("User must be logged in first to get list of other users.");
  }
  var res = await sendPostRequest(endpoint: "get_users/", body: {});

  var jsonRes = jsonDecode(res);
  userList = json_to_users(jsonRes);
  for (var user in userList) {
    user_by_id[user.id] = user;
  }
  return userList;
}

Future<User> login() async {
  var res = await sendPostRequest(
    endpoint: "accounts/login/",
    body: {
      "email": "thangg@gmail.com",
      "password": "1"
    },
  );
  print("DEBUG");
  print(res);
  var jsonRes = jsonDecode(res);
  currentUser = User(
    id: jsonRes['user_id'],
    first_name: jsonRes['first_name'],
    last_name: jsonRes['last_name'],
    imageUrl: 'http://' + url + jsonRes['profile_image'],
  );
  user_by_id[currentUser!.id] = currentUser!;
  return currentUser!;
}
