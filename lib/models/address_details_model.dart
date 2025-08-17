import 'address_model.dart';
import 'attachment_model.dart';

class AddressDetails {
  AddressDetails({
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
    this.userBasicInfo,
  });

  AddressDetails.fromJson(dynamic json) {
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