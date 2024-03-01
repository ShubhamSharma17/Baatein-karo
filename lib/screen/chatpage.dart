// ignore_for_file: avoid_unnecessary_containers

import 'dart:developer';

import 'package:chat_app/helper/colors.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel targetUser;
  final User firebaseUser;
  final ChatRoomModel chatRoomModel;

  const ChatPage(
      {super.key,
      required this.currentUser,
      required this.targetUser,
      required this.firebaseUser,
      required this.chatRoomModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  void messageSend() {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      MessageModel msgModel = MessageModel(
        messageId: uuid.v1(),
        sender: widget.currentUser.uid.toString(),
        createOn: DateTime.now(),
        seen: false,
        text: msg,
      );
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoomModel.chatRoomId)
          .collection("messages")
          .doc(msgModel.messageId)
          .set(msgModel.toMap());
      log("messgae send");

      widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatRoomModel.chatRoomId)
          .set(widget.chatRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.targetUser.profilePicture!),
              backgroundColor: white,
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.name!),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatroom")
                      .doc(widget.chatRoomModel.chatRoomId)
                      .collection("messages")
                      .orderBy("createOn", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot querySnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel allMessage = MessageModel.fromMap(
                                querySnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment:
                                  (allMessage.sender == widget.currentUser.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(allMessage.text!.toString())),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                            "An error occured! Please check internet connection....");
                      } else {
                        return const Text("Say hi to your friend...");
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Message",
                      ),
                      controller: messageController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      messageSend();
                    },
                    icon: const Icon(Icons.send),
                    color: blue,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
