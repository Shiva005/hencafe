import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../helpers/snackbar_helper.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

class ChangeMobileScreen extends StatefulWidget {
  const ChangeMobileScreen({super.key});

  @override
  State<ChangeMobileScreen> createState() => _ChangeMobileScreenState();
}

class _ChangeMobileScreenState extends State<ChangeMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPinController = TextEditingController();
  final TextEditingController currentMobileController = TextEditingController();
  final TextEditingController newMobileController = TextEditingController();
  final TextEditingController confirmNewMobileController =
      TextEditingController();
  final RoundedLoadingButtonController _btnVerifyPinController =
      RoundedLoadingButtonController();
  bool _obscureOld = true;
  bool _isPinVerified = false;

  @override
  void initState() {
    super.initState();
    setMobileNumber();
  }

  Future<void> setMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    currentMobileController.text =
        prefs.getString(AppStrings.prefMobileNumber) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: MyAppBar(
        title: "Change Mobile Number",
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                Image.asset(AppIconsData.changeMobileIcon, height: 160),
                const SizedBox(height: 40),
                AppTextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: currentMobileController,
                  labelText: "Current Mobile Number",
                  enabled: false,
                  maxLength: 10,
                  prefixIcon: const Icon(Icons.perm_phone_msg_outlined),
                ),
                // PIN Field
                AppTextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: currentPinController,
                  labelText: "Current Pin",
                  obscureText: _obscureOld,
                  enabled: !_isPinVerified,
                  maxLength: 4,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOld
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                  ),
                  validator: (value) {
                    if (!_isPinVerified) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Pin';
                      }
                      if (value.length != 4) {
                        return 'Pin must be exact 4 characters';
                      }
                    }
                    return null;
                  },
                ),

                // Only show these after PIN is verified
                if (_isPinVerified) ...[
                  AppTextFormField(
                    controller: newMobileController,
                    labelText: "New Mobile Number",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    enabled: true,
                    prefixIcon: Icon(Icons.call),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be exactly 10 characters';
                      }
                      return null;
                    },
                  ),
                  AppTextFormField(
                    controller: confirmNewMobileController,
                    labelText: "Confirm New Mobile Number",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    enabled: true,
                    prefixIcon: Icon(Icons.call),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be exactly 10 characters';
                      }
                      if (newMobileController.text != value) {
                        return 'New mobile and confirm mobile do not match';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                // Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedLoadingButton(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50.0,
                      controller: _btnVerifyPinController,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (!_isPinVerified) {
                            // PIN verification step
                            var loginCheckRes =
                                await AuthServices().loginPinCheck(
                              context,
                              currentMobileController.text,
                              currentPinController.text,
                              "password",
                              "false",
                            );
                            if (loginCheckRes
                                    .apiResponse![0].responseStatus ==
                                true) {
                              setState(() {
                                _isPinVerified = true;
                              });
                            } else {
                              SnackbarHelper.showSnackBar(
                                loginCheckRes
                                    .apiResponse![0].responseDetails!,
                              );
                            }
                          } else {
                            var registrationCheckRes = await AuthServices()
                                .userExists(
                                    context, newMobileController.text);

                            if (registrationCheckRes
                                    .apiResponse![0].registrationStatus ==
                                true) {
                              SnackbarHelper.showSnackBar(registrationCheckRes
                                  .apiResponse![0].responseDetails);
                            } else {
                              var generateOtpRes = await AuthServices()
                                  .otpGenerate(
                                      context, newMobileController.text);
                              if (generateOtpRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                NavigationHelper.pushNamed(
                                  AppRoutes.loginOtp,
                                  arguments: {
                                    'pageType': AppRoutes.changeMobileScreen,
                                    'mobileNumber': newMobileController.text,
                                  },
                                );
                              }
                            }
                          }
                        }
                        _btnVerifyPinController.reset();
                      },
                      color: AppColors.primaryColor,
                      child: Text(
                        _isPinVerified ? "Submit" : AppStrings.continueNext,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
