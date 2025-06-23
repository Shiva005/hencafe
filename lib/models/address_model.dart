class AddressModel {
  AddressModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,});

  AddressModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(AddressModel.fromJson(v));
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
    this.addressId,
    this.addressUuid,
    this.addressReferenceFrom,
    this.addressReferenceUuid,
    this.addressType,
    this.addressAddress,
    this.addressZipcode,
    this.addressGeoCode,
    this.addressGeoAddress,
    this.addressStatus,
    this.locationInfo,
    this.attachmentInfo,
    this.userBasicInfo,});

  ApiResponse.fromJson(dynamic json) {
    addressId = json['address_id'];
    addressUuid = json['address_uuid'];
    addressReferenceFrom = json['address_reference_from'];
    addressReferenceUuid = json['address_reference_uuid'];
    addressType = json['address_type'];
    addressAddress = json['address_address'];
    addressZipcode = json['address_zipcode'];
    addressGeoCode = json['address_geo_code'];
    addressGeoAddress = json['address_geo_address'];
    addressStatus = json['address_status'];
    if (json['location_info'] != null) {
      locationInfo = [];
      json['location_info'].forEach((v) {
        locationInfo?.add(LocationInfo.fromJson(v));
      });
    }
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
    if (json['user_basic_info'] != null) {
      userBasicInfo = [];
      json['user_basic_info'].forEach((v) {
        userBasicInfo?.add(UserBasicInfo.fromJson(v));
      });
    }
  }

  String? addressId;
  String? addressUuid;
  String? addressReferenceFrom;
  String? addressReferenceUuid;
  String? addressType;
  String? addressAddress;
  String? addressZipcode;
  String? addressGeoCode;
  String? addressGeoAddress;
  String? addressStatus;
  List<LocationInfo>? locationInfo;
  List<AttachmentInfo>? attachmentInfo;
  List<UserBasicInfo>? userBasicInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address_id'] = addressId;
    map['address_uuid'] = addressUuid;
    map['address_reference_from'] = addressReferenceFrom;
    map['address_reference_uuid'] = addressReferenceUuid;
    map['address_type'] = addressType;
    map['address_address'] = addressAddress;
    map['address_zipcode'] = addressZipcode;
    map['address_geo_code'] = addressGeoCode;
    map['address_geo_address'] = addressGeoAddress;
    map['address_status'] = addressStatus;
    if (locationInfo != null) {
      map['location_info'] = locationInfo?.map((v) => v.toJson()).toList();
    }
    if (attachmentInfo != null) {
      map['attachment_info'] = attachmentInfo?.map((v) => v.toJson()).toList();
    }
    if (userBasicInfo != null) {
      map['user_basic_info'] = userBasicInfo?.map((v) => v.toJson()).toList();
    }
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
    this.userIsVerfied,});

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

class AttachmentInfo {
  AttachmentInfo({
    this.attachmentId,
    this.attachmentReferenceCode,
    this.attachmentReferenceUuid,
    this.attachmentPath,
    this.attachmentType,
    this.attachmentName,
    this.attachmentStatus,
    this.attachmentCreatedon,});

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

class LocationInfo {
  LocationInfo({
    this.countryId,
    this.countryName,
    this.countryNameLanguage,
    this.stateId,
    this.stateName,
    this.stateNameLanguage,
    this.cityId,
    this.cityName,
    this.cityNameLanguage,});

  LocationInfo.fromJson(dynamic json) {
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