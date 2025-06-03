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
    this.responseStatus,
    this.responseCode,
    this.responseDetails,
    this.responseLogs,
    this.userLoginInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    responseStatus = json['response_status'];
    responseCode = json['response_code'];
    responseDetails = json['response_details'];
    responseLogs = json['response_logs'];
    userLoginInfo = json['user_login_info'] != null
        ? UserLoginInfo.fromJson(json['user_login_info'])
        : null;
  }

  bool? responseStatus;
  String? responseCode;
  String? responseDetails;
  String? responseLogs;
  UserLoginInfo? userLoginInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_status'] = responseStatus;
    map['response_code'] = responseCode;
    map['response_details'] = responseDetails;
    map['response_logs'] = responseLogs;
    if (userLoginInfo != null) {
      map['user_login_info'] = userLoginInfo?.toJson();
    }
    return map;
  }
}

class UserLoginInfo {
  UserLoginInfo({
    this.userId,
    this.userUuid,
    this.mobileNumber,
    this.userLoginUid,
    this.authUuid,
    this.userRoleType,
    this.userWorkType,
  });

  UserLoginInfo.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    mobileNumber = json['mobile_number'];
    userLoginUid = json['user_login_uid'];
    authUuid = json['auth_uuid'];
    userRoleType = json['user_role_type'];
    userWorkType = json['user_work_type'];
  }

  String? userId;
  String? userUuid;
  String? mobileNumber;
  String? userLoginUid;
  String? authUuid;
  String? userRoleType;
  String? userWorkType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['mobile_number'] = mobileNumber;
    map['user_login_uid'] = userLoginUid;
    map['auth_uuid'] = authUuid;
    map['user_role_type'] = userRoleType;
    map['user_work_type'] = userWorkType;
    return map;
  }
}
