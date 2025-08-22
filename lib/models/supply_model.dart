class SupplyModel {
  SupplyModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  SupplyModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(SupplyModel.fromJson(v));
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
    this.supplytypeId,
    this.supplytypeName,
    this.supplytypeLanguage,
  });

  ApiResponse.fromJson(dynamic json) {
    supplytypeId = json['supplytype_id'];
    supplytypeName = json['supplytype_name'];
    supplytypeLanguage = json['supplytype_language'];
  }

  int? supplytypeId;
  String? supplytypeName;
  String? supplytypeLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['supplytype_id'] = supplytypeId;
    map['supplytype_name'] = supplytypeName;
    map['supplytype_language'] = supplytypeLanguage;
    return map;
  }
}
