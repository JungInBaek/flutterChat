import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/chat-list-widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<dynamic> snapshot;


  @override
  ChatListScreenState createState() => ChatListScreenState(snapshot.data.uid, snapshot.data.displayName);
}

class ChatListScreenState extends State<ChatListScreen> {
  ChatListScreenState(this.uid, this.name);
  // final AsyncSnapshot<dynamic> snapshot;
  // final Stream<QuerySnapshot> _roomStream = FirebaseFirestore.instance.collection('room').snapshots();
  final String uid;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('채팅 리스트'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('room').where('uid', arrayContains: uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: ChatListWidget(uidList: document['uid'], uid: uid, name: name, rid: document.id, rname: document['rname'])
                );
              }).toList(),
            );
          },
        ),
    );
  }
}
