import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/models/user_model.dart';

import '../services/api_service.dart';

class Message {
  final int id;
  final User sender;
  final String time;
  bool isLiked;
  final String content;
  final String messageType;

  Message({
    required this.id,
    required this.sender,
    required this.time,
    required this.content,
    required this.messageType,
    this.isLiked = false,
  });
}

class ChatRoom {
  int? id;
  String? roomName;
  Message? last_message;
  int? last_user;
  String? last_timestamp;
  String title;
  bool isGroupChat = false;
  User? user;
  Map<int, int?> lastMessageRead = {};

  ChatRoom({
    this.id,
    required this.title,
    this.last_message,
    this.last_user,
    this.last_timestamp,
  });
}

Future<List<ChatRoom>> getChatRooms() async {
  var chatrooms = <ChatRoom>[];
  if (currentUser == null) {
    throw Exception("User must be logged in first to get their chatrooms.");
  }
  var res = await sendPostRequest(
    endpoint: "chat/get_chatrooms/",
    body: {
      "user_id": currentUser!.id,
    },
  );
  var jsonRes = jsonDecode(res);
  return chatrooms;
}

ChatRoom json_to_chatroom(json) {
  bool isGroupChat = false;
  String chatroomTitle = "";
  User? chatroomUser;
  debugPrint(json.toString());
  if (!isGroupChat) {
    for (var user_id in json['user_ids']) {
      if (user_id == currentUser!.id) continue;
      chatroomTitle =
          '${user_by_id[user_id]!.first_name} ${user_by_id[user_id]!.last_name}';
      chatroomUser = user_by_id[user_id];
      break;
    }
  }
  ChatRoom chatroom = ChatRoom(
    id: json['id'],
    title: chatroomTitle,
    last_message: json_to_message(json['last_message_sent']),
    last_user: json['last_message_sent']['author']['id'],
    last_timestamp: json['last_message_sent']['timestamp'],
  );
  chatroom.roomName = json['name'];
  chatroom.user = chatroomUser;

  for (var user_id in json['user_ids']) {
    print('${user_id} ${json['last_message_read'][user_id.toString()]}');
    chatroom.lastMessageRead[user_id] =
        json['last_message_read'][user_id.toString()];
  }

  return chatroom;
}

List<ChatRoom> json_to_chatrooms(json) {
  List<ChatRoom> chatrooms = [];
  for (var chatroomJson in json) {
    ChatRoom chatroom = json_to_chatroom(chatroomJson);
    chatrooms.add(chatroom);
  }
  return chatrooms;
}

Message json_to_message(json) {
  Message message = Message(
    id: json['id'],
    sender: user_by_id[json['author']['id']]!,
    time: json['timestamp'].toString(),
    messageType: json['message_type'].toString(),
    content:
        (json['message_type'].toString() == 'Text' ? '' : "http://" + url) +
            json['content'].toString(),
  );

  return message;
}

List<Message> json_to_messages(json) {
  List<Message> ret = [];
  for (var messageJson in json) {
    Message message = json_to_message(messageJson);
    ret.add(message);
  }

  return ret;
}
