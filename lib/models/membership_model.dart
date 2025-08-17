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
  String? userFavStateMaxCount;
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