import 'package:app/models/message_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/widgets/recent_chats.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/constants.dart';
import 'package:app/widgets/contacts_widget.dart';
import 'search_contacts_page.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({
    super.key,
    required this.context,
    required this.chatRooms,
  });

  final BuildContext context;
  final List<ChatRoom> chatRooms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: currentUser != null
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SizedBox(
                            height: 50,
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
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                prefixIconColor: mColorScheme.icon,
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
}
