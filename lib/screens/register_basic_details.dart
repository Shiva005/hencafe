import 'package:flutter/material.dart';
import 'package:hencafe/values/app_regex.dart';
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
  late final TextEditingController addressController;
  late final TextEditingController stateController;

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
    stateController = TextEditingController()..addListener(controllerListener);
    addressController = TextEditingController()
      ..addListener(controllerListener);
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
    addressController.dispose();
    stateController.dispose();
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

  String _selectedState = 'Select State';
  final List<String> states = [
    'Delhi',
    'Hydrabad',
    'Telangana',
    'Hydrabad',
    'Telangana',
    'Hydrabad',
    'Telangana',
    'Hydrabad',
    'Telangana',
    'Hydrabad',
    'Telangana',
    'Hydrabad',
    'Telangana'
  ];

  // Function to show a bottom sheet
  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      // Allows the height to expand dynamically
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.8, // 90% of screen height
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Select State",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Add dynamic content here
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: states.length, // Example content
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              trailing: Radio<String>(
                                value: states[index],
                                groupValue: _selectedState,
                                onChanged: (value) {
                                  setState(() {
                                    stateController.text = value!;
                                    _selectedState = value;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              title: Text(states[index]),
                            ),
                            Divider(
                              color: Colors.grey.shade100,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTextFormField(
                      controller: firstNameController,
                      labelText: AppStrings.firstName,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      controller: lastNameController,
                      labelText: AppStrings.lastName,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      controller: mobileController,
                      labelText: AppStrings.mobile,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 15,
                      enabled: false,
                      prefixIcon: Icon(Icons.call),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      controller: emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      prefixIcon: Icon(Icons.alternate_email),
                      validator: (value) {
                        if (AppRegex.emailRegex.hasMatch(value!)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 70.0,
                      child: GestureDetector(
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
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2040));
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(
                                  () => dateController.text = formattedDate);
                            }
                          },
                        ),
                      ),
                    ),
                    AppTextFormField(
                      controller: addressController,
                      labelText: AppStrings.address,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      minLines: 2,
                      maxLines: 2,
                      prefixIcon: Icon(Icons.location_pin),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      child: SizedBox(
                        height: 70.0,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: stateController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.location_city),
                            iconColor: Colors.white,
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "State",
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.shade200),
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
                            if (value == null ||
                                value.isEmpty ||
                                value == 'Select State') {
                              return 'Please select your state';
                            }
                            return null;
                          },
                          onTap: _showLanguageBottomSheet,
                        ),
                      ),
                    ),
                    AppTextFormField(
                      controller: referralCodeController,
                      labelText: AppStrings.referralCode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                      prefixIcon: Icon(Icons.card_giftcard),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.4,
                          controller: _btnController,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              _btnController.reset();
                              NavigationHelper.pushNamed(
                                AppRoutes.registerCreatePin,
                                arguments: {
                                  'mobileNumber': mobileController.text,
                                },
                              );
                            } else {
                              _btnController.reset();
                            }
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
