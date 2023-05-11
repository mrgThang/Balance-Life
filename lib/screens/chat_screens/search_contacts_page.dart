import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import 'chat_page.dart';

class SearchContactsPage extends StatefulWidget {
  const SearchContactsPage({super.key});

  @override
  State<SearchContactsPage> createState() => _SearchContactsPageState();
}

class _SearchContactsPageState extends State<SearchContactsPage> {
  final _textController = TextEditingController();

  Future<void> search_for(String search_input) async {
    var res = await sendPostRequest(endpoint: 'get_users/', body: {
      'search_input': search_input,
    });
    var jsonRes = jsonDecode(res);
    searchResult = json_to_users(jsonRes);
  }

  List<User> searchResult = userList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 30,
          color: Colors.grey.shade400,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: _textController,
            onChanged: (search_input) async {
              search_for(search_input).then((value) {
                setState(() {});
              });
            },
            autofocus: true,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            decoration: InputDecoration(
              filled: false,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Search",
              suffixIcon: ((_textController.text.isNotEmpty)
                  ? IconButton(
                      color: Colors.grey.shade400,
                      iconSize: 30,
                      onPressed: () {
                        _textController.text = '';
                        search_for('').then((value) {
                          setState(() {});
                        });
                      },
                      icon: Icon(Icons.clear_rounded),
                    )
                  : SizedBox(
                      width: 30,
                    )),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  final User user = searchResult[index];

                  ChatRoom chatroom =
                      ChatRoom(title: '${user.get_full_name()}');
                  chatroom.user = user;
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
                                backgroundImage: NetworkImage(user.imageUrl),
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.get_full_name()}',
                                    style: TextStyle(
                                      color: mColorScheme.text_normal,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
