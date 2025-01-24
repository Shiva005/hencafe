class LoginPinCheckModel {
  LoginPinCheckModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  LoginPinCheckModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(LoginPinCheckModel.fromJson(v));
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
  List<dynamic>? errorMessage;
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
    this.userId,
    this.userUuid,
    this.userRoleType,
    this.authUuid,
  });

  ApiResponse.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userRoleType = json['user_role_type'];
    authUuid = json['auth_uuid'];
  }

  String? userId;
  String? userUuid;
  String? userRoleType;
  String? authUuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['user_role_type'] = userRoleType;
    map['auth_uuid'] = authUuid;
    return map;
  }
}
