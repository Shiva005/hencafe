import 'package:flutter/material.dart';
import 'package:hencafe/models/city_list_model.dart' as city;
import 'package:hencafe/models/profile_model.dart' as profile;
import 'package:hencafe/models/state_model.dart' as state;
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/values/app_regex.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../helpers/snackbar_helper.dart';
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
  late final TextEditingController workTypeController;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<state.ApiResponse> _states = [];
  List<city.ApiResponse> _city = [];
  String? _selectedStateID;
  String? _selectedCityID;
  String? _selectedWorkType;
  bool _isInitialized = false;
  late final profile.ApiResponse profileModel;

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
    workTypeController = TextEditingController()
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
    workTypeController.dispose();
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

    final TextEditingController searchController = TextEditingController();
    List<state.ApiResponse> filteredStates = List.from(_states);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.9,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search State',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (query) {
                            setModalState(() {
                              filteredStates = (_states ?? [])
                                  .where((item) =>
                                      (item.stateNameLanguage ?? '')
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        (_states.isEmpty)
                            ? const Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: filteredStates.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: filteredStates.length,
                                        separatorBuilder: (_, __) => Divider(
                                          color: Colors.grey.shade200,
                                          height: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          final state = filteredStates[index];
                                          return ListTile(
                                            title: Text(
                                              state.stateNameLanguage ?? '',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                stateController.text =
                                                    state.stateNameLanguage ??
                                                        '';
                                                _selectedStateID =
                                                    state.stateId;
                                                cityController.clear();
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text("No results found.")),
                              ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Function to show a bottom sheet
  void _showCityBottomSheet() async {
    await _fetchCity();

    final TextEditingController searchController = TextEditingController();
    List<city.ApiResponse> filteredCities = List.from(_city);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.9,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search City',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (query) {
                            setModalState(() {
                              filteredCities = (_city ?? [])
                                  .where((item) => (item.cityNameLanguage ?? '')
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        (_city.isEmpty)
                            ? const Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: filteredCities.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: filteredCities.length,
                                        separatorBuilder: (_, __) => Divider(
                                          color: Colors.grey.shade200,
                                          height: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          final city = filteredCities[index];
                                          return ListTile(
                                            title: Text(
                                              city.cityNameLanguage ?? '',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                cityController.text =
                                                    city.cityNameLanguage ?? '';
                                                _selectedCityID = city.cityId;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text("No results found.")),
                              ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  final Map<String, String> workTypes = {
    'FAR': 'Farmer',
    'SUP': 'Supplier',
    'TR': 'Trader',
    'DOC': 'Doctor',
    'OTH': 'Others',
  };

  void _showWorkTypeBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                child: Text(
                  'Address Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: workTypes.entries.map((entry) {
                  final String key = entry.key;
                  final String value = entry.value;

                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      workTypeController.text = key;
                      _selectedWorkType = key;
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String mobileNumber = args['mobileNumber'] ?? '';
    final String pageType = args['pageType'] ?? '';
    mobileController.text = mobileNumber;

    if (!_isInitialized && pageType == AppRoutes.myProfileScreen) {
      profileModel = args['profileModel'];
      firstNameController.text = profileModel.userFirstName!;
      lastNameController.text = profileModel.userLastName!;
      addressController.text = profileModel.addressDetails![0].addressAddress!;
      emailController.text = profileModel.userEmail!;
      dateController.text = profileModel.userDob!;
      workTypeController.text = profileModel.userWorkType!.value!;
      _selectedWorkType = profileModel.userWorkType!.code!;

      stateController.text =
          profileModel.addressDetails![0].locationInfo![0].stateNameLanguage!;
      cityController.text =
          profileModel.addressDetails![0].locationInfo![0].cityNameLanguage!;

      _selectedStateID =
          profileModel.addressDetails![0].locationInfo![0].stateId!;
      _selectedCityID =
          profileModel.addressDetails![0].locationInfo![0].cityId!;
      _isInitialized = true;
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(
              title: pageType == AppRoutes.myProfileScreen
                  ? 'Update Basic Details'
                  : AppStrings.createAccount)),
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          } else if (!AppRegex.emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      if (pageType == AppRoutes.myProfileScreen)
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
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  setState(() =>
                                      dateController.text = formattedDate);
                                }
                              },
                            ),
                          ),
                        ),
                      if (pageType != AppRoutes.myProfileScreen)
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
                      if (pageType != AppRoutes.myProfileScreen)
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
                                labelText: "State*",
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
                      if (pageType != AppRoutes.myProfileScreen)
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
                                labelText: "City*",
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
                      if (pageType != AppRoutes.myProfileScreen)
                        AppTextFormField(
                          controller: referralCodeController,
                          labelText: AppStrings.referralCode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          enabled: true,
                          maxLength: 10,
                          prefixIcon: Icon(Icons.card_giftcard),
                        ),
                      if (pageType == AppRoutes.myProfileScreen)
                        GestureDetector(
                          child: SizedBox(
                            height: 70.0,
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: workTypeController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.my_location),
                                iconColor: Colors.white,
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Work Type",
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
                                    value == 'Select Work Type') {
                                  return 'Please select work type';
                                }
                                return null;
                              },
                              onTap: _showWorkTypeBottomSheet,
                            ),
                          ),
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
                                if (pageType != AppRoutes.myProfileScreen) {
                                  var generateOtpRes = await AuthServices()
                                      .otpGenerate(
                                          context, mobileController.text);
                                  if (generateOtpRes
                                          .apiResponse![0].responseStatus ==
                                      true) {
                                    NavigationHelper.pushNamed(
                                      AppRoutes.loginOtp,
                                      arguments: {
                                        'pageType':
                                            AppRoutes.registerBasicDetails,
                                        'firstName': firstNameController.text,
                                        'lastName': lastNameController.text,
                                        'mobileNumber': mobileController.text,
                                        'email': emailController.text,
                                        'city_id': _selectedCityID,
                                        'address': addressController.text,
                                        'stateID': _selectedStateID,
                                        'referralCode':
                                            referralCodeController.text,
                                      },
                                    );
                                  } else {
                                    SnackbarHelper.showSnackBar(generateOtpRes
                                        .apiResponse![0].responseDetails!);
                                  }
                                } else {
                                  var updateDetailsRes = await AuthServices()
                                      .updateBasicDetails(
                                      context,
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      dateController.text,
                                      _selectedWorkType!);
                                  if (updateDetailsRes
                                      .apiResponse![0].responseStatus ==
                                      true) {
                                    NavigationHelper.pop(context);
                                  }
                                  SnackbarHelper.showSnackBar(updateDetailsRes
                                      .apiResponse![0].responseDetails!);
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
