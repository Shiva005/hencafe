import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/bird_breed_model.dart';
import 'package:hencafe/models/chick_price_model.dart';
import 'package:hencafe/models/chicken_price_model.dart';
import 'package:hencafe/models/city_list_model.dart';
import 'package:hencafe/models/company_list_model.dart';
import 'package:hencafe/models/egg_price_model.dart';
import 'package:hencafe/models/error_model.dart';
import 'package:hencafe/models/forget_pin_model.dart';
import 'package:hencafe/models/otp_generate_model.dart';
import 'package:hencafe/models/profile_model.dart';
import 'package:hencafe/models/registration_check_model.dart';
import 'package:hencafe/models/registration_create_model.dart';
import 'package:hencafe/models/state_model.dart';
import 'package:hencafe/models/success_model.dart';
import 'package:hencafe/models/supplies_model.dart';
import 'package:hencafe/models/user_address_model.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:hencafe/models/validate_otp_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lifting_price_model.dart';
import '../models/login_pin_check_model.dart';
import '../utils/my_logger.dart';
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

    final response = await http.post(
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
      String mobileNumber, String pin, String loginType) async {
    var prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> payload = {
      'mobile_number': mobileNumber,
      'password_otp': pin,
      'login_type': loginType,
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

  Future<ProfileModel> getProfile(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_PROFILE}/${prefs.getString(AppStrings.prefUserID)}/profile/"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Profile: ${jsonDecode(response.body)}');
    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<UserAddressModel> getAddress(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_ADDRESS}${prefs.getString(AppStrings.prefUserUUID)}"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Profile: ${jsonDecode(response.body)}');
    return UserAddressModel.fromJson(jsonDecode(response.body));
  }

  Future<SuppliesModel> getSupplies(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(ServiceNames.GET_SUPPLIES),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
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

    final response = await http.post(
      Uri.parse(ServiceNames.UPDATE_FAV_STATE),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
      body: jsonEncode(payload),
    );

    logger.d('TAG Update State: $payload');
    logger.d('TAG Update State: ${jsonDecode(response.body)}');
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

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
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

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
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

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
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

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
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

    logger.d('TAG Create Sell Egg: $payload');
    logger.d('TAG Create Sell Egg: ${jsonDecode(response.body)}');
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
      BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          "${ServiceNames.GET_FAV_STATE_LIST}/${prefs.getString(AppStrings.prefUserID)}/favourite-states/"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Fav State: ${jsonDecode(response.body)}');
    return UserFavouriteStateModel.fromJson(jsonDecode(response.body));
  }

  Future<BirdBreedModel> getBirdList(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(ServiceNames.GET_BIRD_BREED_LIST),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'language': prefs.getString(AppStrings.prefLanguage)!,
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
        'session-id': prefs.getString(AppStrings.prefSessionID)!,
      },
    );

    logger.d('TAG Get Company List: ${jsonDecode(response.body)}');
    return CompanyListModel.fromJson(jsonDecode(response.body));
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
          SnackbarHelper.showSnackBar(body.toString());
          _showErrorDialog(context, errorModel);
          return errorModel;
        default:
          // Handle unexpected status codes gracefully
          logger.e('Unexpected Error: $statusCode $body');
          throw Exception('Unexpected Error: $statusCode $body');
      }
    } catch (e) {
      // Log parsing issues or any unexpected behavior
      logger.e('Error processing status code: $e');
      throw Exception('Error processing status code: $e');
    }
  }

  static void _showErrorDialog(BuildContext context, ErrorModel errorModel) {
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
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }
}
