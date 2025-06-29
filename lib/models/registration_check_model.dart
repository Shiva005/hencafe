import 'package:hencafe/models/error_model.dart';

class RegistrationCheckModel {
  RegistrationCheckModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  RegistrationCheckModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ErrorModel.fromJson(v));
      });
    }
    if (json['api_response'] != null) {
      apiResponse = [];
      json['api_response'].forEach((v) {
        apiResponse?.add(ApiResponse.fromJson(v));
      });
    }
  }

  int? apiCode;
  int? errorCount;
  List<ErrorModel>? errorMessage;
  List<ApiResponse>? apiResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_code'] = apiCode;
    map['error_count'] = errorCount;
    if (errorMessage != null) {
      map['error_message'] = errorMessage?.map((v) => v.toJson()).toList();
    }
    if (apiResponse != null) {
      map['api_response'] = apiResponse?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ApiResponse {
  ApiResponse({
    this.registrationStatus,
    this.responseCode,
    this.responseDetails,
    this.responseLogs,
  });

  ApiResponse.fromJson(dynamic json) {
    registrationStatus = json['response_status'];
    responseCode = json['response_code'];
    responseDetails = json['response_details'];
    responseLogs = json['response_logs'];
  }

  bool? registrationStatus;
  String? responseCode;
  String? responseDetails;
  String? responseLogs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_status'] = registrationStatus;
    map['response_code'] = responseCode;
    map['response_details'] = responseDetails;
    map['response_logs'] = responseLogs;
    return map;
  }
}
