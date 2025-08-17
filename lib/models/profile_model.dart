import 'package:hencafe/models/state_model.dart';
import 'package:hencafe/models/user_fav_state_info.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';

import 'address_details_model.dart';
import 'attachment_model.dart';
import 'membership_model.dart';
import 'supply_model.dart';

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
    this.userFirstName,
    this.userLastName,
    this.userMobile,
    this.userEmail,
    this.userDob,
    this.userRoleType,
    this.userWorkType,
    this.userLoginUid,
    this.userLoginValidFrom,
    this.userLoginValidTo,
    this.userLoginStatus,
    this.userIsVerfied,
    this.userFavouriteStateInfo,
    this.userMembershipInfo,
    this.attachmentInfo,
    this.userProfileImg,
    this.userBannerImg,
    this.supplyInfo,
    this.addressDetails,
  });

  ApiResponse.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userMobile = json['user_mobile'];
    userEmail = json['user_email'];
    userDob = json['user_dob'];
    userRoleType = json['user_role_type'];
    userWorkType = json['user_work_type'] != null
        ? UserWorkType.fromJson(json['user_work_type'])
        : null;
    userLoginUid = json['user_login_uid'];
    userLoginValidFrom = json['user_login_valid_from'];
    userLoginValidTo = json['user_login_valid_to'];
    userLoginStatus = json['user_login_status'];
    userIsVerfied = json['user_is_verfied'];
    if (json['user_favourite_state_info'] != null) {
      userFavouriteStateInfo = [];
      json['user_favourite_state_info'].forEach((v) {
        userFavouriteStateInfo?.add(UserFavouriteStateInfo.fromJson(v));
      });
    }
    if (json['user_membership_info'] != null) {
      userMembershipInfo = [];
      json['user_membership_info'].forEach((v) {
        userMembershipInfo?.add(UserMembershipInfo.fromJson(v));
      });
    }
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
    if (json['user_profile_img'] != null) {
      userProfileImg = [];
      json['user_profile_img'].forEach((v) {
        userProfileImg?.add(UserProfileImg.fromJson(v));
      });
    }
    if (json['user_banner_img'] != null) {
      userBannerImg = [];
      json['user_banner_img'].forEach((v) {
        userBannerImg?.add(UserBannerImg.fromJson(v));
      });
    }
    if (json['supply_info'] != null) {
      supplyInfo = [];
      json['supply_info'].forEach((v) {
        supplyInfo?.add(SupplyInfo.fromJson(v));
      });
    }
    if (json['address_details'] != null) {
      addressDetails = [];
      json['address_details'].forEach((v) {
        addressDetails?.add(AddressDetails.fromJson(v));
      });
    }
  }

  String? userId;
  String? userUuid;
  String? userFirstName;
  String? userLastName;
  String? userMobile;
  String? userEmail;
  String? userDob;
  String? userRoleType;
  UserWorkType? userWorkType;
  String? userLoginUid;
  String? userLoginValidFrom;
  String? userLoginValidTo;
  String? userLoginStatus;
  String? userIsVerfied;
  List<UserFavouriteStateInfo>? userFavouriteStateInfo;
  List<UserMembershipInfo>? userMembershipInfo;
  List<AttachmentInfo>? attachmentInfo;
  List<UserProfileImg>? userProfileImg;
  List<UserBannerImg>? userBannerImg;
  List<SupplyInfo>? supplyInfo;
  List<AddressDetails>? addressDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_mobile'] = userMobile;
    map['user_email'] = userEmail;
    map['user_dob'] = userDob;
    map['user_role_type'] = userRoleType;
    if (userWorkType != null) {
      map['user_work_type'] = userWorkType?.toJson();
    }
    map['user_login_uid'] = userLoginUid;
    map['user_login_valid_from'] = userLoginValidFrom;
    map['user_login_valid_to'] = userLoginValidTo;
    map['user_login_status'] = userLoginStatus;
    map['user_is_verfied'] = userIsVerfied;
    if (userFavouriteStateInfo != null) {
      map['user_favourite_state_info'] =
          userFavouriteStateInfo?.map((v) => v.toJson()).toList();
    }
    if (userMembershipInfo != null) {
      map['user_membership_info'] =
          userMembershipInfo?.map((v) => v.toJson()).toList();
    }
    if (attachmentInfo != null) {
      map['attachment_info'] = attachmentInfo?.map((v) => v.toJson()).toList();
    }
    if (userProfileImg != null) {
      map['user_profile_img'] = userProfileImg?.map((v) => v.toJson()).toList();
    }
    if (userBannerImg != null) {
      map['user_banner_img'] = userBannerImg?.map((v) => v.toJson()).toList();
    }
    if (supplyInfo != null) {
      map['supply_info'] = supplyInfo?.map((v) => v.toJson()).toList();
    }
    if (addressDetails != null) {
      map['address_details'] = addressDetails?.map((v) => v.toJson()).toList();
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
    this.cityNameLanguage,
  });

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

class UserBannerImg {
  UserBannerImg({
    this.attachmentId,
    this.attachmentReferenceCode,
    this.attachmentReferenceUuid,
    this.attachmentPath,
    this.attachmentType,
    this.attachmentName,
    this.attachmentStatus,
    this.attachmentCreatedon,
  });

  UserBannerImg.fromJson(dynamic json) {
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

class UserProfileImg {
  UserProfileImg({
    this.attachmentId,
    this.attachmentReferenceCode,
    this.attachmentReferenceUuid,
    this.attachmentPath,
    this.attachmentType,
    this.attachmentName,
    this.attachmentStatus,
    this.attachmentCreatedon,
  });

  UserProfileImg.fromJson(dynamic json) {
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

class UserWorkType {
  UserWorkType({
    this.code,
    this.value,
  });

  UserWorkType.fromJson(dynamic json) {
    code = json['code'];
    value = json['value'];
  }

  String? code;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['value'] = value;
    return map;
  }
}
