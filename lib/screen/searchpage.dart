// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screen/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const SearchPage({super.key, this.userModel, this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoomModel;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .where("participants.${widget.userModel!.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      // already exist
      log("chat room model exist....");
      ChatRoomModel existingChatroomModel = ChatRoomModel.fromMap(
          snapshot.docs[0].data() as Map<String, dynamic>);
      chatRoomModel = existingChatroomModel;
    } else {
      // create chat room model
      log("Create chat room model");
      ChatRoomModel newchatroom = ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel!.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(newchatroom.chatRoomId)
          .set(newchatroom.toMap());
      chatRoomModel = newchatroom;
    }
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Screen"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Search",
                hintText: "Search Friend",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 40),
            CupertinoButton(
              onPressed: () {
                setState(() {});
              },
              color: Colors.blue,
              child: const Text(
                "Search",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 40),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where("phoneNumber", isEqualTo: searchController.text)
                  .where("phoneNumber",
                      isNotEqualTo: widget.userModel!.phoneNumber)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    if (querySnapshot.docs.isNotEmpty) {
                      Map<String, dynamic> userMap =
                          querySnapshot.docs[0].data() as Map<String, dynamic>;
                      UserModel searchUser = UserModel.fromMap(userMap);
                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? currentChatRoomModel =
                              await getChatroomModel(searchUser);
                          if (currentChatRoomModel != null) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(
                                    currentUser: widget.userModel!,
                                    targetUser: searchUser,
                                    firebaseUser: widget.firebaseUser!,
                                    chatRoomModel: currentChatRoomModel);
                              },
                            ));
                          }
                        },
                        title: Text(searchUser.name!),
                        subtitle: Text(searchUser.email!),
                      );
                    } else {
                      return const Text("no data found!");
                    }
                  } else if (snapshot.hasError) {
                    return const Text("An error occured!");
                  } else {
                    return const Text("No data found!");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
