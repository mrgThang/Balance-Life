import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:app/models/message_model.dart';
import 'package:app/screens/chat_screens/search_contacts_page.dart';
import 'package:iconly/iconly.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:app/services/api_service.dart';
import 'package:app/models/user_model.dart';
import 'package:app/widgets/contacts_widget.dart';
import 'package:app/widgets/recent_chats.dart';

import 'chatrooms_page.dart';
import 'choose_users_page.dart';

class ChatHomePage extends StatefulWidget {
  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  late WebSocketChannel channel;
  late List<User> friendList;
  late List<Widget> _children;
  late List<Icon> _currentIcon;
  late List<String> _currentTitle;
  int _currentIndex = 1;

  List<ChatRoom> chatRooms = [];

  Future<int> connectWebSocket() async {
    var roomName = currentUser!.id.toString();
    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://' + url + "/ws/chatrooms/" + roomName + "/",
      ),
    );
    debugPrint('ws://' + url + "/ws/chatrooms/" + roomName + "/");

    return 0;
  }

  @override
  void initState() {
    super.initState();

    connectWebSocket().then((value) {
      channel.sink.add(jsonEncode({
        "command": "get_all_chatrooms",
      }));
      channel.sink.add(jsonEncode({
        "command": "get_all_friends",
      }));
      channel.stream.listen((event) {
        // print(event);
        var jsonRes = jsonDecode(event);
        if (jsonRes['command'] == 'get_all_chatrooms') {
          chatRooms = json_to_chatrooms(jsonRes['chatrooms']);
          setState(() {});
        }
        if (jsonRes['command'] == 'reload_chatroom_by_id') {
          var chatroom = json_to_chatroom(jsonRes['chatroom']);
          var contains = false;
          for (int i = 0; i < chatRooms.length; i++) {
            if (chatRooms[i].id == chatroom.id!) {
              chatRooms[i] = chatroom;
              contains = true;
            }
          }
          if (!contains) {
            chatRooms.add(chatroom);
          }
          setState(() {});
        }
      });
      setState(() {});
    });

    _children = [
      ChooseUserPage(),
      ChatRoomPage(context: context, chatRooms: chatRooms),
    ];
    _currentIcon = [
      Icon(IconlyLight.chat),
      Icon(IconlyLight.user),
    ];
    _currentTitle = [
      currentUser == null
          ? ""
          : currentUser?.role == "Normal"
              ? "Experts"
              : "Customers",
      "Chats",
    ];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    _children = [
      ChooseUserPage(),
      ChatRoomPage(context: context, chatRooms: chatRooms),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          _currentTitle[_currentIndex],
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: mColorScheme.primary,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: _currentIcon[_currentIndex],
            iconSize: 30.0,
            onPressed: () {
              setState(() {
                _currentIndex = 1 - _currentIndex;
              });
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
