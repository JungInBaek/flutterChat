class MessageModel {
  MessageModel(this.rid, this.uid, this.name, this.txt, this.uploadTime);

  final String rid;
  final String uid;
  final String name;
  final String txt;
  final int uploadTime;


  // factory MessageModel.fromJson(Map<String, dynamic> json) {
  //   return MessageModel(json['uid'], json['name'], json['txt'], json['uploadTime']);
  // }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(json['rid'], json['uid'], json['name'], json['txt'], json['uploadTime']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'rid' : rid,
      'uid' : uid,
      'name' : name,
      'txt' : txt,
      'uploadTime' : uploadTime
    };
  }
}