import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:app/models/message_model.dart';
import 'package:app/screens/chat_screens/search_contacts_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:app/services/api_service.dart';
import 'package:app/models/user_model.dart';
import 'package:app/widgets/contacts_widget.dart';
import 'package:app/widgets/recent_chats.dart';

class ChatHomePage extends StatefulWidget {
  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  late WebSocketChannel channel;
  late List<User> friendList;
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
    login().then((value) {
      getUserList().then((value) {
        connectWebSocket().then((value) {
          channel.sink.add(jsonEncode({
            "command": "get_all_chatrooms",
          }));
          channel.sink.add(jsonEncode({
            "command": "get_all_friends",
          }));
          channel.stream.listen((event) {
            print(event);
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 30.0,
          color: mColorScheme.icon,
          onPressed: () {},
        ),
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: mColorScheme.primary,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: currentUser != null
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextField(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchContactsPage(),
                                ),
                              );
                              FocusScope.of(context).unfocus();
                            },
                            style: TextStyle(
                              color: mColorScheme.text_normal,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: mColorScheme.icon,
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 50.0,
                                minHeight: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Contacts(),
                        RecentChats(
                          chatRooms: chatRooms,
                        ),
                      ]
                    : [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }
}
