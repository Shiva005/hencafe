import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/components/app_text_form_field.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LoginPageOtp extends StatefulWidget {
  const LoginPageOtp({Key? key}) : super(key: key);

  @override
  State<LoginPageOtp> createState() => _LoginPageOtpState();
}

class _LoginPageOtpState extends State<LoginPageOtp> {
  late Timer _timer;
  int _start = 30; // Timer for Resend Button
  bool _isResendEnabled = false;
  late SharedPreferences prefs; // Corrected type
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController otpController;
  final RoundedLoadingButtonController _btnVerifyController =
      RoundedLoadingButtonController();

  bool _isControllersInitialized = false; // To track initialization

  Future<void> initializeControllers() async {
    prefs = await SharedPreferences.getInstance();
    otpController = TextEditingController()..addListener(controllerListener);
    setState(() {
      _isControllersInitialized = true; // Mark as initialized
    });
  }

  void disposeControllers() {
    otpController.dispose();
  }

  void controllerListener() {
    final otp = otpController.text;
    if (otp.isEmpty) return;
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    _startTimer();
  }

  @override
  void dispose() {
    disposeControllers();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _start = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          _isResendEnabled = true;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  Future<bool> _resendOTP(String mobileNumber) async {
    _startTimer();
    var generateOtpRes =
        await AuthServices().otpGenerate(context, mobileNumber);
    if (generateOtpRes.errorCount == 0) {
      SnackbarHelper.showSnackBar(
          generateOtpRes.apiResponse![0].responseDetails!);
      return true;
    }
    return false;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP cannot be empty";
    } else if (value.length < 4) {
      return "OTP must be 4 digits";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllersInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String pageType = args?['pageType'] ?? '';
    final String firstName = args?['firstName'] ?? '';
    final String lastName = args?['lastName'] ?? '';
    final String mobileNumber = args?['mobileNumber'] ?? '';
    final String email = args?['email'] ?? '';
    final String cityID = args?['city_id'] ?? '';
    final String address = args?['address'] ?? '';
    final String stateID = args?['stateID'] ?? '';
    final String referralCode = args?['referralCode'] ?? '';

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.verifyOtp)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ListView(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  AppIconsData.otpHeader,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  "OTP Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter the OTP sent to ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      mobileNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                AppTextFormField(
                  controller: otpController,
                  labelText: AppStrings.otp,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  enabled: true,
                  maxLength: 4,
                  prefixIcon: Icon(Icons.pin),
                  validator: _validateOtp, // Added validator for OTP field
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't receive the OTP ?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: _isResendEnabled
                          ? () async {
                              await _resendOTP(mobileNumber);
                            }
                          : null, // Set to null when button is disabled
                      child: Text(
                        _isResendEnabled ? " RESEND OTP" : "$_start s",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedLoadingButton(
                  width: double.infinity,
                  height: 50.0,
                  controller: _btnVerifyController,
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (pageType == AppRoutes.registerBasicDetails) {
                        var validateOtpRes = await AuthServices().otpValidate(
                            context, mobileNumber, otpController.text);
                        if (validateOtpRes.apiResponse![0].responseStatus ==
                            true) {
                          NavigationHelper.pushNamed(
                            AppRoutes.registerCreatePin,
                            arguments: {
                              'pageType': AppRoutes.registerBasicDetails,
                              'firstName': firstName,
                              'lastName': lastName,
                              'mobileNumber': mobileNumber,
                              'email': email,
                              'cityID': cityID,
                              'address': address,
                              'stateID': stateID,
                              'referralCode': referralCode,
                            },
                          );
                        } else {
                          SnackbarHelper.showSnackBar(
                              validateOtpRes.apiResponse![0].responseDetails!);
                        }
                      } else if (pageType == AppRoutes.loginPin) {
                        var validateOtpRes = await AuthServices().otpValidate(
                            context, mobileNumber, otpController.text);
                        if (validateOtpRes.errorCount == 0) {
                          var forgetPinRes = await AuthServices().forgetPin(
                              context, mobileNumber, otpController.text);
                          if (forgetPinRes.errorCount == 0) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.bottomSlide,
                              dialogType: DialogType.success,
                              dialogBackgroundColor: Colors.white,
                              title:
                                  forgetPinRes.apiResponse![0].responseDetails,
                              titleTextStyle: AppTheme.appBarText,
                              descTextStyle: AppTheme.appBarText,
                              btnOkOnPress: () {
                                NavigationHelper.pushReplacementNamedUntil(
                                  AppRoutes.loginPin,
                                  arguments: {'mobileNumber': mobileNumber},
                                );
                              },
                              btnOkText: 'OK',
                              btnOkColor: Colors.greenAccent.shade700,
                            ).show();
                          }
                        }
                      } else if (pageType == 'LoginWithOtp') {
                        var loginPinRes = await AuthServices().loginPinCheck(
                            context,
                            mobileNumber,
                            otpController.text,
                            "otp",
                            "true");
                        if (loginPinRes.apiResponse?[0].responseStatus ==
                            true) {
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              AppStrings.prefUserID,
                              loginPinRes
                                  .apiResponse![0].userLoginInfo!.userId!);
                          prefs.setString(
                              AppStrings.prefUserUUID,
                              loginPinRes
                                  .apiResponse![0].userLoginInfo!.userUuid!);
                          prefs.setString(
                              AppStrings.prefRole,
                              loginPinRes.apiResponse![0].userLoginInfo!
                                  .userRoleType!);
                          prefs.setString(
                              AppStrings.prefAuthID,
                              loginPinRes
                                  .apiResponse![0].userLoginInfo!.authUuid!);
                          NavigationHelper.pushReplacementNamedUntil(
                            AppRoutes.dashboardScreen,
                            arguments: {'mobileNumber': mobileNumber},
                          );
                        } else {
                          SnackbarHelper.showSnackBar(
                              loginPinRes.apiResponse![0].responseDetails!);
                        }
                      } else if (pageType == AppRoutes.changeMobileScreen) {
                        var loginPinRes = await AuthServices()
                            .updateMobileNumber(
                                context, mobileNumber, otpController.text);
                        if (loginPinRes.apiResponse?[0].responseStatus ==
                            true) {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.bottomSlide,
                            dialogType: DialogType.success,
                            dialogBackgroundColor: Colors.white,
                            titleTextStyle: AppTheme.appBarText,
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                            title: loginPinRes.apiResponse![0].responseDetails!,
                            btnOkOnPress: () async {
                              var prefs = await SharedPreferences.getInstance();
                              var mb =
                                  prefs.getString(AppStrings.prefMobileNumber);
                              var language =
                                  prefs.getString(AppStrings.prefLanguage);
                              var countryCode =
                                  prefs.getString(AppStrings.prefCountryCode);
                              var sessionID =
                                  prefs.getString(AppStrings.prefSessionID);
                              prefs.clear();
                              prefs.setString(
                                  AppStrings.prefLanguage, language!);
                              prefs.setString(AppStrings.prefMobileNumber, mb!);
                              prefs.setString(
                                  AppStrings.prefCountryCode, countryCode!);
                              prefs.setString(
                                  AppStrings.prefSessionID, sessionID!);
                              NavigationHelper.pushReplacementNamedUntil(
                                  AppRoutes.loginMobile);
                              SnackbarHelper.showSnackBar(
                                  loginPinRes.apiResponse![0].responseDetails!);
                            },
                            btnOkText: 'OK',
                            btnOkColor: Colors.greenAccent.shade700,
                          ).show();
                        }
                      }
                    }
                    _btnVerifyController.reset();
                  },
                  color: AppColors.primaryColor,
                  child: Text(
                    AppStrings.verify,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
