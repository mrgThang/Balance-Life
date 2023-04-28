import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:flutter/foundation.dart' as foundation;

import 'package:path/path.dart' as path;

import 'package:app/services/api_service.dart';
import 'package:app/models/message_model.dart';
import 'package:app/widgets/message_card.dart';

class ChatPage extends StatefulWidget {
  ChatRoom chatroom;
  ChatPage({super.key, required this.chatroom});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();
  bool _needScroll = false;
  bool _loadedMessages = false;
  bool _showEmoji = false;
  bool _isUploading = false;

  WebSocketChannel? channel;
  String roomName = "";
  List<Message> messageList = [];
  Future<int> connectChatroom() async {
    if (widget.chatroom.roomName == null) {
      var res =
          await sendPostRequest(endpoint: "chat/get_chatroom_name/", body: {
        "user_ids": [
          currentUser!.id,
          widget.chatroom.user!.id,
        ],
      });
      var jsonEvent = jsonDecode(res);
      roomName = jsonEvent['room_name'];
    } else
      roomName = widget.chatroom.roomName!;
    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://' + url + "/ws/chat/" + roomName + "/",
      ),
    );
    debugPrint('ws://' + url + "/ws/chat/" + roomName + "/");

    return 0;
  }

  void readMessages() {
    if (channel == null) return;
    channel!.sink.add(jsonEncode({
      "command": "read_messages",
      "user_id": currentUser!.id,
    }));
  }

  @override
  void initState() {
    super.initState();
    connectChatroom().then((value) {
      channel!.sink.add(
        jsonEncode({
          'command': 'fetch_messages',
        }),
      );
      channel!.stream.listen(
        (event) {
          var jsonEvent = jsonDecode(event);
          if (jsonEvent['command'] == "messages") {
            messageList = json_to_messages(jsonEvent['messages']);
            debugPrint("There are ${messageList.length.toString()} messages.");
            setState(() {
              _needScroll = true;
              _loadedMessages = true;
              readMessages();
            });
          } else if (jsonEvent['command'] == "new_message") {
            debugPrint(event);
            Message message = json_to_message(jsonEvent['message']);
            messageList.add(message);
            setState(() {
              _needScroll = true;
              readMessages();
            });
          } else if (jsonEvent['command'] == "reload_chatroom") {
            widget.chatroom = json_to_chatroom(jsonEvent['chatroom']);
            setState(() {});
          }
        },
      );
      setState(() {});
    });
  }

  Future<void> sendImageMessage(File imagefile) async {
    if (channel == null) return;
    Uint8List imagebytes = await imagefile.readAsBytes();
    String base64string = base64.encode(imagebytes);

    var send_data = {
      "command": "new_image_message",
      "file": {
        "filename": path.basename(imagefile.path),
        "content": base64string,
      },
      'message': {
        'author': currentUser!.id,
      },
      'target': widget.chatroom.user!.id,
    };
    channel!.sink.add(jsonEncode(send_data));
  }

  _sendMessage(message) {
    if (message == null || message == "") return;
    print(message);
    if (channel == null) return;
    channel!.sink.add(jsonEncode({
      'command': 'new_message',
      'message': {
        'author': currentUser!.id,
        'content': message,
      },
      'target': widget.chatroom.user!.id,
    }));
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = "";
    if (!widget.chatroom.isGroupChat) {
      imageUrl = widget.chatroom.user!.imageUrl;
    }
    if (messageList.isNotEmpty) {
      if (_needScroll) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _scrollDownSmooth());
        _needScroll = false;
      }
    } else {
      _needScroll = false;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  color: mColorScheme.icon,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(imageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${widget.chatroom.title}',
                        style: TextStyle(
                          color: mColorScheme.chat_header,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showEmoji = false;
            setState() {}
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _loadedMessages
                      ? (messageList.length > 0
                          ? ListView.builder(
                              controller: _controller,
                              padding: EdgeInsets.only(
                                top: 15.0,
                              ),
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                final Message message = messageList[index];
                                bool isMe =
                                    message.sender.id == currentUser!.id;
                                List<User> seenby = [];
                                widget.chatroom.lastMessageRead.keys
                                    .forEach((user_id) {
                                  if (user_id != currentUser!.id &&
                                      widget.chatroom
                                              .lastMessageRead[user_id] ==
                                          message.id) {
                                    seenby.add(user_by_id[user_id]!);
                                  }
                                });
                                return MessageCard(
                                  message: message,
                                  seenby: seenby,
                                );
                              },
                            )
                          : const Center(
                              child: Text('Say Hi!',
                                  style: TextStyle(fontSize: 20)),
                            ))
                      : Center(child: const CircularProgressIndicator()),
                ),
              ),
              if (_isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              _buildMessageComposer(),
              if (_showEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      columns: 5,
                      emojiSizeMax: 32 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.30
                              : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  final _textController = TextEditingController();
  _buildMessageComposer() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  constraints: BoxConstraints(
                    maxWidth: 35,
                  ),
                  icon: Icon(
                    Icons.image,
                    size: 26,
                    color: mColorScheme.primary,
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                    if (images.isEmpty) {
                      print("no image picked");
                      return;
                    }
                    for (var image in images) {
                      setState(() {
                        _isUploading = true;
                      });
                      await sendImageMessage(File(image.path));
                      setState(() {
                        _isUploading = false;
                      });
                    }
                  },
                ),
                IconButton(
                  constraints: BoxConstraints(
                    maxWidth: 35,
                  ),
                  icon: Icon(
                    size: 26,
                    Icons.photo_camera,
                    color: mColorScheme.primary,
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 70);
                    if (image == null) {
                      print("no image picked");
                      return;
                    }
                    setState(() {
                      _isUploading = true;
                    });
                    await sendImageMessage(File(image.path));
                    setState(() {
                      _isUploading = false;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    size: 26,
                    Icons.mic_rounded,
                    color: mColorScheme.primary,
                  ),
                  onPressed: () async {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {},
                    decoration: InputDecoration(
                      hintText: "Send message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 25,
                  onPressed: () {
                    setState(() {
                      _showEmoji = !_showEmoji;
                    });
                  },
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: mColorScheme.primary,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send_rounded,
            size: 28,
            color: mColorScheme.primary,
          ),
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              _sendMessage(_textController.text);
              _textController.text = '';
            }
          },
        )
      ],
    );
  }

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent + 100);
  }

  void _scrollDownSmooth() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 100,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }
}
