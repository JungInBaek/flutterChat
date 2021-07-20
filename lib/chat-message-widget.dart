import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/message-model.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({Key? key, required this.messageModel, required this.uid}) : super(key: key);

  final MessageModel messageModel;
  final String uid;

  @override
  Widget build(BuildContext context) {
    // var p = Provider.of<MessageProvider>(context);
    var isMe = messageModel.uid == uid;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: Text(messageModel.name, style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 30 : 0),
                          topRight: Radius.circular(isMe ? 0 : 30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)
                      )),
                  child: Text(messageModel.txt, style: TextStyle(color: Colors.white, fontSize: 18),))
            ],
          )
        ],
      ),
    );
  }
}
