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
  String? supplytypeId;
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