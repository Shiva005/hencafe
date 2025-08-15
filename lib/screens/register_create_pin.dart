import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_regex.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class RegisterCreatePin extends StatefulWidget {
  const RegisterCreatePin({super.key});

  @override
  State<RegisterCreatePin> createState() => _RegisterCreatePinState();
}

class _RegisterCreatePinState extends State<RegisterCreatePin> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> pinNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPinNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController pinController;
  late final TextEditingController confirmPinController;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void initializeControllers() {
    pinController = TextEditingController()..addListener(controllerListener);
    confirmPinController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    pinController.dispose();
    confirmPinController.dispose();
  }

  void controllerListener() {
    final email = pinController.text;
    final password = confirmPinController.text;

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
    final String pageType = args?['pageType'] ?? '';
    final String firstName = args?['firstName'] ?? '';
    final String lastName = args?['lastName'] ?? '';
    final String mobileNumber = args?['mobileNumber'] ?? '';
    final String email = args?['email'] ?? '';
    final String cityID = args?['cityID'] ?? '';
    final String address = args?['address'] ?? '';
    final String stateID = args?['stateID'] ?? '';
    final String referralCode = args?['referralCode'] ?? '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.createPinNumber)),
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
                SizedBox(height: 20),
                Image.asset(AppIconsData.createPin, height: 180),
                SizedBox(height: 40),
                ValueListenableBuilder(
                  valueListenable: pinNotifier,
                  builder: (_, passwordObscure, __) {
                    return AppTextFormField(
                      obscureText: passwordObscure,
                      controller: pinController,
                      labelText: AppStrings.pin,
                      maxLength: 4,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      prefixIcon: Icon(Icons.pin),
                      suffixIcon: IconButton(
                        onPressed: () => pinNotifier.value = !passwordObscure,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your pin';
                        }
                        if (value.length < 4) {
                          return 'Pin must be 4 digits';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: confirmPinNotifier,
                  builder: (_, passwordObscure, __) {
                    return AppTextFormField(
                      obscureText: passwordObscure,
                      controller: confirmPinController,
                      labelText: AppStrings.reEnterPin,
                      maxLength: 4,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      prefixIcon: Icon(Icons.pin),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            confirmPinNotifier.value = !passwordObscure,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your pin';
                        }
                        if (value != pinController.text) {
                          return 'Pins do not match';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                RoundedLoadingButton(
                  controller: _btnController,
                  height: 50.0,
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    if (_formKey.currentState?.validate() ?? false) {
                      var registrationCreateRes = await AuthServices()
                          .registrationCreate(
                              context,
                              firstName,
                              lastName,
                              mobileNumber,
                              email,
                              cityID,
                              pinController.text,
                              address,
                              stateID,
                              referralCode);
                      if (registrationCreateRes.errorCount == 0) {
                        prefs.setString(AppStrings.prefUserID,
                            registrationCreateRes.regUserInfo!.userId!);
                        prefs.setString(AppStrings.prefUserUUID,
                            registrationCreateRes.regUserInfo!.userUuid!);
                        prefs.setString(AppStrings.prefRole,
                            registrationCreateRes.regUserInfo!.userRoleType!);
                        prefs.setString(AppStrings.prefAuthID,
                            registrationCreateRes.regUserInfo!.authUuid!);
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.bottomSlide,
                          dialogType: DialogType.success,
                          dialogBackgroundColor: Colors.white,
                          titleTextStyle: AppTheme.appBarText,
                          title: registrationCreateRes
                              .apiResponse![0].responseDetails,
                          btnOkOnPress: () async {
                            NavigationHelper.pushReplacementNamedUntil(
                              AppRoutes.dashboardScreen,
                              arguments: {
                                'mobileNumber': mobileNumber,
                              },
                            );
                          },
                          btnOkText: 'OK',
                          btnOkColor: Colors.greenAccent.shade700,
                        ).show();
                      }
                    }
                    _btnController.reset();
                  },
                  color: AppColors.primaryColor,
                  child: Text(
                    AppStrings.finish,
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
