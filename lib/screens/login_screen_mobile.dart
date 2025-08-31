import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/values/app_constants.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({super.key});

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController mobileController;

  bool _rememberMe = false;
  String _selectedLanguage = 'English';
  String versionName = "Unknown";
  var prfs;
  bool? isChecked = true;
  final List<String> languages = ['English', 'తెలుగు', 'हिन्दी'];

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void initializeControllers() {
    mobileController = TextEditingController()..addListener(controllerListener);
  }

  void disposeControllers() {
    mobileController.dispose();
  }

  void controllerListener() {
    final phone = mobileController.text;
    if (phone.isEmpty) return;

    if (AppConstants.phoneRegex.hasMatch(phone)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    fetchAppInfo();
    super.initState();
  }

  Future<void> fetchAppInfo() async {
    prfs = await SharedPreferences.getInstance();
    final savedLang = prfs.getString(AppStrings.prefLanguage) ?? "en";
    if (prfs.containsKey(AppStrings.prefMobileNumber)) {
      setState(() {
        _rememberMe = true;
        mobileController.text = prfs.getString(AppStrings.prefMobileNumber);
      });
    } else {
      setState(() {
        _rememberMe = false;
        mobileController.text = '';
      });
    }

    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
      if (savedLang == "hi") {
        _selectedLanguage = "हिन्दी";
      } else if (savedLang == "te") {
        _selectedLanguage = "తెలుగు";
      } else {
        _selectedLanguage = "English";
      }
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                itemCount: languages.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 2, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return ListTile(
                    leading: Radio<String>(
                      value: lang,
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                          if (value == 'हिन्दी') {
                            prfs.setString(AppStrings.prefLanguage, "hi");
                          } else if (value == 'తెలుగు') {
                            prfs.setString(AppStrings.prefLanguage, "te");
                          } else {
                            prfs.setString(AppStrings.prefLanguage, "en");
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(lang),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _showLanguageBottomSheet,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ), // Inner padding
                    child: Row(
                      children: [
                        Icon(Icons.language, color: AppColors.primaryColor),
                        SizedBox(width: 5.0),
                        Text(
                          _selectedLanguage,
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 30,
                      bottom: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.asset(
                            AppIconsData.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 40),
                        AppTextFormField(
                          controller: mobileController,
                          labelText: AppStrings.mobile,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 10,
                          enabled: true,
                          prefixIcon: Icon(Icons.phone_android),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (!AppConstants.phoneRegex.hasMatch(value)) {
                              return 'Invalid mobile number';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              alignment: Alignment.centerLeft,
                              scale: 0.7, // Adjust the scale to reduce the size
                              child: Switch(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value;
                                  });
                                },
                                activeColor: AppColors.primaryColor,
                                // Color when the switch is "on"
                                inactiveThumbColor: Colors.black,
                                // Thumb color when "off"
                                inactiveTrackColor:
                                    Colors.white, // Track color when "off"
                              ),
                            ),
                            Text(
                              "Remember me",
                              style: AppTheme.informationString,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RoundedLoadingButton(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 40.0,
                              controller: _btnController,
                              onPressed: isChecked!
                                  ? () async {
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        if (_rememberMe) {
                                          setState(() {
                                            prfs.setString(
                                              AppStrings.prefMobileNumber,
                                              mobileController.text,
                                            );
                                            prfs.setString(
                                              AppStrings.prefCountryCode,
                                              '101',
                                            );
                                          });
                                        } else {
                                          prfs.remove(
                                            AppStrings.prefMobileNumber,
                                          );
                                        }

                                        var registrationCheckRes =
                                            await AuthServices().userExists(
                                              context,
                                              mobileController.text,
                                            );

                                        if (registrationCheckRes
                                                .apiResponse![0]
                                                .registrationStatus ==
                                            true) {
                                          NavigationHelper.pushNamed(
                                            AppRoutes.loginPin,
                                            arguments: {
                                              'mobileNumber':
                                                  mobileController.text,
                                            },
                                          );
                                        } else {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.bottomSlide,
                                            dialogType: DialogType.warning,
                                            dialogBackgroundColor: Colors.white,
                                            title: registrationCheckRes
                                                .apiResponse![0]
                                                .responseDetails,
                                            titleTextStyle: AppTheme.appBarText,
                                            descTextStyle: AppTheme.appBarText,
                                            btnOkOnPress: () {
                                              NavigationHelper.pushNamed(
                                                AppRoutes.registerBasicDetails,
                                                arguments: {
                                                  'mobileNumber':
                                                      mobileController.text,
                                                  'pageType': AppRoutes
                                                      .registerBasicDetails,
                                                },
                                              );
                                            },
                                            btnOkText: 'Start Registration',
                                            btnOkColor: Colors.yellow.shade700,
                                          ).show();
                                        }
                                      }
                                      _btnController.reset();
                                    }
                                  : null,
                              // disable button if unchecked
                              color: isChecked!
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              // update color
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.continueNext,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                  ),
                  Text("I accept the", style: AppTheme.informationString),
                  TextButton(
                    child: Text(
                      AppStrings.privacyPolicy,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    onPressed: () {
                      Utils.openLink(AppStrings.privacyPolicyLink);
                    },
                  ),
                  Text("&", style: AppTheme.informationString),
                  TextButton(
                    child: Text(
                      AppStrings.termsOfUse,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    onPressed: () {
                      Utils.openLink(AppStrings.privacyPolicyLink);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '© 2024 SV Poultry Farms | v',
                    style: AppTheme.informationString,
                  ),
                  Text(versionName, style: AppTheme.informationString),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ],
      ),
    );
  }
}
