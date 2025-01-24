import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hencafe/components/app_text_form_field.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

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
    final String dob = args?['dob'] ?? '';
    final String address = args?['address'] ?? '';
    final String stateID = args?['stateID'] ?? '';
    final String referralCode = args?['referralCode'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                AppIconsData.otpHeader,
                height: 160,
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
              Text(
                "Enter the OTP sent to $mobileNumber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't receive the OTP?",
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
                      _isResendEnabled ? "RESEND OTP" : "RESEND OTP in $_start s",
                      style: TextStyle(
                        fontSize: 14,
                        color: _isResendEnabled ? Colors.orange : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RoundedLoadingButton(
                width: MediaQuery.of(context).size.width,
                controller: _btnVerifyController,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    var validateOtpRes = await AuthServices()
                        .otpValidate(context, mobileNumber, otpController.text);
                    if (validateOtpRes.errorCount == 0) {
                      NavigationHelper.pushNamed(
                        AppRoutes.registerCreatePin,
                        arguments: {
                          'pageType': AppRoutes.registerBasicDetails,
                          'firstName': firstName,
                          'lastName': lastName,
                          'mobileNumber': mobileNumber,
                          'email': email,
                          'dob': dob,
                          'address': address,
                          'stateID': stateID,
                          'referralCode': referralCode,
                        },
                      );
                    }
                  }
                  _btnVerifyController.reset();
                },
                color: Colors.orange.shade300,
                child: Text(
                  AppStrings.verify,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
