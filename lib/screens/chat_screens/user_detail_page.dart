import 'package:app/models/message_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/chat_screens/chat_page.dart';
import 'package:app/services/api_service.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconly/iconly.dart';
import 'package:path/path.dart';

class UserDetailPage extends StatefulWidget {
  final User user;
  Function callback;
  UserDetailPage({
    super.key,
    required this.user,
    required this.callback,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late ChatRoom chatroom;
  @override
  void initState() {
    super.initState();

    chatroom = ChatRoom(title: '${widget.user.get_full_name()}');
    chatroom.user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    bool isworkingwith = false;
    if (currentUser != null) {
      isworkingwith = (currentUser!.role == "Normal"
              ? currentUser!.specialist_id
              : currentUser!.customer_id) ==
          widget.user.id;
    }
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 360,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.user.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 40,
              child: Row(
                children: [
                  IconButton(
                    iconSize: 30.0,
                    icon: const Icon(
                      IconlyLight.arrow_left_2,
                    ),
                    color: const Color(APP_COLORS.GRAY),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 320,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 30,
                  top: 25,
                  right: 30,
                ),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.user.role == "Normal" ? "Customer" : "Specialist",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${widget.user.role == "Specialist" ? "Dr." : ""} ${widget.user.get_full_name()}",
                      style: TextStyle(
                        color: mColorScheme.text_normal,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.user.caption,
                      style: TextStyle(
                        color: mColorScheme.text_normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE0E3E7),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChatPage(chatroom: chatroom),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 12),
                                        child: Icon(
                                          IconlyLight.chat,
                                          color: Color(APP_COLORS.GREEN),
                                          size: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 12, 0),
                                        child: Text(
                                          'Chat',
                                          style: TextStyle(
                                            color: Color(APP_COLORS.GREEN),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: VerticalDivider(
                                thickness: 1,
                                indent: 12,
                                endIndent: 12,
                                color: Color(0xFFE0E3E7),
                              ),
                            ),
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 12),
                                        child: Icon(
                                          IconlyLight.call,
                                          color: Color(APP_COLORS.GREEN),
                                          size: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 12, 0),
                                        child: Text(
                                          'Call',
                                          style: TextStyle(
                                            color: Color(APP_COLORS.GREEN),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: isworkingwith
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(APP_COLORS.RED_BUTTON),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (currentUser == null) return;
                                  sendPostRequest(
                                          endpoint:
                                              "accounts/${currentUser!.id}/remove_${widget.user.role == "Normal" ? "customer" : "specialist"}")
                                      .then((value) {
                                    if (currentUser!.role == "Normal") {
                                      currentUser!.specialist_id = null;
                                      specialist = null;
                                    } else {
                                      currentUser!.customer_id = null;
                                      customer = null;
                                    }
                                    setState(() {
                                      widget.callback();
                                    });
                                  });
                                },
                                child: Text(
                                  "Stop working with this ${widget.user.role == "Normal" ? "customer" : "specialist"}.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(APP_COLORS.GREEN_BUTTON),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (currentUser == null) return;
                                  String workwithrole =
                                      "${widget.user.role == "Normal" ? "customer" : "specialist"}";

                                  sendPostRequest(
                                    endpoint:
                                        "accounts/${currentUser!.id}/add_$workwithrole",
                                    body: {
                                      "${workwithrole}_id": widget.user.id
                                    },
                                  ).then((value) {
                                    getUser(body: {"user_id": widget.user.id})
                                        .then(
                                      (user) {
                                        if (currentUser!.role == "Normal") {
                                          specialist = user;
                                          currentUser!.specialist_id = user.id;
                                        } else {
                                          customer = user;
                                          currentUser!.customer_id = user.id;
                                        }
                                        setState(() {
                                          widget.callback();
                                        });
                                      },
                                    );
                                  });
                                },
                                child: Text(
                                  currentUser!.role == "Normal"
                                      ? "Let them see your diet"
                                      : "Advise this client",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
