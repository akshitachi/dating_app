// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:auth_app/screens/matches_screen.dart';
import 'package:auth_app/screens/message_screen.dart';
import 'package:auth_app/screens/profile_screen.dart';
import 'package:auth_app/screens/signin_screen.dart';
import 'package:auth_app/utils/database.dart';
import 'package:auth_app/widgets/tinder_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List userData = [];
    return FutureBuilder(
        future: DataBaseService().getFirstUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snapshotData = snapshot.data;
            (snapshotData as Map).forEach((key, value) {
              if (key != FirebaseAuth.instance.currentUser!.uid) {
                userData.add(value);
              }
            });
            final random = Random();
            int randomValue = random.nextInt(userData.length);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade200, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text(
                      'Dating App',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.purpleAccent,
                    actions: [
                      Row(
                        children: [
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MatchesScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.man),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.chat),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  drawer: Drawer(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildMenuItems(context),
                        ],
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: TinderCard(
                              user: userData[randomValue],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          buildButtons(context, userData[randomValue]['uid']),
                        ],
                      ),
                    ),
                  )),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Widget buildButtons(BuildContext context, userId) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
//swipe to next user
            await DataBaseService().unliked(userId);
            print('Done');
          },
          child: Icon(
            Icons.clear,
            color: Colors.red,
            size: 50,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await DataBaseService().liked(userId);
            print('Done');
          },
          child: Icon(
            Icons.favorite,
            color: Colors.greenAccent,
            size: 50,
          ),
        ),
      ],
    );

Widget buildFrontCard(BuildContext context) => GestureDetector();

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16, //vertical spacing
        children: [
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ],
      ),
    );
