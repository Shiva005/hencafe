class LiftingPriceModel {
  LiftingPriceModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  LiftingPriceModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(LiftingPriceModel.fromJson(v));
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
    this.liftingsaleId,
    this.liftingsaleUuid,
    this.liftingsaleTotalBirds,
    this.liftingsaleCostPerKg,
    this.birdAgeInDays,
    this.birdWeightInKg,
    this.liftingsaleEffectFrom,
    this.liftingsaleEffectTo,
    this.liftingsaleAddress,
    this.liftingsaleComment,
    this.liftingsaleStatus,
    this.liftingsaleCreatedon,
    this.liftingsaleUpdatedon,
    this.birdBreedInfo,
    this.userBasicInfo,
    this.attachmentInfo,
    this.addressDetails,
  });

  ApiResponse.fromJson(dynamic json) {
    liftingsaleId = json['liftingsale_id'];
    liftingsaleUuid = json['liftingsale_uuid'];
    liftingsaleTotalBirds = json['liftingsale_total_birds'];
    liftingsaleCostPerKg = json['liftingsale_cost_per_kg'];
    birdAgeInDays = json['bird_age_in_days'];
    birdWeightInKg = json['bird_weight_in_kg'];
    liftingsaleEffectFrom = json['liftingsale_effect_from'];
    liftingsaleEffectTo = json['liftingsale_effect_to'];
    liftingsaleAddress = json['liftingsale_address'];
    liftingsaleComment = json['liftingsale_comment'];
    liftingsaleStatus = json['liftingsale_status'];
    liftingsaleCreatedon = json['liftingsale_createdon'];
    liftingsaleUpdatedon = json['liftingsale_updatedon'];
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

  String? liftingsaleId;
  String? liftingsaleUuid;
  int? liftingsaleTotalBirds;
  String? liftingsaleCostPerKg;
  String? birdAgeInDays;
  String? birdWeightInKg;
  String? liftingsaleEffectFrom;
  String? liftingsaleEffectTo;
  String? liftingsaleAddress;
  String? liftingsaleComment;
  String? liftingsaleStatus;
  String? liftingsaleCreatedon;
  String? liftingsaleUpdatedon;
  List<BirdBreedInfo>? birdBreedInfo;
  List<UserBasicInfo>? userBasicInfo;
  List<AttachmentInfo>? attachmentInfo;
  List<AddressDetails>? addressDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['liftingsale_id'] = liftingsaleId;
    map['liftingsale_uuid'] = liftingsaleUuid;
    map['liftingsale_total_birds'] = liftingsaleTotalBirds;
    map['liftingsale_cost_per_kg'] = liftingsaleCostPerKg;
    map['bird_age_in_days'] = birdAgeInDays;
    map['bird_weight_in_kg'] = birdWeightInKg;
    map['liftingsale_effect_from'] = liftingsaleEffectFrom;
    map['liftingsale_effect_to'] = liftingsaleEffectTo;
    map['liftingsale_address'] = liftingsaleAddress;
    map['liftingsale_comment'] = liftingsaleComment;
    map['liftingsale_status'] = liftingsaleStatus;
    map['liftingsale_createdon'] = liftingsaleCreatedon;
    map['liftingsale_updatedon'] = liftingsaleUpdatedon;
    if (birdBreedInfo != null) {
      map['bird_breed_info'] = birdBreedInfo?.map((v) => v.toJson()).toList();
    }
    if (userBasicInfo != null) {
      map['user_basic_info'] = userBasicInfo?.map((v) => v.toJson()).toList();
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
    this.attachmentType,
    this.attachmentName,
    this.attachmentStatus,
    this.attachmentCreatedon,
  });

  AttachmentInfo.fromJson(dynamic json) {
    attachmentId = json['attachment_id'];
    attachmentReferenceCode = json['attachment_reference_code'];
    attachmentReferenceUuid = json['attachment_reference_uuid'];
    attachmentPath = json['attachment_path'];
    attachmentType = json['attachment_type'];
    attachmentName = json['attachment_name'];
    attachmentStatus = json['attachment_status'];
    attachmentCreatedon = json['attachment_createdon'];
  }

  String? attachmentId;
  String? attachmentReferenceCode;
  String? attachmentReferenceUuid;
  String? attachmentPath;
  String? attachmentType;
  String? attachmentName;
  String? attachmentStatus;
  String? attachmentCreatedon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attachment_id'] = attachmentId;
    map['attachment_reference_code'] = attachmentReferenceCode;
    map['attachment_reference_uuid'] = attachmentReferenceUuid;
    map['attachment_path'] = attachmentPath;
    map['attachment_type'] = attachmentType;
    map['attachment_name'] = attachmentName;
    map['attachment_status'] = attachmentStatus;
    map['attachment_createdon'] = attachmentCreatedon;
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
