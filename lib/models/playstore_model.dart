class PlayStoreModel {
  PlayStoreModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  PlayStoreModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(PlayStoreModel.fromJson(v));
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
    this.id,
    this.appName,
    this.version,
    this.details,
    this.startDate,
    this.endDate,
    this.detailsLanguage,
  });

  ApiResponse.fromJson(dynamic json) {
    id = json['id'];
    appName = json['app_name'];
    version = json['version'];
    details = json['details'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    detailsLanguage = json['details_language'];
  }

  String? id;
  String? appName;
  String? version;
  String? details;
  String? startDate;
  String? endDate;
  String? detailsLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['app_name'] = appName;
    map['version'] = version;
    map['details'] = details;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['details_language'] = detailsLanguage;
    return map;
  }
}
