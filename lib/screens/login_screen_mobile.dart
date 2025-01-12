import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
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

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController mobileController;
  late final TextEditingController passwordController;

  bool _rememberMe = false;
  String _selectedLanguage = 'English';
  String versionName = "Unknown";

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void initializeControllers() {
    mobileController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    mobileController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = mobileController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
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
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      versionName = packageInfo.version; // e.g., "1.0.0"
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void _showLanguageBottomSheet() {
    print("Bottom sheet triggered");
    showModalBottomSheet(
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
                "Select Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Spanish'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'Spanish';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('French'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'French';
                  });
                  Navigator.pop(context);
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
      body: Stack(
        children: [
          Positioned(
            right: 25.0,
            top: 50.0,
            child: GestureDetector(
              onTap: _showLanguageBottomSheet,
              // Call the method to show the bottom sheet
              child: Row(
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 5.0),
                  Text(_selectedLanguage),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          enabled: true,
                          prefixIcon: Icon(Icons.phone_android),
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
                                _btnController.reset();
                                NavigationHelper.pushNamed(
                                  AppRoutes.loginPin,
                                  arguments: {
                                    'mobileNumber': mobileController.text,
                                  },
                                );
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
          Positioned(
            bottom: 30.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    SnackbarHelper.openWhatsApp('message');
                  },
                  child: Ink(
                    child: Text('Privacy Policy', style: AppTheme.linkText),
                  ),
                ),
                SizedBox(height: 5.0),
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
          ),
        ],
      ),
    );
  }
}
