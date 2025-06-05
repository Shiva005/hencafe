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
    this.eggsaleId,
    this.eggsaleUuid,
    this.eggsaleQty,
    this.eggsaleCost,
    this.eggsaleEffectFrom,
    this.eggsaleEffectTo,
    this.isSpecialSale,
    this.isHatchingEgg,
    this.eggsaleComment,
    this.eggsaleStatus,
    this.eggsaleCreatedon,
    this.eggsaleUpdatedon,
    this.birdBreedInfo,
    this.userBasicInfo,
    this.companyBasicInfo,
    this.attachmentInfo,
    this.addressDetails,
  });

  ApiResponse.fromJson(dynamic json) {
    eggsaleId = json['eggsale_id'];
    eggsaleUuid = json['eggsale_uuid'];
    eggsaleQty = json['eggsale_qty'];
    eggsaleCost = json['eggsale_cost'];
    eggsaleEffectFrom = json['eggsale_effect_from'];
    eggsaleEffectTo = json['eggsale_effect_to'];
    isSpecialSale = json['is_special_sale'];
    isHatchingEgg = json['is_hatching_egg'];
    eggsaleComment = json['eggsale_comment'];
    eggsaleStatus = json['eggsale_status'];
    eggsaleCreatedon = json['eggsale_createdon'];
    eggsaleUpdatedon = json['eggsale_updatedon'];
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

  String? eggsaleId;
  String? eggsaleUuid;
  int? eggsaleQty;
  String? eggsaleCost;
  String? eggsaleEffectFrom;
  String? eggsaleEffectTo;
  String? isSpecialSale;
  String? isHatchingEgg;
  String? eggsaleComment;
  String? eggsaleStatus;
  String? eggsaleCreatedon;
  String? eggsaleUpdatedon;
  List<BirdBreedInfo>? birdBreedInfo;
  List<UserBasicInfo>? userBasicInfo;
  List<CompanyBasicInfo>? companyBasicInfo;
  List<AttachmentInfo>? attachmentInfo;
  List<AddressDetails>? addressDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eggsale_id'] = eggsaleId;
    map['eggsale_uuid'] = eggsaleUuid;
    map['eggsale_qty'] = eggsaleQty;
    map['eggsale_cost'] = eggsaleCost;
    map['eggsale_effect_from'] = eggsaleEffectFrom;
    map['eggsale_effect_to'] = eggsaleEffectTo;
    map['is_special_sale'] = isSpecialSale;
    map['is_hatching_egg'] = isHatchingEgg;
    map['eggsale_comment'] = eggsaleComment;
    map['eggsale_status'] = eggsaleStatus;
    map['eggsale_createdon'] = eggsaleCreatedon;
    map['eggsale_updatedon'] = eggsaleUpdatedon;
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

class AttachmentInfo {
  AttachmentInfo({
    this.attachmentId,
    this.attachmentReferenceCode,
    this.attachmentReferenceUuid,
    this.attachmentPath,
    this.attachmentStatus,
    this.attachmentCreatedon,
  });

  AttachmentInfo.fromJson(dynamic json) {
    attachmentId = json['attachment_id'];
    attachmentReferenceCode = json['attachment_reference_code'];
    attachmentReferenceUuid = json['attachment_reference_uuid'];
    attachmentPath = json['attachment_path'];
    attachmentStatus = json['attachment_status'];
    attachmentCreatedon = json['attachment_createdon'];
  }

  String? attachmentId;
  String? attachmentReferenceCode;
  String? attachmentReferenceUuid;
  String? attachmentPath;
  String? attachmentStatus;
  String? attachmentCreatedon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attachment_id'] = attachmentId;
    map['attachment_reference_code'] = attachmentReferenceCode;
    map['attachment_reference_uuid'] = attachmentReferenceUuid;
    map['attachment_path'] = attachmentPath;
    map['attachment_status'] = attachmentStatus;
    map['attachment_createdon'] = attachmentCreatedon;
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
