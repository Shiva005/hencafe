import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/Registration_check.dart';
import 'package:hencafe/models/error_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'service_name.dart';
import '../utils/my_logger.dart';

class AuthServices {
  Future<RegistrationCheck> registrationCheck(
      BuildContext context, String mobileNumber, String language) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.REGISTRATION_CHECK),
    );
    request.fields['user_login_uid'] = mobileNumber;
    request.fields['language'] = language;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      // Send the request once
      final streamedResponse = await request.send();

      // Get the response from the streamed data
      final response = await http.Response.fromStream(streamedResponse);

      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return RegistrationCheck.fromJson(jsonDecode(response.body));
      } else {
        // Handle error status codes
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }
}

class StatusCodeHandler {
  static ErrorModel handleStatusCode(
      BuildContext context, int statusCode, String body) {
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        _showErrorDialog(context, body);
        break;
      default:
        logger.e('Unexpected Error: $statusCode $body');
        throw Exception('Unexpected Error: $statusCode $body');
    }
    throw Exception('Error $statusCode: $body');
  }

  static void _showErrorDialog(BuildContext context, String body) {
    var errorModel = ErrorModel.fromJson(jsonDecode(body));
    var message = '';
    for (int i = 0; i < errorModel.errorCount!; i++) {
      message = '$message  \n${errorModel.errorMessage![i].errorDetails!}';
    }

    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.error,
      dialogBackgroundColor: Colors.white,
      desc: message,
      descTextStyle: const TextStyle(color: Colors.black),
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }
}
