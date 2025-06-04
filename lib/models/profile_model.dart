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
    this.supplyInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    userId = json['user_id'];
    userUuid = json['user_uuid'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userMobile = json['user_mobile'];
    userEmail = json['user_email'];
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
    if (json['supply_info'] != null) {
      supplyInfo = [];
      json['supply_info'].forEach((v) {
        supplyInfo?.add(SupplyInfo.fromJson(v));
      });
    }
  }

  String? userId;
  String? userUuid;
  String? userFirstName;
  String? userLastName;
  String? userMobile;
  String? userEmail;
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
  List<SupplyInfo>? supplyInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_uuid'] = userUuid;
    map['user_first_name'] = userFirstName;
    map['user_last_name'] = userLastName;
    map['user_mobile'] = userMobile;
    map['user_email'] = userEmail;
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
    if (supplyInfo != null) {
      map['supply_info'] = supplyInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SupplyInfo {
  SupplyInfo({
    this.userCompanySupplytypeId,
    this.supplyReferenceFrom,
    this.supplyReferenceUuid,
    this.supplytypeId,
    this.supplytypeName,
    this.supplytypeNameLanguage,
  });

  SupplyInfo.fromJson(dynamic json) {
    userCompanySupplytypeId = json['user_company_supplytype_id'];
    supplyReferenceFrom = json['supply_reference_from'];
    supplyReferenceUuid = json['supply_reference_uuid'];
    supplytypeId = json['supplytype_id'];
    supplytypeName = json['supplytype_name'];
    supplytypeNameLanguage = json['supplytype_name_language'];
  }

  String? userCompanySupplytypeId;
  String? supplyReferenceFrom;
  String? supplyReferenceUuid;
  int? supplytypeId;
  String? supplytypeName;
  String? supplytypeNameLanguage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_company_supplytype_id'] = userCompanySupplytypeId;
    map['supply_reference_from'] = supplyReferenceFrom;
    map['supply_reference_uuid'] = supplyReferenceUuid;
    map['supplytype_id'] = supplytypeId;
    map['supplytype_name'] = supplytypeName;
    map['supplytype_name_language'] = supplytypeNameLanguage;
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

class UserMembershipInfo {
  UserMembershipInfo({
    this.userMembershipId,
    this.userUuid,
    this.userMembershipType,
    this.userFavStateMaxCount,
    this.userMembershipValidFrom,
    this.userMembershipValidTo,
  });

  UserMembershipInfo.fromJson(dynamic json) {
    userMembershipId = json['user_membership_id'];
    userUuid = json['user_uuid'];
    userMembershipType = json['user_membership_type'] != null
        ? UserMembershipType.fromJson(json['user_membership_type'])
        : null;
    userFavStateMaxCount = json['user_fav_state_max_count'];
    userMembershipValidFrom = json['user_membership_valid_from'];
    userMembershipValidTo = json['user_membership_valid_to'];
  }

  String? userMembershipId;
  String? userUuid;
  UserMembershipType? userMembershipType;
  int? userFavStateMaxCount;
  String? userMembershipValidFrom;
  String? userMembershipValidTo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_membership_id'] = userMembershipId;
    map['user_uuid'] = userUuid;
    if (userMembershipType != null) {
      map['user_membership_type'] = userMembershipType?.toJson();
    }
    map['user_fav_state_max_count'] = userFavStateMaxCount;
    map['user_membership_valid_from'] = userMembershipValidFrom;
    map['user_membership_valid_to'] = userMembershipValidTo;
    return map;
  }
}

class UserMembershipType {
  UserMembershipType({
    this.code,
    this.value,
  });

  UserMembershipType.fromJson(dynamic json) {
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

class UserFavouriteStateInfo {
  UserFavouriteStateInfo({
    this.favouriteId,
    this.userUuid,
    this.stateInfo,
  });

  UserFavouriteStateInfo.fromJson(dynamic json) {
    favouriteId = json['favourite_id'];
    userUuid = json['user_uuid'];
    if (json['state_info'] != null) {
      stateInfo = [];
      json['state_info'].forEach((v) {
        stateInfo?.add(StateInfo.fromJson(v));
      });
    }
  }

  String? favouriteId;
  String? userUuid;
  List<StateInfo>? stateInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['favourite_id'] = favouriteId;
    map['user_uuid'] = userUuid;
    if (stateInfo != null) {
      map['state_info'] = stateInfo?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class StateInfo {
  StateInfo({
    this.stateId,
    this.stateName,
    this.stateNameLanguage,
  });

  StateInfo.fromJson(dynamic json) {
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
