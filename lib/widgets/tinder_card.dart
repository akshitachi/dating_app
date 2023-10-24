// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auth_app/database/user.dart';
import 'package:flutter/material.dart';

class TinderCard extends StatefulWidget {
  const TinderCard({
    super.key,
    required this.user,
  });
  final Map user;

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.user['image_url']),
            fit: BoxFit.cover,
            alignment: Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 1],
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Spacer(),
                buildName(),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName() => Row(
        children: [
          Text(
            widget.user['first_name'],
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            widget.user['age'],
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ],
      );
}
