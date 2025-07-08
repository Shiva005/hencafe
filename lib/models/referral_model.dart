class ReferralModel {
  ReferralModel({
    this.apiCode,
    this.errorCount,
    this.errorMessage,
    this.pointsSummaryByStatus,
    this.apiResponse,
  });

  ReferralModel.fromJson(dynamic json) {
    apiCode = json['api_code'];
    errorCount = json['error_count'];
    if (json['error_message'] != null) {
      errorMessage = [];
      json['error_message'].forEach((v) {
        errorMessage?.add(ReferralModel.fromJson(v));
      });
    }
    pointsSummaryByStatus = json['points_summary_by_status'] != null
        ? PointsSummaryByStatus.fromJson(json['points_summary_by_status'])
        : null;
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
  PointsSummaryByStatus? pointsSummaryByStatus;
  List<ApiResponse>? apiResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_code'] = apiCode;
    map['error_count'] = errorCount;
    if (errorMessage != null) {
      map['error_message'] = errorMessage?.map((v) => v.toJson()).toList();
    }
    if (pointsSummaryByStatus != null) {
      map['points_summary_by_status'] = pointsSummaryByStatus?.toJson();
    }
    if (apiResponse != null) {
      map['api_response'] = apiResponse?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ApiResponse {
  ApiResponse({
    this.userrefId,
    this.fromUserMobile,
    this.toUserMobile,
    this.toUserFirstName,
    this.toUserLastName,
    this.earnedPoints,
    this.pointsFor,
    this.pointsCharged,
    this.pointsChargedDate,
    this.status,
    this.comments,
    this.createdon,
    this.dipalyText,
  });

  ApiResponse.fromJson(dynamic json) {
    userrefId = json['userref_id'];
    fromUserMobile = json['from_user_mobile'];
    toUserMobile = json['to_user_mobile'];
    toUserFirstName = json['to_user_first_name'];
    toUserLastName = json['to_user_last_name'];
    earnedPoints = json['earned_points'];
    pointsFor = json['points_for'] != null
        ? PointsFor.fromJson(json['points_for'])
        : null;
    pointsCharged = json['points_charged'];
    pointsChargedDate = json['points_charged_date'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    comments = json['comments'];
    createdon = json['createdon'];
    dipalyText = json['dipaly_text'];
  }

  int? userrefId;
  String? fromUserMobile;
  String? toUserMobile;
  String? toUserFirstName;
  String? toUserLastName;
  int? earnedPoints;
  PointsFor? pointsFor;
  int? pointsCharged;
  String? pointsChargedDate;
  Status? status;
  String? comments;
  String? createdon;
  String? dipalyText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userref_id'] = userrefId;
    map['from_user_mobile'] = fromUserMobile;
    map['to_user_mobile'] = toUserMobile;
    map['to_user_first_name'] = toUserFirstName;
    map['to_user_last_name'] = toUserLastName;
    map['earned_points'] = earnedPoints;
    if (pointsFor != null) {
      map['points_for'] = pointsFor?.toJson();
    }
    map['points_charged'] = pointsCharged;
    map['points_charged_date'] = pointsChargedDate;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    map['comments'] = comments;
    map['createdon'] = createdon;
    map['dipaly_text'] = dipalyText;
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

class PointsFor {
  PointsFor({
    this.code,
    this.value,
  });

  PointsFor.fromJson(dynamic json) {
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

class PointsSummaryByStatus {
  PointsSummaryByStatus({
    this.available,
    this.pending,
    this.used,
    this.expired,
    this.total,
  });

  PointsSummaryByStatus.fromJson(dynamic json) {
    available = json['Available'];
    pending = json['Pending'];
    used = json['Used'];
    expired = json['Expired'];
    total = json['Total'];
  }

  int? available;
  int? pending;
  int? used;
  int? expired;
  int? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Available'] = available;
    map['Pending'] = pending;
    map['Used'] = used;
    map['Expired'] = expired;
    map['Total'] = total;
    return map;
  }
}
