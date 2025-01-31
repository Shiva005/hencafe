class CompanyListModel {
  CompanyListModel({
      this.apiCode, 
      this.errorCount, 
      this.errorMessage, 
      this.apiResponse,});

  CompanyListModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(CompanyListModel.fromJson(v));
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
      this.companyId, 
      this.companyUuid, 
      this.companyName, 
      this.companyNameLanguage, 
      this.companyDetails, 
      this.companyPocUserName, 
      this.companyPocUserMobile, 
      this.companyStatus, 
      this.companyAddresInfo, 
      this.companyLikeDislikeRatingsInfo,});

  ApiResponse.fromJson(dynamic json) {
    companyId = json['company_id'];
    companyUuid = json['company_uuid'];
    companyName = json['company_name'];
    companyNameLanguage = json['company_name_language'];
    companyDetails = json['company_details'];
    companyPocUserName = json['company_poc_user_name'];
    companyPocUserMobile = json['company_poc_user_mobile'];
    companyStatus = json['company_status'];
    if (json['company_addres_info'] != null) {
      companyAddresInfo = [];
      json['company_addres_info'].forEach((v) {
        companyAddresInfo?.add(CompanyAddresInfo.fromJson(v));
      });
    }
    if (json['company_likeDislikeRatings_info'] != null) {
      companyLikeDislikeRatingsInfo = [];
      json['company_likeDislikeRatings_info'].forEach((v) {
        companyLikeDislikeRatingsInfo?.add(CompanyLikeDislikeRatingsInfo.fromJson(v));
      });
    }
  }
  String? companyId;
  String? companyUuid;
  String? companyName;
  String? companyNameLanguage;
  String? companyDetails;
  String? companyPocUserName;
  String? companyPocUserMobile;
  String? companyStatus;
  List<CompanyAddresInfo>? companyAddresInfo;
  List<CompanyLikeDislikeRatingsInfo>? companyLikeDislikeRatingsInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = companyId;
    map['company_uuid'] = companyUuid;
    map['company_name'] = companyName;
    map['company_name_language'] = companyNameLanguage;
    map['company_details'] = companyDetails;
    map['company_poc_user_name'] = companyPocUserName;
    map['company_poc_user_mobile'] = companyPocUserMobile;
    map['company_status'] = companyStatus;
    if (companyAddresInfo != null) {
      map['company_addres_info'] = companyAddresInfo?.map((v) => v.toJson()).toList();
    }
    if (companyLikeDislikeRatingsInfo != null) {
      map['company_likeDislikeRatings_info'] = companyLikeDislikeRatingsInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CompanyLikeDislikeRatingsInfo {
  CompanyLikeDislikeRatingsInfo({
      this.likeratingsActionCode, 
      this.likeratingsActionName, 
      this.likeratingsActionCount, 
      this.likeratingsActionValue,});

  CompanyLikeDislikeRatingsInfo.fromJson(dynamic json) {
    likeratingsActionCode = json['likeratings_action_code'];
    likeratingsActionName = json['likeratings_action_name '];
    likeratingsActionCount = json['likeratings_action_count'];
    likeratingsActionValue = json['likeratings_action_value'];
  }
  String? likeratingsActionCode;
  String? likeratingsActionName;
  String? likeratingsActionCount;
  String? likeratingsActionValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['likeratings_action_code'] = likeratingsActionCode;
    map['likeratings_action_name '] = likeratingsActionName;
    map['likeratings_action_count'] = likeratingsActionCount;
    map['likeratings_action_value'] = likeratingsActionValue;
    return map;
  }

}

class CompanyAddresInfo {
  CompanyAddresInfo({
      this.addressId, 
      this.addressReferenceFrom, 
      this.addressReferenceUuid, 
      this.addressType, 
      this.addressAddress, 
      this.addressZipcode, 
      this.addressGeoCode, 
      this.addressGeoAddress, 
      this.addressStatus, 
      this.locationInfo,});

  CompanyAddresInfo.fromJson(dynamic json) {
    addressId = json['address_id'];
    addressReferenceFrom = json['address_reference_from'];
    addressReferenceUuid = json['address_reference_uuid'];
    addressType = json['address_type'];
    addressAddress = json['address_address'];
    addressZipcode = json['address_zipcode'];
    addressGeoCode = json['address_geo_code'];
    addressGeoAddress = json['address_geo_address'];
    addressStatus = json['address_status'];
    locationInfo = json['location_info'] != null ? LocationInfo.fromJson(json['location_info']) : null;
  }
  String? addressId;
  String? addressReferenceFrom;
  String? addressReferenceUuid;
  String? addressType;
  String? addressAddress;
  String? addressZipcode;
  String? addressGeoCode;
  String? addressGeoAddress;
  String? addressStatus;
  LocationInfo? locationInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address_id'] = addressId;
    map['address_reference_from'] = addressReferenceFrom;
    map['address_reference_uuid'] = addressReferenceUuid;
    map['address_type'] = addressType;
    map['address_address'] = addressAddress;
    map['address_zipcode'] = addressZipcode;
    map['address_geo_code'] = addressGeoCode;
    map['address_geo_address'] = addressGeoAddress;
    map['address_status'] = addressStatus;
    if (locationInfo != null) {
      map['location_info'] = locationInfo?.toJson();
    }
    return map;
  }

}

class LocationInfo {
  LocationInfo({
      this.countryId, 
      this.countryName, 
      this.countryNameDisplay, 
      this.stateId, 
      this.stateName, 
      this.stateNameDisplay, 
      this.cityId, 
      this.cityName, 
      this.cityNameDisplay,});

  LocationInfo.fromJson(dynamic json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryNameDisplay = json['country_name_display'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateNameDisplay = json['state_name_display'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    cityNameDisplay = json['city_name_display'];
  }
  String? countryId;
  String? countryName;
  String? countryNameDisplay;
  String? stateId;
  String? stateName;
  String? stateNameDisplay;
  String? cityId;
  String? cityName;
  String? cityNameDisplay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_id'] = countryId;
    map['country_name'] = countryName;
    map['country_name_display'] = countryNameDisplay;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['state_name_display'] = stateNameDisplay;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['city_name_display'] = cityNameDisplay;
    return map;
  }

}