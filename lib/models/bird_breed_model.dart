class BirdBreedModel {
  BirdBreedModel({
      this.apiCode, 
      this.errorCount, 
      this.errorMessage, 
      this.apiResponse,});

  BirdBreedModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(BirdBreedModel.fromJson(v));
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
      this.birdbreedId, 
      this.birdbreedName, 
      this.birdbreedNameLanguage, 
      this.birdbreedSno, 
      this.birdbreedStatus,});

  ApiResponse.fromJson(dynamic json) {
    birdbreedId = json['birdbreed_id'];
    birdbreedName = json['birdbreed_name'];
    birdbreedNameLanguage = json['birdbreed_name_language'];
    birdbreedSno = json['birdbreed_sno'];
    birdbreedStatus = json['birdbreed_status'];
  }
  String? birdbreedId;
  String? birdbreedName;
  String? birdbreedNameLanguage;
  String? birdbreedSno;
  String? birdbreedStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['birdbreed_id'] = birdbreedId;
    map['birdbreed_name'] = birdbreedName;
    map['birdbreed_name_language'] = birdbreedNameLanguage;
    map['birdbreed_sno'] = birdbreedSno;
    map['birdbreed_status'] = birdbreedStatus;
    return map;
  }

}