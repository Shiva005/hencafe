import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/address_model.dart';
import 'package:hencafe/models/bird_breed_model.dart';
import 'package:hencafe/models/chick_price_model.dart';
import 'package:hencafe/models/chicken_price_model.dart';
import 'package:hencafe/models/city_list_model.dart';
import 'package:hencafe/models/company_list_model.dart';
import 'package:hencafe/models/company_providers_model.dart';
import 'package:hencafe/models/egg_price_model.dart';
import 'package:hencafe/models/error_model.dart';
import 'package:hencafe/models/forget_pin_model.dart';
import 'package:hencafe/models/medicine_mode.dart';
import 'package:hencafe/models/otp_generate_model.dart';
import 'package:hencafe/models/profile_model.dart';
import 'package:hencafe/models/referral_model.dart';
import 'package:hencafe/models/registration_check_model.dart';
import 'package:hencafe/models/registration_create_model.dart';
import 'package:hencafe/models/state_model.dart';
import 'package:hencafe/models/success_model.dart';
import 'package:hencafe/models/supplies_model.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:hencafe/models/validate_otp_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/contact_history_model.dart';
import '../models/lifting_price_model.dart';
import '../models/login_pin_check_model.dart';
import '../utils/my_logger.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import 'service_name.dart';

class AuthServices {
  Future<RegistrationCheckModel> userExists(
      BuildContext context, String mobileNumber) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.REGISTRATION_CHECK}mobile_number=$mobileNumber"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Registration Check: ${jsonDecode(response.body)}');
    return RegistrationCheckModel.fromJson(jsonDecode(response.body));
  }

  Future<OtpGenerateModel> otpGenerate(
      BuildContext context, String mobileNumber) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile': mobileNumber,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.OTP_GENERATE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG OTP Generate: $payload');
    logger.d('TAG OTP Generate: ${jsonDecode(response.body)}');
    return OtpGenerateModel.fromJson(jsonDecode(response.body));
  }

  Future<ValidateOtpModel> otpValidate(
      BuildContext context, String mobileNumber, String otp) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile': mobileNumber,
      'otp': otp,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.OTP_VALIDATE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG OTP Validate: $payload');
    logger.d('TAG OTP Validate: ${jsonDecode(response.body)}');
    return ValidateOtpModel.fromJson(jsonDecode(response.body));
  }

  Future<LoginPinCheckModel> loginPinCheck(BuildContext context,
      String mobileNumber, String pin, String loginType, String isInsertAuth) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile_number': mobileNumber,
      'password_otp': pin,
      'login_type': loginType,
      'insert_auth_uuid': isInsertAuth,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.LOGIN_PIN_CHECK),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Login: $payload');
    logger.d('TAG Login: ${jsonDecode(response.body)}');
    return LoginPinCheckModel.fromJson(jsonDecode(response.body));
  }

  Future<StateModel> getStates(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.GET_STATE_LIST}/${prefs.getString(AppStrings.prefCountryCode)}/states'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG State List: ${jsonDecode(response.body)}');
    return StateModel.fromJson(jsonDecode(response.body));
  }

  Future<CityListModel> getCityList(
      BuildContext context, String stateID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_STATE_LIST}/${prefs.getString(AppStrings.prefCountryCode)}/states/$stateID/cities"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG City List: ${jsonDecode(response.body)}');
    return CityListModel.fromJson(jsonDecode(response.body));
  }

  Future<RegistrationCreateModel> registrationCreate(
      BuildContext context,
      String firstName,
      String lastName,
      String mobileNumber,
      String email,
      String cityID,
      String password,
      String address,
      String stateID,
      String referralCode) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobileNumber,
      'email': email,
      'password': password,
      'refferal_code': referralCode,
      'address': address,
      'country_id': prefs.getString(AppStrings.prefCountryCode),
      'state_id': stateID,
      'city_id': cityID,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.REGISTRATION_CREATE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Register: $payload');
    logger.d('TAG Register: ${jsonDecode(response.body)}');
    return RegistrationCreateModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateBasicDetails(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String dob,
      String workType) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'dob': dob,
      'work_type': workType,
      'user_id': prefs.getString(AppStrings.prefUserID),
      'user_uuid': prefs.getString(AppStrings.prefUserUUID),
    };

    final response = await http.put(
      Uri.parse(
          '${ServiceNames.UPDATE_BASIC_DETAILS}${prefs.getString(AppStrings.prefUserID)}/basic-info'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Details: $payload');
    logger.d('TAG Update Details: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteProfile(
      BuildContext context,
      String userID,
      String mobileNumber,
      String reason,
      String comment,
      String password,
      String otp) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile_number': mobileNumber,
      'user_id': userID,
      'user_uuid': prefs.getString(AppStrings.prefUserUUID)!,
      'reason': reason,
      'comment': comment,
      'password': password,
      'otp': otp,
    };

    final response = await http.put(
      Uri.parse('${ServiceNames.DELETE_PROFILE}/$userID/delete-user-account'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Delete Profile: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updatePassword(
    BuildContext context,
    String oldPassword,
    String newPassword,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'old_password': oldPassword,
      'new_password': newPassword,
      'user_id': prefs.getString(AppStrings.prefUserID),
      'user_uuid': prefs.getString(AppStrings.prefUserUUID),
    };

    final response = await http.put(
      Uri.parse(
          '${ServiceNames.CHANGE_PASSWORD}${prefs.getString(AppStrings.prefUserID)}/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Details: $payload');
    logger.d('TAG Update Details: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel?> getProfile(
      BuildContext context, String thirdPartUserID) async {
    var prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_PROFILE}/${prefs.getString(AppStrings.prefUserID)}/profile?profile_id=$thirdPartUserID"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage) ?? 'en',
        'user-uuid': prefs.getString(AppStrings.prefUserUUID) ?? '',
        'auth-uuid': prefs.getString(AppStrings.prefAuthID) ?? '',
        'session-id': prefs.getString(AppStrings.prefSessionID) ?? '',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.d('Response Body: ${response.body}');
      return ProfileModel.fromJson(jsonDecode(response.body));
    } else {
      StatusCodeHandler.handleStatusCode(
          context, response.statusCode, response.body);
      return null;
    }
  }

  Future<SuppliesModel> getSupplies(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(ServiceNames.GET_SUPPLIES),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Supplies: ${jsonDecode(response.body)}');
    return SuppliesModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateFavState(
      BuildContext context, String stateID) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'user_uuid': prefs.getString(AppStrings.prefUserUUID)!,
      'state_id_list': stateID,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_FAV_STATE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update State: $payload');
    logger.d('TAG Update State: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateSupplies(
      BuildContext context, String referenceFrom, String supplyIDs) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'reference_from': referenceFrom,
      'reference_uuid': prefs.getString(AppStrings.prefUserUUID)!,
      'supply_id_list': supplyIDs,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.UPDATE_SUPPLY),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Supplies: $payload');
    logger.d('TAG Update Supplies: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> createAddress(
      BuildContext context,
      String addressUUID,
      String referenceFrom,
      String addressType,
      String address,
      String stateID,
      String cityID,
      String zipCode) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'address_type': addressType,
      'address': address,
      'zipcode': zipCode,
      'state_id': stateID,
      'city_id': cityID,
      'address_uuid': addressUUID,
      'reference_from': referenceFrom,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'reference_uuid': prefs.getString(AppStrings.prefUserUUID)!,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.CREATE_ADDRESS),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Address: $payload');
    logger.d('TAG Create Address: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateAddress(
      BuildContext context,
      String addressID,
      String addressUUID,
      String referenceFrom,
      String addressType,
      String address,
      String stateID,
      String cityID,
      String zipCode) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'address_id': addressID,
      'address_type': addressType,
      'address': address,
      'zipcode': zipCode,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'state_id': stateID,
      'city_id': cityID,
      'address_uuid': addressUUID,
      'reference_from': referenceFrom,
      'reference_uuid': prefs.getString(AppStrings.prefUserUUID)!,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_ADDRESS),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Address: $payload');
    logger.d('TAG Update Address: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> sellEgg(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String isHatchingEgg,
      String stateID,
      String cityID,
      String uuid) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'cost': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'is_hatching_egg': isHatchingEgg,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'eggsale_uuid': uuid,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.SELL_EGG),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateSellEgg(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String isHatchingEgg,
      String stateID,
      String cityID,
      String uuid,
      String eggSaleID) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'cost': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'is_hatching_egg': isHatchingEgg,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'eggsale_uuid': uuid,
      'eggsale_id': eggSaleID,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_SELL_EGG),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> sellChick(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String stateID,
      String cityID,
      String uuid,
      String age,
      String weight) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'cost': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'age_in_days': age,
      'weight_in_grams': weight,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'chicksale_uuid': uuid,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.SELL_CHICK),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Sell Chick: $payload');
    logger.d('TAG Create Sell Chick: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> createLiftingSell(
      BuildContext context,
      String breedID,
      String totalBirds,
      String cost,
      String comment,
      String address,
      String effectFromDate,
      String effectTillDate,
      String stateID,
      String cityID,
      String uuid,
      String age,
      String weight) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'total_birds': totalBirds,
      'cost_per_kg': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'age_in_days': age,
      'weight_in_kg': weight,
      'comment': comment,
      'birdbreed_id': breedID,
      'address': address,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'uuid': uuid,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.CREATE_LIFTING_SALE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Lifting Sale: $payload');
    logger.d('TAG Create Lifting Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> createContactSupport(
      BuildContext context,
      String uuid,
      String type,
      String subject,
      String details,
      String email,
      String mobile) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'uuid': uuid,
      'type': type,
      'subject': subject,
      'details': details,
      'email': email,
      'mobile': mobile,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'assigned_user_id': prefs.getString(AppStrings.prefUserID)!,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.CREATE_CONTACT_SUPPORT),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Support: $payload');
    logger.d('TAG Create Support: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateLiftingSell(
      BuildContext context,
      String breedID,
      String totalBirds,
      String cost,
      String comment,
      String address,
      String effectFromDate,
      String effectTillDate,
      String stateID,
      String cityID,
      String saleID,
      String uuid,
      String age,
      String weight) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'total_birds': totalBirds,
      'cost_per_kg': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'age_in_days': age,
      'weight_in_kg': weight,
      'comment': comment,
      'birdbreed_id': breedID,
      'address': address,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'uuid': uuid,
      'liftingsale_id': saleID,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_LIFTING_SALE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Lifting Sale: $payload');
    logger.d('TAG Update Lifting Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateSellChick(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String stateID,
      String cityID,
      String age,
      String weight,
      String uuid,
      String chickID) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'cost': cost,
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'age_in_days': age,
      'weight_in_grams': weight,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'chicksale_uuid': uuid,
      'chicksale_id': chickID,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_SELL_CHICK),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update Sell Chick: $payload');
    logger.d('TAG Update Sell Chick: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> sellChicken(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String stateID,
      String cityID,
      String uuid) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'farm_live_bird_cost': cost,
      "retail_live_bird_cost": "0",
      "with_skin_cost": "0",
      "skin_less_cost": "0",
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'chickensale_uuid': uuid,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.SELL_CHICKEN),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Sell Chicken: $payload');
    logger.d('TAG Create Sell Chicken: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> updateSellChicken(
      BuildContext context,
      String companyID,
      String breedID,
      String qty,
      String cost,
      String comment,
      String effectFromDate,
      String effectTillDate,
      String saleType,
      String stateID,
      String cityID,
      String uuid,
      String chickenID) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'qty': qty,
      'farm_live_bird_cost': cost,
      "retail_live_bird_cost": "0",
      "with_skin_cost": "0",
      "skin_less_cost": "0",
      'effect_from': effectFromDate,
      'effect_to': effectTillDate,
      'is_special_sale': saleType,
      'comment': comment,
      'birdbreed_id': breedID,
      'company_id': companyID,
      'state_id': stateID,
      'city_id': cityID,
      'country_id': prefs.getString(AppStrings.prefCountryCode)!,
      'user_id': prefs.getString(AppStrings.prefUserID)!,
      'chickensale_uuid': uuid,
      'chickensale_id': chickenID,
    };

    final response = await http.put(
      Uri.parse(ServiceNames.UPDATE_SELL_CHICKEN),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<UserFavouriteStateModel> getFavouriteStateList(
      BuildContext context, String thirdPartUserID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_FAV_STATE_LIST}/${prefs.getString(AppStrings.prefUserID)}/favourite-states?profile_id=$thirdPartUserID"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Fav State: ${jsonDecode(response.body)}');
    return UserFavouriteStateModel.fromJson(jsonDecode(response.body));
  }

  Future<ContactHistoryModel> getContactHistory(BuildContext context,
      String communicationType, String communicationID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_CONTACT_HISTORY}$communicationType&&assigned_user_id=${prefs.getString(AppStrings.prefUserID)!}&&communication_id=$communicationID"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.w('TAG Get Contact History: ${jsonDecode(response.body)}');
    logger.w(
        'TAG Get Contact History: ${ServiceNames.GET_CONTACT_HISTORY}$communicationType&&assigned_user_id=${prefs.getString(AppStrings.prefUserID)!}&&communication_id=$communicationID');
    return ContactHistoryModel.fromJson(jsonDecode(response.body));
  }

  Future<BirdBreedModel> getBirdList(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(ServiceNames.GET_BIRD_BREED_LIST),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Bird Breed: ${jsonDecode(response.body)}');
    return BirdBreedModel.fromJson(jsonDecode(response.body));
  }

  Future<CompanyListModel> getCompanyList(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(ServiceNames.GET_COMPANY_LIST),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Company List: ${jsonDecode(response.body)}');
    return CompanyListModel.fromJson(jsonDecode(response.body));
  }

  Future<CompanyProvidersModel> getCompanyProvidersList(
      BuildContext context, companyUUID, promotionStatus) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.GET_COMPANY_PROVIDERS_LIST}$companyUUID&&promotion_status=$promotionStatus'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Company providers List: ${jsonDecode(response.body)}');
    return CompanyProvidersModel.fromJson(jsonDecode(response.body));
  }

  Future<ReferralModel> getReferralsList(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_REFERRALS_LIST}${prefs.getString(AppStrings.prefUserID)}/referral-bonus?target_user_mobile=${prefs.getString(AppStrings.prefMobileNumber)}"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Company providers List: ${jsonDecode(response.body)}');
    return ReferralModel.fromJson(jsonDecode(response.body));
  }

  Future<MedicineModel> getMedicine(
      BuildContext context, String medicineID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${ServiceNames.GET_MEDICINE}$medicineID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Company providers List: ${jsonDecode(response.body)}');
    return MedicineModel.fromJson(jsonDecode(response.body));
  }

  Future<EggPriceModel> getEggPriceList(BuildContext context, String eggID,
      String fromDate, String toDate, String saleType) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.EGG_PRICE_LIST}$fromDate&sale_to_date=$toDate&eggsale_id=$eggID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Egg Price List: ${jsonDecode(response.body)}');
    return EggPriceModel.fromJson(jsonDecode(response.body));
  }

  Future<AddressModel> getAddressList(BuildContext context,
      String referenceFrom, String referenceUUID, String addressID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.GET_ADDRESS_LIST}$referenceFrom&reference_uuid=$referenceUUID&address_id=$addressID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Egg Price List: ${jsonDecode(response.body)}');
    return AddressModel.fromJson(jsonDecode(response.body));
  }

  Future<ChickPriceModel> getChickPriceList(BuildContext context,
      String chickID, String fromDate, String toDate, String saleType) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.CHICK_PRICE_LIST}$fromDate&sale_to_date=$toDate&chicksale_id=$chickID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Chick Price List: ${jsonDecode(response.body)}');
    return ChickPriceModel.fromJson(jsonDecode(response.body));
  }

  Future<ChickenPriceModel> getChickenPriceList(BuildContext context,
      String chickenID, String fromDate, String toDate, String saleType) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.CHICKEN_PRICE_LIST}$fromDate&sale_to_date=$toDate&chickensale_id=$chickenID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Chicken Price List: ${jsonDecode(response.body)}');
    return ChickenPriceModel.fromJson(jsonDecode(response.body));
  }

  Future<LiftingPriceModel> getLiftingPriceList(BuildContext context,
      String liftingID, String fromDate, String toDate, String saleType) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          '${ServiceNames.LIFTING_PRICE_LIST}$fromDate&sale_to_date=$toDate&liftingsale_id=$liftingID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Lifting Price List: ${jsonDecode(response.body)}');
    return LiftingPriceModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteAddress(
      BuildContext context, String addressUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_ADDRESS}$addressUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Delete Address: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteContactRecord(
      BuildContext context, String communicationUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_CONTACT_RECORD}$communicationUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Lifting Price List: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteEggSaleRecord(
      BuildContext context, String eggSaleUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_EGG_SALE}$eggSaleUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Delete Egg Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteChickSaleRecord(
      BuildContext context, String chickSaleUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_CHICK_SALE}$chickSaleUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Delete Chick Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteChickenSaleRecord(
      BuildContext context, String chickSaleUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_CHICKEN_SALE}$chickSaleUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Delete Chicken Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> deleteLiftingSaleRecord(
      BuildContext context, String chickSaleUUID) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.parse('${ServiceNames.DELETE_LIFTING_SALE}$chickSaleUUID'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'user-id': prefs.getString(AppStrings.prefUserID)!,
        'user-uuid': prefs.getString(AppStrings.prefUserUUID)!,
        'auth-uuid': prefs.getString(AppStrings.prefAuthID)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Delete Lifting Sale: ${jsonDecode(response.body)}');
    return SuccessModel.fromJson(jsonDecode(response.body));
  }

  Future<ForgetPinModel> forgetPin(
      BuildContext context, String mobileNumber, String otp) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile': mobileNumber,
    };

    final response = await http.post(
      Uri.parse(ServiceNames.FORGET_PIN),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Forget Pin: $payload');
    logger.d('TAG Forget Pin: ${jsonDecode(response.body)}');
    return ForgetPinModel.fromJson(jsonDecode(response.body));
  }

  Future<SuccessModel> attachmentDelete(
      BuildContext context, String attachmentID, String fileUrl) async {
    var prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
      'DELETE',
      Uri.parse(ServiceNames.ATTACHMENT_DELETE),
    );

    // Add form fields
    request.fields['attachment_id'] = attachmentID;
    request.fields['file_path'] = fileUrl;

    // Add headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'language': prefs.getString(AppStrings.prefLanguage) ?? 'en',
      'user-id': prefs.getString(AppStrings.prefUserID) ?? '',
      'user-uuid': prefs.getString(AppStrings.prefUserUUID) ?? '',
      'auth-uuid': prefs.getString(AppStrings.prefAuthID) ?? '',
      'session-id': prefs.getString(AppStrings.prefSessionID)!,
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logger.d('Request Data: ${request.fields}');
      logger.d('Response: ${response.statusCode}');
      logger.d('Response Body: ${response.body}');
      return SuccessModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      logger.e('Exception during attachment delete: $e');
      rethrow;
    }
  }
}

class StatusCodeHandler {
  static ErrorModel handleStatusCode(
      BuildContext context, int statusCode, String body) {
    try {
      var errorModel = ErrorModel.fromJson(jsonDecode(body));
      switch (statusCode) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 500:
          _showErrorDialog(context, errorModel, statusCode);
          return errorModel;
        default:
          logger.e('Unexpected Error: $statusCode $body');
          throw Exception('Unexpected Error: $statusCode $body');
      }
    } catch (e) {
      // Log parsing issues or any unexpected behavior
      logger.e('Error processing status code: $e');
      throw Exception('Error processing status code: $e');
    }
  }

  static void _showErrorDialog(
      BuildContext context, ErrorModel errorModel, int statusCode) {
    var message = '';
    for (int i = 0; i < errorModel.errorCount!; i++) {
      message = '$message\n${errorModel.errorMessage![i].errorDetails!}';
    }

    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.error,
      dialogBackgroundColor: Colors.white,
      desc: message,
      descTextStyle: const TextStyle(color: Colors.black),
      btnOkOnPress: () async {
        if (statusCode == 401) {
          var prefs = await SharedPreferences.getInstance();
          var mb = prefs.getString(AppStrings.prefMobileNumber);
          var language = prefs.getString(AppStrings.prefLanguage);
          var countryCode = prefs.getString(AppStrings.prefCountryCode);
          var sessionID = prefs.getString(AppStrings.prefSessionID);
          prefs.clear();
          prefs.setString(AppStrings.prefLanguage, language!);
          prefs.setString(AppStrings.prefMobileNumber, mb!);
          prefs.setString(AppStrings.prefCountryCode, countryCode!);
          prefs.setString(AppStrings.prefSessionID, sessionID!);
          NavigationHelper.pushReplacementNamedUntil(AppRoutes.loginMobile);
        }
      },
      btnOkColor: Colors.red,
    ).show();
  }
}
