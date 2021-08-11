import 'package:dio/dio.dart';

const _API_PREFIX = "https://jsonplaceholder.typicode.com/posts";

class Server {
  Future<void> getReq() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get("$_API_PREFIX");
    print(response.data.toString());
  }

  Future<void> postReq(uid) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post("http://10.0.2.2:8080/chat/logIn", data: uid);
    // print(response.data.toString());
  }

  Future<void> getReqWzQuery() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(_API_PREFIX, queryParameters: {
      "userId" : 1,
      "id" : 3,
    });
    print(response.data.toString());
  }
}

Server server = Server();