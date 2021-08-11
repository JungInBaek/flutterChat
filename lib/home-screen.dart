import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterchat/chat-list-screen.dart';
import 'package:flutterchat/dio_server.dart';
import 'package:flutterchat/login-screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutterchat/user.dart';

import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return LoginScreen();
              } else {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.uid)
                    .get()
                    .then((value) {
                  if (!value.exists) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(snapshot.data.uid)
                        .set({
                      'uid': snapshot.data.uid,
                      'name': snapshot.data.displayName
                    });
                  }
                });
                print(
                    "${snapshot.data.displayName} (${snapshot.data.uid}) >>> [로그인]");
                server.postReq(snapshot.data.uid);
                // FirebaseFirestore.instance.collection('login').doc().set({'uidList' : '채팅방', 'uid' : _saved.toList()});

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${snapshot.data.displayName}님 환영합니다."),
                      Text("${snapshot.data.uid}님 환영합니다."),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ChangeNotifierProvider(
                          //           create: (context) =>
                          //               ChatListProvider(snapshot),
                          //           child: ChatListScreen(snapshot: snapshot),
                          //         )));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatListScreen(snapshot: snapshot)));
                        },
                        child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text("채팅방 리스트 이동",
                                style: TextStyle(fontSize: 25))),
                      ),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {},
                          child: Container(
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text("랜덤 매칭",
                                  style: TextStyle(fontSize: 25)))),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          print(
                              "${snapshot.data.displayName} (${snapshot.data.uid}) >>> [로그아웃]");
                          handleSignOut();
                        },
                        child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                            child:
                                Text("로그아웃", style: TextStyle(fontSize: 25))),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<Users> fetchUser() async {
    final response = await http.post(Uri.http('10.0.2.2:8080', '/demo/chat/logIn'), body: {'uid':'test', 'name':'test'});

    if(response.statusCode == 200) {
      return Users.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Null> handleSignOut() async {
    // this.setState(() {
    //   isLoading = true;
    // });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    // this.setState(() {
    //   isLoading = false;
    // });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }
}
