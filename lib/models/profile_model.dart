class ProfileModel {
  ProfileModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  ProfileModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ProfileModel.fromJson(v));
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
    this.userId,
    this.userUuid,
    this.authUuid,
    this.userFirstName,
    this.userLastName,
    this.userMobilePrimary,
    this.userEmail,
    this.userHideMobile,
    this.userHideEmail,
    this.userHideProfileImage,
    this.userRoleType,
    this.userRoleTypeLanguage,
    this.userFavStateMaxCount,
    this.userFavouriteStateInfo,
    this.userLoginUid,
    this.userLoginStatus,
    this.userLoginStatusLanguage,
    this.userStatus,
    this.userStatusLanguage,
    this.userIsFarmer,
    this.userIsTrader,
    this.userIsSupplier,
    this.userIsDoctor,
    this.userReferralCode,
    this.addressInfo,
    this.userProfileImg,
  });

  ApiResponse.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    authUuid = json['auth_uuid'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userMobilePrimary = json['user_mobile_primary'];
    userEmail = json['user_email'];
    userHideMobile = json['user_hide_mobile'];
    userHideEmail = json['user_hide_email'];
    userHideProfileImage = json['user_hide_profile_image'];
    userRoleType = json['user_role_type'];
    userRoleTypeLanguage = json['user_role_type_language'];
    userFavStateMaxCount = json['user_fav_state_max_count'];
    if (json['user_favourite_state_info'] != null) {
      userFavouriteStateInfo = [];
      json['user_favourite_state_info'].forEach((v) {
        userFavouriteStateInfo?.add(UserFavouriteStateInfo.fromJson(v));
      });
    }
    userLoginUid = json['user_login_uid'];
    userLoginStatus = json['user_login_status'];
    userLoginStatusLanguage = json['user_login_status_language'];
    userStatus = json['user_status'];
    userStatusLanguage = json['user_status_language'];
    userIsFarmer = json['user_is_farmer'];
    userIsTrader = json['user_is_trader'];
    userIsSupplier = json['user_is_supplier'];
    userIsDoctor = json['user_is_doctor'];
    userReferralCode = json['user_referral_code'];
    if (json['address_info'] != null) {
      addressInfo = [];
      json['address_info'].forEach((v) {
        addressInfo?.add(AddressInfo.fromJson(v));
      });
    }
    if (json['user_profile_img'] != null) {
      userProfileImg = [];
      json['user_profile_img'].forEach((v) {
        userProfileImg?.add(UserProfileImg.fromJson(v));
      });
    }
  }

  String? userId;
  String? userUuid;
  String? authUuid;
  String? userFirstName;
  String? userLastName;
  String? userMobilePrimary;
  String? userEmail;
  String? userHideMobile;
  String? userHideEmail;
  String? userHideProfileImage;
  String? userRoleType;
  String? userRoleTypeLanguage;
  String? userFavStateMaxCount;
  List<UserFavouriteStateInfo>? userFavouriteStateInfo;
  String? userLoginUid;
  String? userLoginStatus;
  String? userLoginStatusLanguage;
  String? userStatus;
  String? userStatusLanguage;
  String? userIsFarmer;
  String? userIsTrader;
  String? userIsSupplier;
  String? userIsDoctor;
  String? userReferralCode;
  List<AddressInfo>? addressInfo;
  List<UserProfileImg>? userProfileImg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['auth_uuid'] = authUuid;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_mobile_primary'] = userMobilePrimary;
    map['user_email'] = userEmail;
    map['user_hide_mobile'] = userHideMobile;
    map['user_hide_email'] = userHideEmail;
    map['user_hide_profile_image'] = userHideProfileImage;
    map['user_role_type'] = userRoleType;
    map['user_role_type_language'] = userRoleTypeLanguage;
    map['user_fav_state_max_count'] = userFavStateMaxCount;
    if (userFavouriteStateInfo != null) {
      map['user_favourite_state_info'] =
          userFavouriteStateInfo?.map((v) => v.toJson()).toList();
    }
    map['user_login_uid'] = userLoginUid;
    map['user_login_status'] = userLoginStatus;
    map['user_login_status_language'] = userLoginStatusLanguage;
    map['user_status'] = userStatus;
    map['user_status_language'] = userStatusLanguage;
    map['user_is_farmer'] = userIsFarmer;
    map['user_is_trader'] = userIsTrader;
    map['user_is_supplier'] = userIsSupplier;
    map['user_is_doctor'] = userIsDoctor;
    map['user_referral_code'] = userReferralCode;
    if (addressInfo != null) {
      map['address_info'] = addressInfo?.map((v) => v.toJson()).toList();
    }
    if (userProfileImg != null) {
      map['user_profile_img'] = userProfileImg?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserProfileImg {
  UserProfileImg({
    this.attachmentId,
    this.attachmentReferenceCode,
    this.attachmentReferenceUuid,
    this.attachmentPath,
    this.attachmentCreatedon,
  });

  UserProfileImg.fromJson(dynamic json) {
    attachmentId = json['attachment_id '];
    attachmentReferenceCode = json['attachment_reference_code'];
    attachmentReferenceUuid = json['attachment_reference_uuid'];
    attachmentPath = json['attachment_path'];
    attachmentCreatedon = json['attachment_createdon'];
  }

  String? attachmentId;
  String? attachmentReferenceCode;
  String? attachmentReferenceUuid;
  String? attachmentPath;
  String? attachmentCreatedon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attachment_id '] = attachmentId;
    map['attachment_reference_code'] = attachmentReferenceCode;
    map['attachment_reference_uuid'] = attachmentReferenceUuid;
    map['attachment_path'] = attachmentPath;
    map['attachment_createdon'] = attachmentCreatedon;
    return map;
  }
}

class AddressInfo {
  AddressInfo({
    this.addressId,
    this.addressReferenceFrom,
    this.addressReferenceUuid,
    this.addressType,
    this.addressAddress,
    this.addressZipcode,
    this.addressGeoCode,
    this.addressGeoAddress,
    this.addressStatus,
    this.locationInfo,
  });

  AddressInfo.fromJson(dynamic json) {
    addressId = json['address_id'];
    addressReferenceFrom = json['address_reference_from'];
    addressReferenceUuid = json['address_reference_uuid'];
    addressType = json['address_type'];
    addressAddress = json['address_address'];
    addressZipcode = json['address_zipcode'];
    addressGeoCode = json['address_geo_code'];
    addressGeoAddress = json['address_geo_address'];
    addressStatus = json['address_status'];
    locationInfo = json['location_info'] != null
        ? LocationInfo.fromJson(json['location_info'])
        : null;
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

class UserFavouriteStateInfo {
  UserFavouriteStateInfo({
    this.stateId,
    this.stateName,
    this.stateNameLanguage,
  });

  UserFavouriteStateInfo.fromJson(dynamic json) {
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
