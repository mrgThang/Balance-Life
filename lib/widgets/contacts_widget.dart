import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../screens/chat_screens/chat_page.dart';
import '../utils/constants.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        height: 130,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 10.0),
          scrollDirection: Axis.horizontal,
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index) {
            final User user = userList[index];
            ChatRoom chatroom = ChatRoom(title: '${user.get_full_name()}');
            chatroom.user = userList[index];
            return GestureDetector(
              onTapUp: (details) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(chatroom: chatroom),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      backgroundImage: NetworkImage(userList[index].imageUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(height: 6.0),
                    Text(
                      '${user.get_full_name()}',
                      style: TextStyle(
                        color: mColorScheme.text_normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
