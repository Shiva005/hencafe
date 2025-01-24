import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/error_model.dart';
import 'package:hencafe/models/forget_pin_model.dart';
import 'package:hencafe/models/otp_generate_model.dart';
import 'package:hencafe/models/registration_check_model.dart';
import 'package:hencafe/models/registration_create_model.dart';
import 'package:hencafe/models/state_model.dart';
import 'package:hencafe/models/validate_otp_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_pin_check_model.dart';
import '../utils/my_logger.dart';
import '../values/app_strings.dart';
import 'service_name.dart';

class AuthServices {
  Future<RegistrationCheckModel> registrationCheck(
      BuildContext context, String mobileNumber) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.REGISTRATION_CHECK),
    );
    request.fields['user_login_uid'] = mobileNumber;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return RegistrationCheckModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<RegistrationCreateModel> registrationCreate(
      BuildContext context,
      String firstName,
      String lastName,
      String mobileNumber,
      String email,
      String dob,
      String password,
      String address,
      String stateId,
      String referralCode) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.REGISTRATION_CREATE),
    );
    request.fields['user_first_name'] = firstName;
    request.fields['user_last_name'] = lastName;
    request.fields['user_mobile_primary'] = mobileNumber;
    request.fields['user_email'] = email;
    request.fields['user_dob'] = dob;
    request.fields['user_login_pwd'] = password;
    request.fields['address_address'] = address;
    request.fields['address_state_id'] = stateId;
    request.fields['user_referral_from_code'] = referralCode;
    request.fields['address_country_id'] =
        prefs.getString(AppStrings.prefCountryCode)!;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 201) {
        return RegistrationCreateModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return RegistrationCreateModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<LoginPinCheckModel> loginPinCheck(
      BuildContext context, String mobileNumber, String pin) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.LOGIN_PIN_CHECK),
    );
    request.fields['user_login_uid'] = mobileNumber;
    request.fields['user_login_pwd'] = pin;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return LoginPinCheckModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return LoginPinCheckModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<OtpGenerateModel> otpGenerate(
      BuildContext context, String mobileNumber) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.OTP_GENERATE),
    );
    request.fields['otp_login_uid'] = mobileNumber;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return OtpGenerateModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return OtpGenerateModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<ValidateOtpModel> otpValidate(
      BuildContext context, String mobileNumber, String otp) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.OTP_VALIDATE),
    );
    request.fields['otp_login_uid'] = mobileNumber;
    request.fields['otp_4_digit_otp'] = otp;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return ValidateOtpModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return ValidateOtpModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<ForgetPinModel> forgetPin(
      BuildContext context, String mobileNumber, String otp) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.FORGET_PIN),
    );
    request.fields['user_login_uid'] = mobileNumber;
    request.fields['otp_otp'] = otp;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return ForgetPinModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return ForgetPinModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      logger.e('Exception occurred: $e');
      rethrow; // Re-throwing the exception for the caller to handle
    }
  }

  Future<StateModel> getStates(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ServiceNames.STATE_LIST),
    );
    request.fields['country_id'] = prefs.getString(AppStrings.prefCountryCode)!;
    request.fields['language'] = prefs.getString(AppStrings.prefLanguage)!;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      logger.e('Request Data: ${request.fields}');
      logger.e('Response: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        return StateModel.fromJson(jsonDecode(response.body));
      } else {
        StatusCodeHandler.handleStatusCode(
            context, response.statusCode, response.body);
        return StateModel.fromJson(jsonDecode(response.body));
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
    try {
      var errorModel = ErrorModel.fromJson(jsonDecode(body));
      switch (statusCode) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 500:
          SnackbarHelper.showSnackBar(body.toString());
          _showErrorDialog(context, errorModel);
          return errorModel;
        default:
          // Handle unexpected status codes gracefully
          logger.e('Unexpected Error: $statusCode $body');
          throw Exception('Unexpected Error: $statusCode $body');
      }
    } catch (e) {
      // Log parsing issues or any unexpected behavior
      logger.e('Error processing status code: $e');
      throw Exception('Error processing status code: $e');
    }
  }

  static void _showErrorDialog(BuildContext context, ErrorModel errorModel) {
    var message = '';
    for (int i = 0; i < errorModel.errorCount!; i++) {
      message = '$message\n${errorModel.errorMessage![i].errorDetails!}';
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
