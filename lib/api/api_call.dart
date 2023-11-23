import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pill_reminder/constant.dart';
import 'package:pill_reminder/model/user.dart';

class ApiCall {
  static Future<Response> signUp(User user) async {
    var apiUrl =
        '${Constants.urlStr}/users/'; // Replace with your actual signup endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }
}
