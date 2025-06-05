class UserFavouriteStateModel {
  UserFavouriteStateModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  UserFavouriteStateModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(UserFavouriteStateModel.fromJson(v));
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
    this.favouriteId,
    this.userUuid,
    this.stateInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    favouriteId = json['favourite_id'];
    userUuid = json['user_uuid'];
    if (json['state_info'] != null) {
      stateInfo = [];
      json['state_info'].forEach((v) {
        stateInfo?.add(StateInfo.fromJson(v));
      });
    }
  }

  String? favouriteId;
  String? userUuid;
  List<StateInfo>? stateInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['favourite_id'] = favouriteId;
    map['user_uuid'] = userUuid;
    if (stateInfo != null) {
      map['state_info'] = stateInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StateInfo {
  StateInfo({
    this.stateId,
    this.stateName,
    this.stateNameLanguage,
  });

  StateInfo.fromJson(dynamic json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateNameLanguage = json['state_name_language'];
  }

  String? stateId;
  String? stateName;
  String? stateNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['state_name_language'] = stateNameLanguage;
    return map;
  }
}
