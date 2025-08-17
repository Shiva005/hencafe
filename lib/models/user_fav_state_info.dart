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