import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../screens/chat_screens/chat_page.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key, required this.chatRooms});

  final List<ChatRoom> chatRooms;
  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          itemCount: widget.chatRooms.length,
          itemBuilder: (context, index) {
            final ChatRoom chatroom = widget.chatRooms[index];
            String lastTime = processLastTime(chatroom.last_timestamp!);
            print(chatroom.lastMessageRead.toString());
            bool unread = chatroom.lastMessageRead[currentUser!.id] !=
                chatroom.last_message?.id;
            FontWeight fontWeight =
                unread ? FontWeight.bold : FontWeight.normal;
            Color textColor = unread
                ? mColorScheme.message_unseen
                : mColorScheme.message_seen;
            return GestureDetector(
              onTapUp: (details) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(chatroom: chatroom),
                ),
              ).then((value) {}),
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                padding: EdgeInsets.only(left: 15.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(
                              widget.chatRooms[index].user!.imageUrl),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.chatRooms[index].title!,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18.0,
                                fontWeight: fontWeight,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                widget.chatRooms[index].last_message!
                                            .messageType ==
                                        "Text"
                                    ? "${(widget.chatRooms[index].last_user != currentUser!.id ? "${user_by_id[widget.chatRooms[index].last_user]!.first_name}" : "You")}: ${widget.chatRooms[index].last_message!.content}"
                                    : (widget.chatRooms[index].last_user ==
                                            currentUser!.id
                                        ? "You sent an image."
                                        : "${widget.chatRooms[index].last_message!.sender.first_name} sent an image."),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 15.0,
                                  fontWeight: fontWeight,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          lastTime,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: fontWeight,
                          ),
                        ),
                      ],
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
