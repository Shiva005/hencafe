import 'package:flutter/material.dart';
import 'package:hencafe/models/city_list_model.dart' as city;
import 'package:hencafe/models/state_model.dart' as state;
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/values/app_regex.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

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
  late final TextEditingController cityController;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<state.ApiResponse> _states = [];
  List<city.ApiResponse> _city = [];
  String? _selectedStateID;
  String? _selectedCityID;

  void initializeControllers() {
    firstNameController = TextEditingController()
      ..addListener(controllerListener);
    lastNameController = TextEditingController()
      ..addListener(controllerListener);
    mobileController = TextEditingController()..addListener(controllerListener);
    dateController = TextEditingController()..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    stateController = TextEditingController()..addListener(controllerListener);
    cityController = TextEditingController()..addListener(controllerListener);
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
    cityController.dispose();
  }

  void controllerListener() {
    final email = mobileController.text;
    if (email.isEmpty) return;
  }

  @override
  void initState() {
    initializeControllers();
    _fetchStates();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<state.StateModel> _fetchStates() async {
    LoadingDialogHelper.showLoadingDialog(context);
    final stateRes = await AuthServices().getStates(context);
    if (stateRes.errorCount == 0 && stateRes.apiResponse != null) {
      setState(() {
        _states = stateRes.apiResponse!;
      });
    }
    LoadingDialogHelper.dismissLoadingDialog(context);
    return stateRes;
  }

  Future<city.CityListModel> _fetchCity() async {
    LoadingDialogHelper.showLoadingDialog(context);
    final cityRes =
        await AuthServices().getCityList(context, _selectedStateID!);
    if (cityRes.errorCount == 0 && cityRes.apiResponse != null) {
      setState(() {
        _city = cityRes.apiResponse!;
      });
    }
    LoadingDialogHelper.dismissLoadingDialog(context);
    return cityRes;
  }

  // Function to show a bottom sheet
  void _showStateBottomSheet() async {
    // Fetch states before showing the bottom sheet
    await _fetchStates();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Select State",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _states.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _states.length,
                              itemBuilder: (context, index) {
                                final state = _states[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      trailing: Radio<String>(
                                        value: state.stateNameLanguage ?? '',
                                        groupValue: _selectedStateID,
                                        onChanged: (value) {
                                          setState(() {
                                            stateController.text = value!;
                                            _selectedStateID = state.stateId;
                                            cityController.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      title: Text(
                                        '${state.stateNameLanguage}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 15),
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                        height: 2,
                                      ),
                                    ),
                                  ],
                                );
                              },
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

  // Function to show a bottom sheet
  void _showCityBottomSheet() async {
    await _fetchCity();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Select City",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _city.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _city.length,
                              itemBuilder: (context, index) {
                                final city = _city[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      trailing: Radio<String>(
                                        value: city.cityNameLanguage ?? '',
                                        groupValue: _selectedCityID,
                                        onChanged: (value) {
                                          setState(() {
                                            cityController.text = value!;
                                            _selectedCityID = city.cityId;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      title: Text(
                                        '${city.cityNameLanguage}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 15),
                                      child: Divider(
                                        color: Colors.grey.shade200,
                                        height: 2,
                                      ),
                                    ),
                                  ],
                                );
                              },
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String mobileNumber = args?['mobileNumber'] ?? '';
    mobileController.text = mobileNumber;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.createAccount)),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10,
        ),
        child: Card(
          color: Colors.white,
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
                      Visibility(
                        visible: false,
                        child: SizedBox(
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
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
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
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  setState(() =>
                                      dateController.text = formattedDate);
                                }
                              },
                            ),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
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
                            onTap: _showStateBottomSheet,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: SizedBox(
                          height: 70.0,
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: cityController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.location_city),
                              iconColor: Colors.white,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "City",
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
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
                                  value == 'Select City') {
                                return 'Please select your city';
                              }
                              return null;
                            },
                            onTap: _showCityBottomSheet,
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
                            height: 40.0,
                            controller: _btnController,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                var generateOtpRes = await AuthServices()
                                    .otpGenerate(
                                        context, mobileController.text);
                                if (generateOtpRes.errorCount == 0) {
                                  NavigationHelper.pushNamed(
                                    AppRoutes.loginOtp,
                                    arguments: {
                                      'pageType':
                                          AppRoutes.registerBasicDetails,
                                      'firstName': firstNameController.text,
                                      'lastName': lastNameController.text,
                                      'mobileNumber': mobileController.text,
                                      'email': emailController.text,
                                      'dob': dateController.text,
                                      'address': addressController.text,
                                      'stateID': _selectedStateID,
                                      'referralCode':
                                          referralCodeController.text,
                                    },
                                  );
                                }
                              }
                              _btnController.reset();
                            },
                            color: AppColors.primaryColor,
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
      ),
    );
  }
}
