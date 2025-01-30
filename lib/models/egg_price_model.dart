class EggPriceModel {
  EggPriceModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  EggPriceModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(EggPriceModel.fromJson(v));
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
    this.eggpriceId,
    this.eggpriceUuid,
    this.eggpriceQty,
    this.eggpriceCost,
    this.eggpricePriceEffectFromdate,
    this.eggpricePriceEffectFromdateDisplay,
    this.eggpriceSaleType,
    this.isHatchingEgg,
    this.eggpriceStatus,
    this.birdbreedInfo,
    this.locationInfo,
    this.companyInfo,
    this.userInfo,
    this.eggpriceImages,
  });

  ApiResponse.fromJson(dynamic json) {
    eggpriceId = json['eggprice_id'];
    eggpriceUuid = json['eggprice_uuid'];
    eggpriceQty = json['eggprice_qty'];
    eggpriceCost = json['eggprice_cost'];
    eggpricePriceEffectFromdate = json['eggprice_price_effect_fromdate'];
    eggpricePriceEffectFromdateDisplay =
        json['eggprice_price_effect_fromdate_display'];
    eggpriceSaleType = json['eggprice_sale_type'];
    isHatchingEgg = json['is_hatching_egg'];
    eggpriceStatus = json['eggprice_status'];
    birdbreedInfo = json['birdbreed_info'] != null
        ? BirdbreedInfo.fromJson(json['birdbreed_info'])
        : null;
    locationInfo = json['location_info'] != null
        ? LocationInfo.fromJson(json['location_info'])
        : null;
    companyInfo = json['company_info'] != null
        ? CompanyInfo.fromJson(json['company_info'])
        : null;
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    if (json['eggprice_images'] != null) {
      eggpriceImages = [];
      json['eggprice_images'].forEach((v) {
        eggpriceImages?.add(ApiResponse.fromJson(v));
      });
    }
  }

  String? eggpriceId;
  String? eggpriceUuid;
  String? eggpriceQty;
  String? eggpriceCost;
  String? eggpricePriceEffectFromdate;
  String? eggpricePriceEffectFromdateDisplay;
  String? eggpriceSaleType;
  String? isHatchingEgg;
  String? eggpriceStatus;
  BirdbreedInfo? birdbreedInfo;
  LocationInfo? locationInfo;
  CompanyInfo? companyInfo;
  UserInfo? userInfo;
  List<dynamic>? eggpriceImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eggprice_id'] = eggpriceId;
    map['eggprice_uuid'] = eggpriceUuid;
    map['eggprice_qty'] = eggpriceQty;
    map['eggprice_cost'] = eggpriceCost;
    map['eggprice_price_effect_fromdate'] = eggpricePriceEffectFromdate;
    map['eggprice_price_effect_fromdate_display'] =
        eggpricePriceEffectFromdateDisplay;
    map['eggprice_sale_type'] = eggpriceSaleType;
    map['is_hatching_egg'] = isHatchingEgg;
    map['eggprice_status'] = eggpriceStatus;
    if (birdbreedInfo != null) {
      map['birdbreed_info'] = birdbreedInfo?.toJson();
    }
    if (locationInfo != null) {
      map['location_info'] = locationInfo?.toJson();
    }
    if (companyInfo != null) {
      map['company_info'] = companyInfo?.toJson();
    }
    if (userInfo != null) {
      map['user_info'] = userInfo?.toJson();
    }
    if (eggpriceImages != null) {
      map['eggprice_images'] = eggpriceImages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserInfo {
  UserInfo({
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.userMobilePrimary,
    this.userHideMobile,
    this.userHideProfileImage,
    this.userImages,
  });

  UserInfo.fromJson(dynamic json) {
    userId = json['user_id'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userMobilePrimary = json['user_mobile_primary'];
    userHideMobile = json['user_hide_mobile'];
    userHideProfileImage = json['user_hide_profile_image'];
    if (json['user_images'] != null) {
      userImages = [];
      json['user_images'].forEach((v) {
        userImages?.add(UserInfo.fromJson(v));
      });
    }
  }

  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userMobilePrimary;
  String? userHideMobile;
  String? userHideProfileImage;
  List<dynamic>? userImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_mobile_primary'] = userMobilePrimary;
    map['user_hide_mobile'] = userHideMobile;
    map['user_hide_profile_image'] = userHideProfileImage;
    if (userImages != null) {
      map['user_images'] = userImages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CompanyInfo {
  CompanyInfo({
    this.companyId,
    this.companyUuid,
    this.companyName,
    this.companyNameDisplay,
    this.companyDetails,
    this.companyPocUserName,
    this.companyPocUserMobile,
    this.companyStatus,
  });

  CompanyInfo.fromJson(dynamic json) {
    companyId = json['company_id'];
    companyUuid = json['company_uuid'];
    companyName = json['company_name'];
    companyNameDisplay = json['company_name_display'];
    companyDetails = json['company_details'];
    companyPocUserName = json['company_poc_user_name'];
    companyPocUserMobile = json['company_poc_user_mobile'];
    companyStatus = json['company_status'];
  }

  String? companyId;
  String? companyUuid;
  String? companyName;
  String? companyNameDisplay;
  String? companyDetails;
  String? companyPocUserName;
  String? companyPocUserMobile;
  String? companyStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = companyId;
    map['company_uuid'] = companyUuid;
    map['company_name'] = companyName;
    map['company_name_display'] = companyNameDisplay;
    map['company_details'] = companyDetails;
    map['company_poc_user_name'] = companyPocUserName;
    map['company_poc_user_mobile'] = companyPocUserMobile;
    map['company_status'] = companyStatus;
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
    this.cityNameDisplay,
  });

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

class BirdbreedInfo {
  BirdbreedInfo({
    this.birdbreedId,
    this.birdbreedName,
    this.birdbreedNameLanguage,
    this.birdbreedSno,
    this.birdbreedStatus,
  });

  BirdbreedInfo.fromJson(dynamic json) {
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
