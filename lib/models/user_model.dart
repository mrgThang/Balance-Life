import 'dart:convert';

import '../services/api_service.dart';
import '../utils/common_functions.dart';

class User {
  final int id;
  String first_name;
  String last_name;
  final String imageUrl;
  final String role;
  int? customer_id;
  int? specialist_id;
  String caption;

  User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.imageUrl,
    required this.role,
    required this.customer_id,
    required this.specialist_id,
    required this.caption,
  });

  String get_full_name() {
    return '${first_name} ${last_name}';
  }
}

User? currentUser;
User? customer;
User? specialist;
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
    role: json['role'],
    customer_id: json['customer_id'],
    specialist_id: json['specialist_id'],
    caption: json['caption'],
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

  String getRole = currentUser!.role == "Specialist" ? "Normal" : "Specialist";

  var res = await sendPostRequest(endpoint: "get_users/", body: {
    "role": getRole,
  });

  var jsonRes = jsonDecode(res);
  userList = json_to_users(jsonRes);
  for (var user in userList) {
    user_by_id[user.id] = user;
  }
  print("GET users: ${res}");
  return userList;
}

Future<User> login({required body}) async {
  var res = await sendPostRequest(
    endpoint: "accounts/login/",
    body: body,
  );
  print(res);
  var jsonRes = jsonDecode(res);
  currentUser = User(
    id: jsonRes['user_id'],
    first_name: jsonRes['first_name'],
    last_name: jsonRes['last_name'],
    imageUrl: 'http://' + url + jsonRes['profile_image'],
    role: jsonRes['role'],
    customer_id: jsonRes['customer_id'],
    specialist_id: jsonRes['specialist_id'],
    caption: jsonRes['caption'],
  );
  if (jsonRes['role'] == "Specialist") {
    if (jsonRes["customer_id"] != null)
      customer = await getUser(body: {"user_id": jsonRes["customer_id"]});
  } else {
    if (jsonRes["specialist_id"] != null)
      specialist = await getUser(body: {"user_id": jsonRes["specialist_id"]});
  }
  user_by_id[currentUser!.id] = currentUser!;
  return currentUser!;
}

Future<User> getUser({required body}) async {
  print(body);
  var res = await sendPostRequest(
    endpoint: "accounts/profile/",
    body: body,
  );
  var jsonRes = jsonDecode(res);
  print(jsonRes);

  return User(
    id: jsonRes['id'],
    first_name: jsonRes['first_name'],
    last_name: jsonRes['last_name'],
    imageUrl: 'http://' + url + jsonRes['profile_image'],
    role: jsonRes['role'],
    customer_id: jsonRes['customer_id'],
    specialist_id: jsonRes['specialist_id'],
    caption: jsonRes['caption'],
  );
}
