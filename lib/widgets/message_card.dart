import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class MessageCard extends StatefulWidget {
  MessageCard({super.key, required this.message, this.seenby = const []});

  final Message message;
  final List<User> seenby;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = currentUser!.id == widget.message.sender.id;
    print(widget.seenby.length);
    return Row(
      children: [
        Expanded(child: isMe ? _myMessage() : _otherMessage()),
        (widget.seenby.isNotEmpty
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(widget.seenby[0].imageUrl),
                ),
              )
            : SizedBox(width: 16, height: 16)),
        SizedBox(
          width: 8.0,
        ),
      ],
    );
  }

  Widget _myMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            processMessageTime(widget.message.time),
            style: TextStyle(fontSize: 13, color: mColorScheme.text_normal),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: mColorScheme.message_card_border,
              border: Border.all(
                color: mColorScheme.message_card,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: (widget.message.messageType == "Text"
                ? Text(
                    widget.message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: mColorScheme.text_message,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.content,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                    ),
                  )),
          ),
        ),
      ],
    );
  }

  Widget _otherMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: mColorScheme.oppose_message_card_border,
              border: Border.all(
                color: mColorScheme.oppose_message_card,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: (widget.message.messageType == "Text"
                ? Text(
                    widget.message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: mColorScheme.text_message,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.content,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                    ),
                  )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            processMessageTime(widget.message.time),
            style: TextStyle(fontSize: 13, color: mColorScheme.text_normal),
          ),
        ),
      ],
    );
  }
}
