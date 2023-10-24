// ignore_for_file: prefer_const_constructors

import 'package:auth_app/screens/match_tile.dart';
import 'package:auth_app/screens/profile_screen.dart';
import 'package:auth_app/utils/database.dart';
import 'package:auth_app/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseService().getMatches(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List userList = [];
          (data as Map).forEach((key, value) {
            userList.add(key);
            print(userList.length);
          });
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Matches',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return MatchTile(
                    snap: userList[index],
                  );
                }),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}