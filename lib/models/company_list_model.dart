class CompanyListModel {
  CompanyListModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

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
    this.companyContactUserName,
    this.companyContactUserMobile,
    this.companyContactUserEmail,
    this.attachmentInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    companyId = json['company_id'];
    companyUuid = json['company_uuid'];
    companyName = json['company_name'];
    companyNameLanguage = json['company_name_language'];
    companyDetails = json['company_details'];
    companyContactUserName = json['company_contact_user_name'];
    companyContactUserMobile = json['company_contact_user_mobile'];
    companyContactUserEmail = json['company_contact_user_email'];
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
  }

  String? companyId;
  String? companyUuid;
  String? companyName;
  String? companyNameLanguage;
  String? companyDetails;
  String? companyContactUserName;
  String? companyContactUserMobile;
  String? companyContactUserEmail;
  List<AttachmentInfo>? attachmentInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = companyId;
    map['company_uuid'] = companyUuid;
    map['company_name'] = companyName;
    map['company_name_language'] = companyNameLanguage;
    map['company_details'] = companyDetails;
    map['company_contact_user_name'] = companyContactUserName;
    map['company_contact_user_mobile'] = companyContactUserMobile;
    map['company_contact_user_email'] = companyContactUserEmail;
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
