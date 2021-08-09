import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/friend-list-widget.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState(uid);
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {

  final String uid;
  final Set<String> _saved = Set<String>();

  _CreateRoomScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    _saved.add(uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 생성'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if(_saved.isNotEmpty) {
                FirebaseFirestore.instance.collection('room').doc().set({'rname' : '채팅방', 'uid' : _saved.toList()});    // 나중에 다시 수정
                print("방 생성 완료!");
              }
              Navigator.pop(
                context
              );
              
              // 채팅방 화면으로 한번 더 이동시키기 (나중에 다시 수정)
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ChatRoomScreen(rname: '채팅방', rid: rid, uid: uid, name: name))
              // );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('friends').where('uid', isEqualTo: uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final bool alreadySaved = _saved.contains(document['fid']);

              return ListTile(
                title: FriendListWidget(fid: document['fid'], fname: document['fname']),
                trailing: Icon(alreadySaved ? Icons.check_circle : Icons.circle_outlined, color: Colors.blue,),
                onTap: () {
                  setState(() {
                    if(alreadySaved) {
                      _saved.remove(document['fid']);     //  true
                    } else {
                      _saved.add(document['fid']);        //  false
                    }
                    print(_saved.toString());
                  });
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
