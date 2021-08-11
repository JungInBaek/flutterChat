import 'package:http/http.dart' as http;

class Users {
  final String uid;
  final String name;

  Users({required this.uid, required this.name});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      name: json['name']
    );
  }
}