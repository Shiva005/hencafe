import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class RegisterBasicDetails extends StatefulWidget {
  const RegisterBasicDetails({super.key});

  @override
  State<RegisterBasicDetails> createState() => _RegisterBasicDetailsState();
}

class _RegisterBasicDetailsState extends State<RegisterBasicDetails> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController mobileController;
  late final TextEditingController dateController;
  late final TextEditingController emailController;
  late final TextEditingController referralCodeController;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);
    lastNameController = TextEditingController()
      ..addListener(controllerListener);
    mobileController = TextEditingController()..addListener(controllerListener);
    dateController = TextEditingController()..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    referralCodeController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    dateController.dispose();
    referralCodeController.dispose();
  }

  void controllerListener() {
    final email = mobileController.text;
    if (email.isEmpty) return;
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
          'Create account',
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
                    AppTextFormField(
                      controller: firstNameController,
                      labelText: AppStrings.firstName,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 15),
                    AppTextFormField(
                      controller: lastNameController,
                      labelText: AppStrings.lastName,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(height: 15),
                    AppTextFormField(
                      controller: mobileController,
                      labelText: AppStrings.mobile,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 15,
                      enabled: false,
                      prefixIcon: Icon(Icons.call),
                    ),
                    SizedBox(height: 15),
                    AppTextFormField(
                      controller: emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: dateController,

                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.calendar_month),
                          iconColor: Colors.white,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Date Of Birth",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orangeAccent.shade200),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orangeAccent.shade200),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        readOnly: true,
                        validator: (value) {
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2040));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() => dateController.text = formattedDate);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    AppTextFormField(
                      controller: referralCodeController,
                      labelText: AppStrings.referralCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                      prefixIcon: Icon(Icons.card_giftcard),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          controller: _btnController,
                          onPressed: () async {
                            _btnController.reset();
                            NavigationHelper.pushNamed(
                              AppRoutes.registerCreatePin,
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
    );
  }
}
