// ignore_for_file: prefer_const_constructors

import 'package:auth_app/utils/database.dart';
import 'package:auth_app/widgets/message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    List chats = [];
    return FutureBuilder(
        future: DataBaseService().getChatsforUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var chatData = snapshot.data;
            (chatData as Map).forEach((key, value) {
              if (key
                  .toString()
                  .contains(FirebaseAuth.instance.currentUser!.uid)) {
                chats.add(key
                    .toString()
                    .replaceAll(FirebaseAuth.instance.currentUser!.uid, ''));
              }
            });
            return FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Messages',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    body: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            snap: chats[index],
                          );
                        }),
                  );
                });
          } else {
            return Center(
              child: Text(
                'No messages :(',
                style: TextStyle(color: Colors.black, fontSize: 23),
              ),
            );
          }
        });
  }
}
