import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../values/app_colors.dart';
import '../values/app_regex.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LoginPagePin extends StatefulWidget {
  const LoginPagePin({super.key});

  @override
  State<LoginPagePin> createState() => _LoginPagePinState();
}

class _LoginPagePinState extends State<LoginPagePin> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController mobileController;
  late final TextEditingController passwordController;

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
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String mobileNumber = args?['mobileNumber'] ?? '';
    mobileController.text = mobileNumber;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Login with Pin',
          style: AppTheme.appBarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Image.asset(
                        AppIconsData.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 30),
                    AppTextFormField(
                      controller: mobileController,
                      labelText: AppStrings.mobile,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      enabled: false,
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                    SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: passwordNotifier,
                      builder: (_, passwordObscure, __) {
                        return AppTextFormField(
                          obscureText: passwordObscure,
                          controller: passwordController,
                          labelText: AppStrings.pin,
                          maxLength: 4,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          enabled: true,
                          prefixIcon: Icon(Icons.pin),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                passwordNotifier.value = !passwordObscure,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(48),
                            ),
                            icon: Icon(
                              passwordObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Forget Pin?',
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              width: 75.0,
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          controller: _btnController,
                          onPressed: () async {
                            _btnController.reset();
                            NavigationHelper.pushNamed(
                              AppRoutes.loginOtp,
                              arguments: {
                                'mobileNumber': mobileController.text,
                              },
                            );
                          },
                          color: Colors.orange.shade300,
                          child: Row(
                            children: [
                              Text(
                                AppStrings.login,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 30),
                      child: Divider(),
                    ),
                    Text('Try another way'),
                    SizedBox(height: 10),
                    RoundedLoadingButton(
                      controller: _btnController,
                      onPressed: () async {
                        NavigationHelper.pushNamed(
                          AppRoutes.registerBasicDetails,
                          arguments: {
                            'mobileNumber': mobileController.text,
                          },
                        );
                        _btnController.reset();
                        if (validateFields()) {}
                      },
                      color: Colors.red.shade400,
                      child: Text(
                        AppStrings.loginWithOtp,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool validateFields() {
  return true;
}
