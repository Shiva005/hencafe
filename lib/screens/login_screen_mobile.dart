import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/services/service_name.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/values/app_constants.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_regex.dart';
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
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  final List<String> languages = [
    'English',
    'Telgu',
    'Hindi',
    'Telgu',
    'Hindi',
    'Telgu',
    'Hindi',
    'Telgu',
    'Hindi',
    'Telgu',
    'Hindi'
  ];

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Change Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...languages
                  .map(
                    (lang) => Column(
                      children: [
                        ListTile(
                          leading: Radio<String>(
                            value: lang,
                            groupValue: _selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value!;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          title: Text(lang),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
                  .toList(),
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
            padding: const EdgeInsets.only(top: 45.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _showLanguageBottomSheet,
                  child: Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(width: 5.0),
                      Text(_selectedLanguage),
                    ],
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
                        left: 20, right: 20, top: 100, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            AppIconsData.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20),
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
                                activeColor: Colors.orange,
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
                              controller: _btnController,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() == true) {
                                  if (_rememberMe) {
                                    setState(() {
                                      prfs.setString(
                                          AppStrings.prefMobileNumber,
                                          mobileController.text);
                                      prfs.setString(
                                          AppStrings.prefLanguage, 'english');
                                      prfs.setString(
                                          AppStrings.prefCountryCode, '101');
                                    });
                                  } else {
                                    prfs.remove(AppStrings.prefMobileNumber);
                                  }

                                  var registrationCheckRes =
                                      await AuthServices().registrationCheck(
                                          context, mobileController.text);

                                  if (registrationCheckRes
                                          .apiResponse![0].registrationStatus ==
                                      true) {
                                    NavigationHelper.pushNamed(
                                      AppRoutes.loginPin,
                                      arguments: {
                                        'mobileNumber': mobileController.text
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
                                          .responseDetailsLanguage,
                                      titleTextStyle: AppTheme.appBarText,
                                      descTextStyle: AppTheme.appBarText,
                                      btnOkOnPress: () {
                                        NavigationHelper.pushNamed(
                                          AppRoutes.registerBasicDetails,
                                          arguments: {
                                            'mobileNumber':
                                                mobileController.text
                                          },
                                        );
                                      },
                                      btnOkText: 'Start Registration',
                                      btnOkColor: Colors.yellow.shade700,
                                    ).show();
                                  }
                                }
                                _btnController.reset();
                              },
                              color: Colors.orange.shade300,
                              child: Row(
                                children: [
                                  Text(
                                    AppStrings.continueNext,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 5.0),
                                  Icon(
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
              TextButton(
                child: Text('Privacy Policy', style: AppTheme.linkText),
                onPressed: () {
                  SnackbarHelper.openUrl(
                      "https://pub.dev/packages/awesome_dialog");
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('© 20224 SV Poultry Farms | v',
                      style: AppTheme.informationString),
                  Text(versionName, style: AppTheme.informationString),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
