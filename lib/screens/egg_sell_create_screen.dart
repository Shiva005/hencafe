import 'package:flutter/material.dart';
import 'package:hencafe/models/city_list_model.dart';
import 'package:hencafe/models/company_list_model.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

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
  late final TextEditingController qtyController;
  late final TextEditingController dateController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController companyController;
  var uuid = Uuid();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Map<String, String> birdBreedList = {};
  Map<String, String> companyList = {};
  Map<String, String> statelist = {};
  Map<String, String> cityList = {};
  bool isHatchingEggs = false;
  bool isSpecialSale = false;
  var hatchingType = "N";
  var saleType = "G";

  void initializeControllers() {
    eggPriceController = TextEditingController()
      ..addListener(controllerListener);
    qtyController = TextEditingController()..addListener(controllerListener);
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
    qtyController.dispose();
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
    getBirdBreedData();
    getCompanyData();
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
          statelist[favStateRes.apiResponse![i].stateNameLanguage!] =
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

  Future<CityListModel> getCityData(String state) async {
    var getCityRes = await AuthServices().getCityList(context, state);
    if (getCityRes.errorCount == 0 && getCityRes.apiResponse != null) {
      setState(() {
        LoadingDialogHelper.dismissLoadingDialog(context);
        for (int i = 0; i < getCityRes.apiResponse!.length; i++) {
          cityList[getCityRes.apiResponse![i].cityNameLanguage!] =
              getCityRes.apiResponse![i].cityId!;
        }
      });
    }
    return getCityRes;
  }

  void _showSelectionBottomSheet({
    required String title,
    required Future<Map<String, String>> Function() fetchData, // Fetch function
    required TextEditingController controller,
  }) {
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
              return FutureBuilder<Map<String, String>>(
                future: fetchData(), // Fetch data dynamically
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          constraints.maxHeight * 0.9, // 90% of screen height
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Select $title",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length, // Example content
                              itemBuilder: (context, index) {
                                final key = data.keys.elementAt(index);
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        key,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      onTap: () {
                                        controller.text = key;
                                        Navigator.pop(context);
                                        if (title == "State") {
                                          cityList.clear();
                                          cityController.text = "";
                                          LoadingDialogHelper.showLoadingDialog(
                                              context);
                                          getCityData(
                                              statelist[key].toString());
                                        }
                                      },
                                    ),
                                    Divider(
                                        color: Colors.grey.shade200, height: 2),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    qtyController.text = "1";
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
                            onTap: () async => _showSelectionBottomSheet(
                              title: "Bird Type",
                              fetchData: () async => birdBreedList,
                              controller: birdTypeController,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextFormField(
                              controller: qtyController,
                              labelText: "Qty",
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 3,
                              enabled: false,
                              prefixIcon:
                                  Icon(Icons.production_quantity_limits),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: AppTextFormField(
                              controller: eggPriceController,
                              labelText: "Egg Price",
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 6,
                              enabled: true,
                              prefixIcon: Icon(Icons.currency_rupee_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter egg price';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
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
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
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
                              value: isHatchingEggs,
                              onChanged: (value) {
                                setState(() {
                                  isHatchingEggs = value;
                                  if (value) {
                                    hatchingType = "Y";
                                  } else {
                                    hatchingType = "N";
                                  }
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
                            onTap: () async => _showSelectionBottomSheet(
                              title: "State",
                              fetchData: () async => statelist,
                              controller: stateController,
                            ),
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
                            onTap: () async => _showSelectionBottomSheet(
                              title: "City",
                              fetchData: () async => cityList,
                              controller: cityController,
                            ),
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
                            onTap: () async => _showSelectionBottomSheet(
                              title: "Company",
                              fetchData: () async => companyList,
                              controller: companyController,
                            ),
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
                              value: isSpecialSale,
                              onChanged: (value) {
                                setState(() {
                                  isSpecialSale = value;
                                  if (value) {
                                    saleType = "S";
                                  } else {
                                    saleType = "G";
                                  }
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
                                var sellEggRes = await AuthServices().sellEgg(
                                    context,
                                    companyList[companyController.text]
                                        .toString(),
                                    birdBreedList[birdTypeController.text]
                                        .toString(),
                                    qtyController.text,
                                    eggPriceController.text,
                                    dateController.text,
                                    saleType,
                                    hatchingType,
                                    statelist[stateController.text].toString(),
                                    cityList[cityController.text].toString(),
                                    uuid.v1());
                                if (sellEggRes.errorCount == 0) {
                                  NavigationHelper.pushNamed(
                                    AppRoutes.dashboardScreen,
                                    arguments: {
                                      'uuid':uuid,
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
