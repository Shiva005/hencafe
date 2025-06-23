import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
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
import '../models/chick_price_model.dart' as chickPrice;
import '../models/city_list_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class ChickSellCreateScreen extends StatefulWidget {
  const ChickSellCreateScreen({super.key});

  @override
  State<ChickSellCreateScreen> createState() => _ChickSellCreateScreenState();
}

class _ChickSellCreateScreenState extends State<ChickSellCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController chickTypeController;
  late final TextEditingController chickPriceController;
  late final TextEditingController commentController;
  late final TextEditingController qtyController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController companyController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  var uuid = Uuid();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Map<String, String> birdBreedList = {};
  Map<String, String> companyList = {};
  Map<String, String> statelist = {};
  Map<String, String> cityList = {};
  String selectedCityID = '';
  bool isSpecialSale = false;
  var saleType = "N";
  bool _isInitialized = false;
  late final chickPrice.ApiResponse chickPriceModel;

  void initializeControllers() {
    chickPriceController = TextEditingController()
      ..addListener(controllerListener);
    commentController = TextEditingController()
      ..addListener(controllerListener);
    qtyController = TextEditingController()..addListener(controllerListener);
    startDateController = TextEditingController()
      ..addListener(controllerListener);
    endDateController = TextEditingController()
      ..addListener(controllerListener);
    chickTypeController = TextEditingController()
      ..addListener(controllerListener);
    stateController = TextEditingController()..addListener(controllerListener);
    cityController = TextEditingController()..addListener(controllerListener);
    ageController = TextEditingController()..addListener(controllerListener);
    weightController = TextEditingController()..addListener(controllerListener);
    companyController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    chickPriceController.dispose();
    commentController.dispose();
    qtyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    chickTypeController.dispose();
    stateController.dispose();
    cityController.dispose();
    companyController.dispose();
    ageController.dispose();
    weightController.dispose();
  }

  void controllerListener() {
    final eggPrice = chickPriceController.text;
    if (eggPrice.isEmpty) return;
  }

  @override
  void initState() {
    initializeControllers();
    startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
    final favStateRes = await AuthServices().getFavouriteStateList(context,'');
    if (favStateRes.errorCount == 0 && favStateRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < favStateRes.apiResponse!.length; i++) {
          statelist[favStateRes
                  .apiResponse![i].stateInfo![0].stateNameLanguage!] =
              favStateRes.apiResponse![i].stateInfo![0].stateId!;
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
    required Future<Map<String, String>> Function() fetchData,
    required TextEditingController controller,
  }) {
    final TextEditingController searchController = TextEditingController();
    Map<String, String> allData = {};
    Map<String, String> filteredData = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FutureBuilder<Map<String, String>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text("Failed to load data.")),
                  );
                }

                if (allData.isEmpty) {
                  allData = snapshot.data!;
                  filteredData = Map.from(allData);
                }

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                "Select $title",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search $title',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (query) {
                                  setModalState(() {
                                    filteredData = Map.fromEntries(
                                      allData.entries.where((entry) =>
                                      entry.key.toLowerCase().contains(query.toLowerCase()) ||
                                          entry.value.toLowerCase().contains(query.toLowerCase())),
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: filteredData.isNotEmpty
                              ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final key = filteredData.keys.elementAt(index);
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
                                        getCityData(statelist[key].toString());
                                      } else if (title == "City") {
                                        selectedCityID = cityList[key].toString();
                                      }
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey.shade200,
                                    height: 2,
                                  ),
                                ],
                              );
                            },
                          )
                              : const Center(child: Text("No results found.")),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
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



  @override
  Widget build(BuildContext context) {
    qtyController.text = '1';
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String pageType = arguments['pageType'];
    if (!_isInitialized && pageType == 'chickSaleDetails') {
      chickPriceModel = arguments['chickPriceModel'];
      selectedCityID = chickPriceModel.addressDetails![0].cityId!;
      chickPriceController.text = chickPriceModel.chicksaleCost!;
      startDateController.text = chickPriceModel.chicksaleEffectFrom!;
      endDateController.text = chickPriceModel.chickaleEffectTo!;
      commentController.text = chickPriceModel.chicksaleComment!;
      chickTypeController.text =
          chickPriceModel.birdBreedInfo![0].birdbreedNameLanguage!;
      stateController.text =
          chickPriceModel.addressDetails![0].stateNameLanguage!;
      cityController.text =
          chickPriceModel.addressDetails![0].cityNameLanguage!;
      companyController.text =
          chickPriceModel.companyBasicInfo![0].companyNameLanguage!;
      ageController.text = chickPriceModel.birdAgeInDays!.toString();
      weightController.text = chickPriceModel.birdWeightInGrams!.toString();
      getCityData(chickPriceModel.addressDetails![0].stateId!);
      isSpecialSale = chickPriceModel.isSpecialSale == 'Y';
      saleType = isSpecialSale ? 'Y' : 'N';
      _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(title: AppStrings.sellChick)),
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
                            controller: chickTypeController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              iconColor: Colors.white,
                              prefixIcon: Icon(LucideIcons.bird),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Chick Type",
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
                                  value == 'Select Chick Type') {
                                return 'Please select Chick type';
                              }
                              return null;
                            },
                            onTap: () async => _showSelectionBottomSheet(
                              title: "Chick Type",
                              fetchData: () async => birdBreedList,
                              controller: chickTypeController,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: qtyController,
                              labelText: "Quantity",
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 3,
                              enabled: false,
                              prefixIcon:
                                  Icon(Icons.production_quantity_limits),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextFormField(
                              controller: chickPriceController,
                              labelText: "Price",
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 6,
                              enabled: true,
                              prefixIcon: Icon(Icons.currency_rupee_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Chick price';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      AppTextFormField(
                        controller: ageController,
                        labelText: "Age in Days",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 3,
                        enabled: true,
                        prefixIcon: Icon(Icons.cake_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Chick age';
                          }
                          return null;
                        },
                      ),
                      SizedBox(width: 10),
                      AppTextFormField(
                        controller: weightController,
                        labelText: "Weight in Grams",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 6,
                        enabled: true,
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Chick weight';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 70.0,
                              child: GestureDetector(
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: startDateController,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.calendar_month),
                                    iconColor: Colors.white,
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Start Date",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green.shade200),
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
                                      setState(() {
                                        startDateController.text =
                                            formattedDate;
                                        endDateController.text = "";
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 70.0,
                              child: GestureDetector(
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: endDateController,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(Icons.calendar_month),
                                    iconColor: Colors.white,
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "End Date",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green.shade200),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2040),
                                    );

                                    if (pickedDate != null) {
                                      if (startDateController.text.isNotEmpty) {
                                        DateTime? startDate = DateTime.tryParse(
                                            startDateController.text);
                                        if (startDate != null) {
                                          int diff = pickedDate
                                              .difference(startDate)
                                              .inDays;
                                          if (diff > 7) {
                                            AwesomeDialog(
                                              context: context,
                                              animType: AnimType.bottomSlide,
                                              dialogType: DialogType.warning,
                                              dialogBackgroundColor:
                                                  Colors.white,
                                              titleTextStyle:
                                                  AppTheme.appBarText,
                                              title:
                                                  'You can only select up to 7 days from the start date.',
                                              btnOkOnPress: () {},
                                              btnOkText: 'OK',
                                              btnOkColor:
                                                  Colors.yellow.shade700,
                                            ).show();
                                            endDateController.text = "";
                                            return;
                                          }
                                        }
                                      }

                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      setState(() => endDateController.text =
                                          formattedDate);
                                    }
                                  },
                                ),
                              ),
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
                            enabled:
                                stateController.text.isEmpty ? false : true,
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
                      AppTextFormField(
                        controller: commentController,
                        labelText: "Enter Comment",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        minLines: 2,
                        maxLines: 2,
                        prefixIcon: Icon(Icons.comment),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter comment';
                          }
                          return null;
                        },
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
                                    saleType = "Y";
                                  } else {
                                    saleType = "N";
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundedLoadingButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 45.0,
                            controller: _btnController,
                            onPressed: () async {
                              if (pageType == 'chickSaleDetails') {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  var updateSellChickRes = await AuthServices()
                                      .updateSellChick(
                                          context,
                                          companyList[companyController.text]
                                              .toString(),
                                          birdBreedList[
                                                  chickTypeController.text]
                                              .toString(),
                                          qtyController.text,
                                          chickPriceController.text,
                                          commentController.text,
                                          startDateController.text,
                                          endDateController.text,
                                          saleType,
                                          statelist[stateController.text]
                                              .toString(),
                                          selectedCityID,
                                          ageController.text,
                                          weightController.text,
                                          chickPriceModel.chicksaleUuid
                                              .toString(),
                                          chickPriceModel.chicksaleId
                                              .toString());
                                  if (updateSellChickRes
                                          .apiResponse![0].responseStatus ==
                                      true) {
                                    Navigator.pop(context);
                                  } else {
                                    SnackbarHelper.showSnackBar(
                                        updateSellChickRes
                                            .apiResponse![0].responseDetails);
                                  }
                                }
                              } else {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  String uuids = uuid.v1();
                                  var sellEggRes = await AuthServices()
                                      .sellChick(
                                          context,
                                          companyList[companyController.text]
                                              .toString(),
                                          birdBreedList[
                                                  chickTypeController.text]
                                              .toString(),
                                          qtyController.text,
                                          chickPriceController.text,
                                          commentController.text,
                                          startDateController.text,
                                          endDateController.text,
                                          saleType,
                                          statelist[stateController.text]
                                              .toString(),
                                          cityList[cityController.text]
                                              .toString(),
                                          uuids,
                                          ageController.text,
                                          weightController.text);
                                  if (sellEggRes
                                          .apiResponse![0].responseStatus ==
                                      true) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.bottomSlide,
                                      dialogType: DialogType.success,
                                      dialogBackgroundColor: Colors.white,
                                      title: sellEggRes
                                          .apiResponse![0].responseDetails,
                                      titleTextStyle: AppTheme.appBarText,
                                      descTextStyle: AppTheme.appBarText,
                                      btnOkOnPress: () {
                                        NavigationHelper.pushReplacementNamed(
                                          AppRoutes.uploadFileScreen,
                                          arguments: {
                                            'reference_from': 'CHICK_SALE',
                                            'reference_uuid': uuids,
                                            'pageType':
                                                AppRoutes.sellChickScreen,
                                          },
                                        );
                                      },
                                      btnCancelOnPress: () {
                                        NavigationHelper
                                            .pushReplacementNamedUntil(
                                          AppRoutes.dashboardScreen,
                                        );
                                      },
                                      btnOkText: 'Yes',
                                      btnCancelText: 'No',
                                      btnOkColor: Colors.greenAccent.shade700,
                                    ).show();
                                  } else {
                                    SnackbarHelper.showSnackBar(sellEggRes
                                        .apiResponse![0].responseDetails);
                                  }
                                }
                                _btnController.reset();
                              }
                            },
                            color: AppColors.primaryColor,
                            child: Row(
                              children: [
                                Text(
                                  pageType == 'chickSaleDetails'
                                      ? AppStrings.update
                                      : AppStrings.continueNext,
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
