class RegistrationCreateModel {
  RegistrationCreateModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
    this.regUserInfo,
  });

  RegistrationCreateModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(RegistrationCreateModel.fromJson(v));
      });
    }
    if (json['api_response'] != null) {
      apiResponse = [];
      json['api_response'].forEach((v) {
        apiResponse?.add(ApiResponse.fromJson(v));
      });
    }
    regUserInfo = json['reg_user_info'] != null
        ? RegUserInfo.fromJson(json['reg_user_info'])
        : null;
  }

  int? apiCode;
  int? errorCount;
  List<dynamic>? errorMessage;
  List<ApiResponse>? apiResponse;
  RegUserInfo? regUserInfo;

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
    if (regUserInfo != null) {
      map['reg_user_info'] = regUserInfo?.toJson();
    }
    return map;
  }
}

class RegUserInfo {
  RegUserInfo({
    this.userId,
    this.userUuid,
    this.userLoginUid,
    this.authUuid,
    this.userRoleType,
    this.userWorkType,
  });

  RegUserInfo.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userLoginUid = json['user_login_uid'];
    authUuid = json['auth_uuid'];
    userRoleType = json['user_role_type'];
    userWorkType = json['user_work_type'];
  }

  String? userId;
  String? userUuid;
  String? userLoginUid;
  String? authUuid;
  String? userRoleType;
  String? userWorkType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['user_login_uid'] = userLoginUid;
    map['auth_uuid'] = authUuid;
    map['user_role_type'] = userRoleType;
    map['user_work_type'] = userWorkType;
    return map;
  }
}

class ApiResponse {
  ApiResponse({
    this.responseStatus,
    this.responseCode,
    this.responseDetails,
    this.responseLogs,
  });

  ApiResponse.fromJson(dynamic json) {
    responseStatus = json['response_status'];
    responseCode = json['response_code'];
    responseDetails = json['response_details'];
    responseLogs = json['response_logs'];
  }

  bool? responseStatus;
  String? responseCode;
  String? responseDetails;
  String? responseLogs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_status'] = responseStatus;
    map['response_code'] = responseCode;
    map['response_details'] = responseDetails;
    map['response_logs'] = responseLogs;
    return map;
  }
}
