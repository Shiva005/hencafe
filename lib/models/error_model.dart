class ErrorModel {
  ErrorModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  ErrorModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ErrorMessage.fromJson(v));
      });
    }
    if (json['api_response'] != null) {
      apiResponse = [];
      json['api_response'].forEach((v) {
        apiResponse?.add(ErrorModel.fromJson(v));
      });
    }
  }

  int? apiCode;
  int? errorCount;
  List<ErrorMessage>? errorMessage;
  List<dynamic>? apiResponse;

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

class ErrorMessage {
  ErrorMessage({
    this.errorCode,
    this.errorDetails,
    this.errorLogs,
  });

  ErrorMessage.fromJson(dynamic json) {
    errorCode = json['error_code'];
    errorDetails = json['error_details'];
    errorLogs = json['error_logs'];
  }

  String? errorCode;
  String? errorDetails;
  String? errorLogs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error_code'] = errorCode;
    map['error_details'] = errorDetails;
    map['error_logs'] = errorLogs;
    return map;
  }
}
