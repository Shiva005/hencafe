class ContactHistoryModel {
  ContactHistoryModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  ContactHistoryModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ContactHistoryModel.fromJson(v));
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
    this.id,
    this.uuid,
    this.type,
    this.subject,
    this.subjectLanguage,
    this.details,
    this.detailsLanguage,
    this.email,
    this.mobile,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.createdUserBasicInfo,
    this.assignedUserBasicInfo,
    this.attachmentInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    type = json['type'];
    subject = json['subject'];
    subjectLanguage = json['subject_language'];
    details = json['details'];
    detailsLanguage = json['details_language'];
    email = json['email'];
    mobile = json['mobile'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    if (json['created_user_basic_info'] != null) {
      createdUserBasicInfo = [];
      json['created_user_basic_info'].forEach((v) {
        createdUserBasicInfo?.add(CreatedUserBasicInfo.fromJson(v));
      });
    }
    if (json['assigned_user_basic_info'] != null) {
      assignedUserBasicInfo = [];
      json['assigned_user_basic_info'].forEach((v) {
        assignedUserBasicInfo?.add(AssignedUserBasicInfo.fromJson(v));
      });
    }
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
  }

  String? id;
  String? uuid;
  String? type;
  String? subject;
  String? subjectLanguage;
  String? details;
  String? detailsLanguage;
  String? email;
  String? mobile;
  Status? status;
  String? createdOn;
  String? updatedOn;
  List<CreatedUserBasicInfo>? createdUserBasicInfo;
  List<AssignedUserBasicInfo>? assignedUserBasicInfo;
  List<AttachmentInfo>? attachmentInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['type'] = type;
    map['subject'] = subject;
    map['subject_language'] = subjectLanguage;
    map['details'] = details;
    map['details_language'] = detailsLanguage;
    map['email'] = email;
    map['mobile'] = mobile;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    map['created_on'] = createdOn;
    map['updated_on'] = updatedOn;
    if (createdUserBasicInfo != null) {
      map['created_user_basic_info'] =
          createdUserBasicInfo?.map((v) => v.toJson()).toList();
    }
    if (assignedUserBasicInfo != null) {
      map['assigned_user_basic_info'] =
          assignedUserBasicInfo?.map((v) => v.toJson()).toList();
    }
    if (attachmentInfo != null) {
      map['attachment_info'] = attachmentInfo?.map((v) => v.toJson()).toList();
    }
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

class AssignedUserBasicInfo {
  AssignedUserBasicInfo({
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

  AssignedUserBasicInfo.fromJson(dynamic json) {
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

class CreatedUserBasicInfo {
  CreatedUserBasicInfo({
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

  CreatedUserBasicInfo.fromJson(dynamic json) {
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

class Status {
  Status({
    this.code,
    this.value,
  });

  Status.fromJson(dynamic json) {
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
