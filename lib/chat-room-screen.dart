import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/chat-message-widget.dart';

import 'message-model.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key, required this.rname, required this.rid, required this.uid, required this.name}) : super(key: key);

  final String rname;
  final String rid;
  final String uid;
  final String name;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState(rname, rid, uid, name);
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  _ChatRoomScreenState(this.rname, this.rid, this.uid, this.name);

  final String rname;
  final String rid;
  final String uid;
  final String name;

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rname),
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('messages').where('rid', isEqualTo: rid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // return ListView(
              //   reverse: true,
              //   children: snapshot.data!.docs.map((document) {
              //     return ChatMessageWidget(messageModel: MessageModel(rid, document['uid'], name, document['txt'], DateTime.now().millisecondsSinceEpoch), uid: uid,);
              //   }).toList(),
              // );

              List<ChatMessageWidget> _messages = [];

              snapshot.data!.docs.map((document) {
                _messages.insert(0, ChatMessageWidget(messageModel: MessageModel(rid, document['uid'], name, document['txt'], DateTime.now().millisecondsSinceEpoch), uid: uid,));
              }).toList();

              return AnimatedList(
                reverse: true,
                itemBuilder: (context, index, animation) {
                  return _messages[index];
                },
              );

              return ListView(
                reverse: true,
                children: _messages,
              );
            },
          )),
          Divider(thickness: 1.5, height: 1.5, color: Colors.grey),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5
            ),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "메세지 입력창",
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var txt = _controller.text;
                    var now = DateTime.now().millisecondsSinceEpoch;
                    _controller.clear();
                    await FirebaseFirestore.instance.collection('messages').doc(now.toString()).set(MessageModel(rid, uid, name, txt, now).toJson());
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Icon(
                      Icons.send,
                      size: 33,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
