import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pill_reminder/constant.dart';
import 'package:pill_reminder/model/feedback.dart';
import 'package:pill_reminder/model/medicine.dart';
import 'package:pill_reminder/model/table_sequence.dart';
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

  static Future<Response> login(User user) async {
    var apiUrl =
        '${Constants.urlStr}/users/login'; // Replace with your actual signup endpoint

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

  static Future<Response> createSequence(TableSequence tableSequence) async {
    var apiUrl =
        '${Constants.urlStr}/sequence/'; // Replace with your actual signup endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tableSequence),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> updateSequence(TableSequence tableSequence) async {
    var apiUrl =
        '${Constants.urlStr}/sequence/'; // Replace with your actual signup endpoint

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tableSequence),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> getSequence(TableSequence tableSequence) async {
    var apiUrl =
        '${Constants.urlStr}/sequence/get'; // Replace with your actual signup endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tableSequence),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> createMedicine(Medicine medicine) async {
    var apiUrl =
        '${Constants.urlStr}/medicine/'; // Replace with your actual signup endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(medicine),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> updateMedicine(Medicine medicine) async {
    var apiUrl =
        '${Constants.urlStr}/medicine/'; // Replace with your actual signup endpoint

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(medicine),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> getMedicinesForSync(DateTime dateTime) async {
    var apiUrl =
        '${Constants.urlStr}/medicine/$dateTime'; // Replace with your actual signup endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> getMedicinesSearch() async {
    var apiUrl =
        '${Constants.urlStr}/medicine/search/'; // Replace with your actual signup endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> getMedicinesById(String id) async {
    var apiUrl =
        '${Constants.urlStr}/medicine/get/$id'; // Replace with your actual signup endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }

  static Future<Response> createFeedback(FeedBack feedBack) async {
    var apiUrl =
        '${Constants.urlStr}/feedback/'; // Replace with your actual signup endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(feedBack),
      );
      return response;
    } catch (e) {
      return Response('internal server error', HttpStatus.internalServerError);
    }
  }
}
