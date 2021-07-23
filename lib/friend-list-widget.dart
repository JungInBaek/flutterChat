import 'package:flutter/material.dart';

class FriendListWidget extends StatefulWidget {
  const FriendListWidget({Key? key, required this.fid, required this.fname}) : super(key: key);

  final String fid;
  final String fname;

  @override
  _FriendListWidgetState createState() => _FriendListWidgetState();
}

class _FriendListWidgetState extends State<FriendListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            child: Text("p"),
          ),
          SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.fname, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.fid),
              ],
            ),
          )
        ],
      ),
    );
  }
}
