import 'attachment_model.dart';

class ChickPriceModel {
  ChickPriceModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  ChickPriceModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ChickPriceModel.fromJson(v));
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
    this.chicksaleId,
    this.chicksaleUuid,
    this.chicksaleQty,
    this.chicksaleCost,
    this.chicksaleEffectFrom,
    this.chickaleEffectTo,
    this.isSpecialSale,
    this.birdAgeInDays,
    this.birdWeightInGrams,
    this.chicksaleComment,
    this.chicksaleStatus,
    this.chicksaleCreatedon,
    this.chicksaleUpdatedon,
    this.birdBreedInfo,
    this.userBasicInfo,
    this.companyBasicInfo,
    this.attachmentInfo,
    this.addressDetails,
  });

  ApiResponse.fromJson(dynamic json) {
    chicksaleId = json['chicksale_id'];
    chicksaleUuid = json['chicksale_uuid'];
    chicksaleQty = json['chicksale_qty'];
    chicksaleCost = json['chicksale_cost'];
    chicksaleEffectFrom = json['chicksale_effect_from'];
    chickaleEffectTo = json['chickale_effect_to'];
    isSpecialSale = json['is_special_sale'];
    birdAgeInDays = json['bird_age_in_days'];
    birdWeightInGrams = json['bird_weight_in_grams'];
    chicksaleComment = json['chicksale_comment'];
    chicksaleStatus = json['chicksale_status'];
    chicksaleCreatedon = json['chicksale_createdon'];
    chicksaleUpdatedon = json['chicksale_updatedon'];
    if (json['bird_breed_info'] != null) {
      birdBreedInfo = [];
      json['bird_breed_info'].forEach((v) {
        birdBreedInfo?.add(BirdBreedInfo.fromJson(v));
      });
    }
    if (json['user_basic_info'] != null) {
      userBasicInfo = [];
      json['user_basic_info'].forEach((v) {
        userBasicInfo?.add(UserBasicInfo.fromJson(v));
      });
    }
    if (json['company_basic_info'] != null) {
      companyBasicInfo = [];
      json['company_basic_info'].forEach((v) {
        companyBasicInfo?.add(CompanyBasicInfo.fromJson(v));
      });
    }
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
    if (json['address_details'] != null) {
      addressDetails = [];
      json['address_details'].forEach((v) {
        addressDetails?.add(AddressDetails.fromJson(v));
      });
    }
  }

  String? chicksaleId;
  String? chicksaleUuid;
  int? chicksaleQty;
  String? chicksaleCost;
  String? chicksaleEffectFrom;
  String? chickaleEffectTo;
  String? isSpecialSale;
  int? birdAgeInDays;
  int? birdWeightInGrams;
  String? chicksaleComment;
  String? chicksaleStatus;
  String? chicksaleCreatedon;
  String? chicksaleUpdatedon;
  List<BirdBreedInfo>? birdBreedInfo;
  List<UserBasicInfo>? userBasicInfo;
  List<CompanyBasicInfo>? companyBasicInfo;
  List<AttachmentInfo>? attachmentInfo;
  List<AddressDetails>? addressDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chicksale_id'] = chicksaleId;
    map['chicksale_uuid'] = chicksaleUuid;
    map['chicksale_qty'] = chicksaleQty;
    map['chicksale_cost'] = chicksaleCost;
    map['chicksale_effect_from'] = chicksaleEffectFrom;
    map['chickale_effect_to'] = chickaleEffectTo;
    map['is_special_sale'] = isSpecialSale;
    map['bird_age_in_days'] = birdAgeInDays;
    map['bird_weight_in_grams'] = birdWeightInGrams;
    map['chicksale_comment'] = chicksaleComment;
    map['chicksale_status'] = chicksaleStatus;
    map['chicksale_createdon'] = chicksaleCreatedon;
    map['chicksale_updatedon'] = chicksaleUpdatedon;
    if (birdBreedInfo != null) {
      map['bird_breed_info'] = birdBreedInfo?.map((v) => v.toJson()).toList();
    }
    if (userBasicInfo != null) {
      map['user_basic_info'] = userBasicInfo?.map((v) => v.toJson()).toList();
    }
    if (companyBasicInfo != null) {
      map['company_basic_info'] =
          companyBasicInfo?.map((v) => v.toJson()).toList();
    }
    if (attachmentInfo != null) {
      map['attachment_info'] = attachmentInfo?.map((v) => v.toJson()).toList();
    }
    if (addressDetails != null) {
      map['address_details'] = addressDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AddressDetails {
  AddressDetails({
    this.countryId,
    this.countryName,
    this.countryNameLanguage,
    this.stateId,
    this.stateName,
    this.stateNameLanguage,
    this.cityId,
    this.cityName,
    this.cityNameLanguage,
  });

  AddressDetails.fromJson(dynamic json) {
    countryId = json['country_id'];
    countryName = json['country_name'];
    countryNameLanguage = json['country_name_language'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateNameLanguage = json['state_name_language'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    cityNameLanguage = json['city_name_language'];
  }

  String? countryId;
  String? countryName;
  String? countryNameLanguage;
  String? stateId;
  String? stateName;
  String? stateNameLanguage;
  String? cityId;
  String? cityName;
  String? cityNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_id'] = countryId;
    map['country_name'] = countryName;
    map['country_name_language'] = countryNameLanguage;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['state_name_language'] = stateNameLanguage;
    map['city_id'] = cityId;
    map['city_name'] = cityName;
    map['city_name_language'] = cityNameLanguage;
    return map;
  }
}

class CompanyBasicInfo {
  CompanyBasicInfo({
    this.companyId,
    this.companyUuid,
    this.companyName,
    this.companyNameLanguage,
  });

  CompanyBasicInfo.fromJson(dynamic json) {
    companyId = json['company_id'];
    companyUuid = json['company_uuid'];
    companyName = json['company_name'];
    companyNameLanguage = json['company_name_language'];
  }

  String? companyId;
  String? companyUuid;
  String? companyName;
  String? companyNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = companyId;
    map['company_uuid'] = companyUuid;
    map['company_name'] = companyName;
    map['company_name_language'] = companyNameLanguage;
    return map;
  }
}

class UserBasicInfo {
  UserBasicInfo({
    this.userId,
    this.userUuid,
    this.userFirstName,
    this.userLastName,
    this.userMobile,
    this.userEmail,
    this.userRoleType,
    this.userWorkType,
    this.userIsVerfied,
  });

  UserBasicInfo.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userMobile = json['user_mobile'];
    userEmail = json['user_email'];
    userRoleType = json['user_role_type'];
    userWorkType = json['user_work_type'];
    userIsVerfied = json['user_is_verfied'];
  }

  String? userId;
  String? userUuid;
  String? userFirstName;
  String? userLastName;
  String? userMobile;
  String? userEmail;
  String? userRoleType;
  String? userWorkType;
  String? userIsVerfied;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_mobile'] = userMobile;
    map['user_email'] = userEmail;
    map['user_role_type'] = userRoleType;
    map['user_work_type'] = userWorkType;
    map['user_is_verfied'] = userIsVerfied;
    return map;
  }
}

class BirdBreedInfo {
  BirdBreedInfo({
    this.birdbreedId,
    this.birdbreedName,
    this.birdbreedSno,
    this.birdbreedNameLanguage,
  });

  BirdBreedInfo.fromJson(dynamic json) {
    birdbreedId = json['birdbreed_id'];
    birdbreedName = json['birdbreed_name'];
    birdbreedSno = json['birdbreed_sno'];
    birdbreedNameLanguage = json['birdbreed_name_language'];
  }

  String? birdbreedId;
  String? birdbreedName;
  String? birdbreedSno;
  String? birdbreedNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['birdbreed_id'] = birdbreedId;
    map['birdbreed_name'] = birdbreedName;
    map['birdbreed_sno'] = birdbreedSno;
    map['birdbreed_name_language'] = birdbreedNameLanguage;
    return map;
  }
}
