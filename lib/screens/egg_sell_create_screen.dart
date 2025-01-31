import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/city_list_model.dart';
import 'package:hencafe/models/company_list_model.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../models/bird_breed_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class EggSellCreateScreen extends StatefulWidget {
  const EggSellCreateScreen({super.key});

  @override
  State<EggSellCreateScreen> createState() => _EggSellCreateScreenState();
}

class _EggSellCreateScreenState extends State<EggSellCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController birdTypeController;
  late final TextEditingController eggPriceController;
  late final TextEditingController dateController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController companyController;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Map<String, String> birdBreedList = {};
  Map<String, String> companyList = {};
  Map<String, String> _states = {};
  Map<String, String> cityList = {};
  String? _selectedStateID;
  bool _hatchingEggs = false;
  bool _specialSale = false;

  void initializeControllers() {
    eggPriceController = TextEditingController()
      ..addListener(controllerListener);
    dateController = TextEditingController()..addListener(controllerListener);
    birdTypeController = TextEditingController()
      ..addListener(controllerListener);
    stateController = TextEditingController()..addListener(controllerListener);
    cityController = TextEditingController()..addListener(controllerListener);
    companyController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    eggPriceController.dispose();
    dateController.dispose();
    birdTypeController.dispose();
    stateController.dispose();
    cityController.dispose();
    companyController.dispose();
  }

  void controllerListener() {
    final eggPrice = eggPriceController.text;
    if (eggPrice.isEmpty) return;
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

  Future<UserFavouriteStateModel> _fetchStates() async {
    final favStateRes = await AuthServices().getFavouriteStateList(context);
    if (favStateRes.errorCount == 0 && favStateRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < favStateRes.apiResponse!.length; i++) {
          _states[favStateRes.apiResponse![i].stateNameLanguage!] =
              favStateRes.apiResponse![i].stateId!;
        }
      });
    }
    return favStateRes;
  }

  Future<BirdBreedModel> getBirdBreedData() async {
    var getBirdBreedRes = await AuthServices().getBirdList(context);
    if (getBirdBreedRes.errorCount == 0 &&
        getBirdBreedRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < getBirdBreedRes.apiResponse!.length; i++) {
          birdBreedList[
                  getBirdBreedRes.apiResponse![i].birdbreedNameLanguage!] =
              getBirdBreedRes.apiResponse![i].birdbreedId!;
        }
      });
    }
    return getBirdBreedRes;
  }

  Future<CompanyListModel> getCompanyData() async {
    var getCompanyRes = await AuthServices().getCompanyList(context);
    if (getCompanyRes.errorCount == 0 && getCompanyRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < getCompanyRes.apiResponse!.length; i++) {
          companyList[getCompanyRes.apiResponse![i].companyNameLanguage!] =
              getCompanyRes.apiResponse![i].companyId!;
        }
      });
    }
    return getCompanyRes;
  }

  Future<CityListModel> getCityData() async {
    var getCityRes = await AuthServices().getCityList(context, "");
    if (getCityRes.errorCount == 0 && getCityRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < getCityRes.apiResponse!.length; i++) {
          cityList[getCityRes.apiResponse![i].cityNameLanguage!] =
              getCityRes.apiResponse![i].cityId!;
        }
      });
    }
    return getCityRes;
  }

  // Function to show a bottom sheet
  void _showLanguageBottomSheet() async {
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
                                // Accessing the map key-value pairs
                                final stateName = _states.keys.elementAt(index);
                                final stateId = _states[stateName];

                                return Column(
                                  children: [
                                    ListTile(
                                      trailing: Radio<String>(
                                        value: stateId!,
                                        groupValue: _selectedStateID,
                                        onChanged: (value) {
                                          setState(() {
                                            stateController.text = stateName;
                                            _selectedStateID = value!;
                                          });
                                          SnackbarHelper.showSnackBar(
                                              _selectedStateID);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      title: Text(
                                        stateName, // Using the state name as text
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
    eggPriceController.text = mobileNumber;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.sellEgg)),
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
                      GestureDetector(
                        child: SizedBox(
                          height: 70.0,
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: birdTypeController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              iconColor: Colors.white,
                              prefixIcon: Icon(LucideIcons.bird),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Bird Type",
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
                                  value == 'Select Bird Type') {
                                return 'Please select bird type';
                              }
                              return null;
                            },
                            onTap: _showLanguageBottomSheet,
                          ),
                        ),
                      ),
                      AppTextFormField(
                        controller: eggPriceController,
                        labelText: "Egg Price (1)",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        enabled: true,
                        prefixIcon: Icon(Icons.currency_rupee_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter egg price';
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
                              labelText: "Effect from date",
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
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(
                                    () => dateController.text = formattedDate);
                              }
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Is Hatching Egg?",
                              style: AppTheme.informationString,
                            ),
                          ),
                          Transform.scale(
                            alignment: Alignment.centerRight,
                            scale: 0.7, // Adjust the scale to reduce the size
                            child: Switch(
                              value: _hatchingEggs,
                              onChanged: (value) {
                                setState(() {
                                  _hatchingEggs = value;
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
                        ],
                      ),
                      GestureDetector(
                        child: SizedBox(
                          height: 70.0,
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: stateController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(LucideIcons.mapPin),
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
                            onTap: _showLanguageBottomSheet,
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
                            onTap: _showLanguageBottomSheet,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: SizedBox(
                          height: 70.0,
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: companyController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(LucideIcons.building),
                              iconColor: Colors.white,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Company",
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
                            onTap: _showLanguageBottomSheet,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Is Special Sale?",
                              style: AppTheme.informationString,
                            ),
                          ),
                          Transform.scale(
                            alignment: Alignment.centerRight,
                            scale: 0.7, // Adjust the scale to reduce the size
                            child: Switch(
                              value: _specialSale,
                              onChanged: (value) {
                                setState(() {
                                  _specialSale = value;
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
                        ],
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
                                        context, eggPriceController.text);
                                if (generateOtpRes.errorCount == 0) {
                                  NavigationHelper.pushNamed(
                                    AppRoutes.loginOtp,
                                    arguments: {
                                      'pageType':
                                          AppRoutes.registerBasicDetails,
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
