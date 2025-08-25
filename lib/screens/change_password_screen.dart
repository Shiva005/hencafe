import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../helpers/snackbar_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var prefs;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProfile();
    });
  }

  Future<void> loadProfile() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar(
        title: AppStrings.changePassword,
      ),
      body: Padding(
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Icon(Icons.lock_open_rounded,
                    size: 80, color: AppColors.primaryColor),
                const SizedBox(height: 16),
                Center(
                  child: const Text(
                    AppStrings.changePassword,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please enter your old and new password to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                // Old Password
                AppTextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: oldPasswordController,
                    labelText: "Old Password",
                    obscureText: _obscureOld,
                    enabled: true,
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
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      if (value.length != 4) {
                        return 'Passwords must be exact 4 character';
                      }
                      return null;
                    }),

                SizedBox(height: 10),
                // New Password
                AppTextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: newPasswordController,
                    labelText: "New Password",
                    obscureText: _obscureNew,
                    enabled: true,
                    maxLength: 4,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter new password';
                      }
                      if (value.length != 4) {
                        return 'Passwords must be exact 4 character';
                      }
                      return null;
                    }),
                SizedBox(height: 10),
                // Confirm Password
                AppTextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: confirmPasswordController,
                  labelText: "Confirm Password",
                  obscureText: _obscureConfirm,
                  enabled: true,
                  maxLength: 4,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    }
                    if (value.length != 4) {
                      return 'Passwords must be exact 4 character';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                RoundedLoadingButton(
                  height: 50.0,
                  controller: _btnController,
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      LoadingDialogHelper.showLoadingDialog(context);
                      var updatePasswordRes =
                          await AuthServices().updatePassword(
                        context,
                        oldPasswordController.text,
                        newPasswordController.text,
                      );
                      if (updatePasswordRes.apiResponse![0].responseStatus ==
                          true) {
                        LoadingDialogHelper.dismissLoadingDialog(context);
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.success,
                          dialogBackgroundColor: Colors.white,
                          titleTextStyle: AppTheme.appBarText,
                          dismissOnTouchOutside: false,
                          dismissOnBackKeyPress: false,
                          title: updatePasswordRes
                              .apiResponse![0].responseDetails!,
                          btnOkOnPress: () async {
                            var mb =
                                prefs.getString(AppStrings.prefMobileNumber);
                            var language =
                                prefs.getString(AppStrings.prefLanguage);
                            var countryCode =
                                prefs.getString(AppStrings.prefCountryCode);
                            var sessionID =
                                prefs.getString(AppStrings.prefAppSessionID);
                            prefs.clear();
                            prefs.setString(AppStrings.prefLanguage, language);
                            prefs.setString(AppStrings.prefMobileNumber, mb);
                            prefs.setString(
                                AppStrings.prefCountryCode, countryCode);
                            prefs.setString(
                                AppStrings.prefAppSessionID, sessionID);
                            NavigationHelper.pushReplacementNamedUntil(
                              AppRoutes.loginPin,
                              arguments: {
                                'mobileNumber': prefs
                                    .getString(AppStrings.prefMobileNumber),
                              },
                            );
                          },
                          btnOkText: 'OK',
                          btnOkColor: Colors.greenAccent.shade700,
                        ).show();
                      } else {
                        LoadingDialogHelper.dismissLoadingDialog(context);
                        SnackbarHelper.showSnackBar(
                            updatePasswordRes.apiResponse![0].responseDetails!);
                      }
                    }
                    _btnController.reset();
                  },
                  color: AppColors.primaryColor,
                  child: Text(
                    AppStrings.changePassword,
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
