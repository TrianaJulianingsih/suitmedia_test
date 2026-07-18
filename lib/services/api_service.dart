import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiService {
  static const apiKey = "reqres_3de4ea08108d4df09ac7f911df2f9094";

  Future<List<UserModel>> getUsers(int page) async {
    final response = await http.get(
      Uri.parse("https://reqres.in/api/users?page=$page&per_page=10"),

      headers: {"x-api-key": apiKey},
    );

    final body = jsonDecode(response.body);

    return (body["data"] as List).map((e) => UserModel.fromJson(e)).toList();
  }
}
