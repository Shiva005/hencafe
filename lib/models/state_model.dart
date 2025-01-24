class StateModel {
  StateModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  StateModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(StateModel.fromJson(v));
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
    this.countryId,
    this.countryCode,
    this.countryName,
    this.stateId,
    this.stateCode,
    this.stateName,
    this.stateNameLanguage,
  });

  ApiResponse.fromJson(dynamic json) {
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
    stateNameLanguage = json['state_name_language'];
  }

  String? countryId;
  String? countryCode;
  String? countryName;
  String? stateId;
  String? stateCode;
  String? stateName;
  String? stateNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_id'] = countryId;
    map['country_code'] = countryCode;
    map['country_name'] = countryName;
    map['state_id'] = stateId;
    map['state_code'] = stateCode;
    map['state_name'] = stateName;
    map['state_name_language'] = stateNameLanguage;
    return map;
  }
}
