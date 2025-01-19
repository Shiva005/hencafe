import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Create Pin Number',
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
                  children: [
                    ValueListenableBuilder(
                      valueListenable: pinNotifier,
                      builder: (_, passwordObscure, __) {
                        return AppTextFormField(
                          obscureText: passwordObscure,
                          controller: pinController,
                          labelText: AppStrings.pin,
                          maxLength: 4,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          enabled: true,
                          prefixIcon: Icon(Icons.pin),
                          suffixIcon: IconButton(
                            onPressed: () =>
                            pinNotifier.value = !passwordObscure,
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
                          keyboardType: TextInputType.visiblePassword,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          controller: _btnController,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              NavigationHelper.pushNamed(
                                AppRoutes.stateSelection,
                              );
                            }
                            _btnController.reset();
                          },
                          color: Colors.orange.shade400,
                          child: Text(
                            AppStrings.finish,
                            style: TextStyle(color: Colors.white),
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
    );
  }
}

bool validateFields() {
  return true;
}
