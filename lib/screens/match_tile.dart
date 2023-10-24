// ignore_for_file: prefer_const_constructors

import 'package:auth_app/screens/profile_screen.dart';
import 'package:auth_app/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MatchTile extends StatefulWidget {
  const MatchTile({super.key, required this.snap});
  final snap;
  @override
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: userData['uid'],
                      ),
                    ),
                  );
                },
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
