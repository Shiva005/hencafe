class MedicineModel {
  MedicineModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.apiResponse,
  });

  MedicineModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(MedicineModel.fromJson(v));
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
    this.subject,
    this.subjectLanguage,
    this.details,
    this.detailsLanguage,
    this.usage,
    this.usageLanguage,
    this.createdOn,
    this.attachmentInfo,
  });

  ApiResponse.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    subject = json['subject'];
    subjectLanguage = json['subject_language'];
    details = json['details'];
    detailsLanguage = json['details_language'];
    usage = json['usage'];
    usageLanguage = json['usage_language'];
    createdOn = json['created_on'];
    if (json['attachment_info'] != null) {
      attachmentInfo = [];
      json['attachment_info'].forEach((v) {
        attachmentInfo?.add(AttachmentInfo.fromJson(v));
      });
    }
  }

  String? id;
  String? uuid;
  String? subject;
  String? subjectLanguage;
  String? details;
  String? detailsLanguage;
  String? usage;
  String? usageLanguage;
  String? createdOn;
  List<AttachmentInfo>? attachmentInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['subject'] = subject;
    map['subject_language'] = subjectLanguage;
    map['details'] = details;
    map['details_language'] = detailsLanguage;
    map['usage'] = usage;
    map['usage_language'] = usageLanguage;
    map['created_on'] = createdOn;
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
