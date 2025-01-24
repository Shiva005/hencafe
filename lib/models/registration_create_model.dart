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
    if (json['reg_user_info'] != null) {
      regUserInfo = [];
      json['reg_user_info'].forEach((v) {
        regUserInfo?.add(RegUserInfo.fromJson(v));
      });
    }
  }

  int? apiCode;
  int? errorCount;
  List<dynamic>? errorMessage;
  List<ApiResponse>? apiResponse;
  List<RegUserInfo>? regUserInfo;

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
      map['reg_user_info'] = regUserInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RegUserInfo {
  RegUserInfo({
    this.userId,
    this.userLoginUid,
    this.userUuid,
    this.userRoleType,
    this.authUuid,
  });

  RegUserInfo.fromJson(dynamic json) {
    userId = json['user_id'];
    userLoginUid = json['user_login_uid'];
    userUuid = json['user_uuid'];
    userRoleType = json['user_role_type'];
    authUuid = json['auth_uuid'];
  }

  String? userId;
  String? userLoginUid;
  String? userUuid;
  String? userRoleType;
  String? authUuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_login_uid'] = userLoginUid;
    map['user_uuid'] = userUuid;
    map['user_role_type'] = userRoleType;
    map['auth_uuid'] = authUuid;
    return map;
  }
}

class ApiResponse {
  ApiResponse({
    this.responseCode,
    this.responseDetails,
    this.responseLogs,
  });

  ApiResponse.fromJson(dynamic json) {
    responseCode = json['response_code'];
    responseDetails = json['response_details'];
    responseLogs = json['response_logs'];
  }

  String? responseCode;
  String? responseDetails;
  String? responseLogs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = responseCode;
    map['response_details'] = responseDetails;
    map['response_logs'] = responseLogs;
    return map;
  }
}
