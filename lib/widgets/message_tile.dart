// ignore_for_file: prefer_const_constructors

import 'package:auth_app/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({super.key, required this.snap});
  final snap;
  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataBaseService().getUserDetails(widget.snap),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            var firstName = (userData as Map)['first_name'];
            var imageUrl = userData['image_url'];
            return Container(
              padding: EdgeInsets.all(16),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.amber,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(
                    firstName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
