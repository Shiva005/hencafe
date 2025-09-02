import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/company_list_model.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../models/bird_breed_model.dart';
import '../models/chicken_price_model.dart' as chickenPrice;
import '../models/city_list_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class ChickenSellCreateScreen extends StatefulWidget {
  const ChickenSellCreateScreen({super.key});

  @override
  State<ChickenSellCreateScreen> createState() =>
      _ChickenSellCreateScreenState();
}

class _ChickenSellCreateScreenState extends State<ChickenSellCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController birdTypeController;
  late final TextEditingController farmerPriceController;
  late final TextEditingController commentController;
  late final TextEditingController qtyController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
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
  String selectedCityID = '';
  bool isHatchingEggs = false;
  bool isSpecialSale = false;
  var hatchingType = "N";
  var saleType = "N";
  bool _isInitialized = false;
  late final chickenPrice.ApiResponse chickenPriceModel;
  late SharedPreferences prefs;

  void initializeControllers() {
    farmerPriceController = TextEditingController()
      ..addListener(controllerListener);
    commentController = TextEditingController()
      ..addListener(controllerListener);
    qtyController = TextEditingController()..addListener(controllerListener);
    startDateController = TextEditingController()
      ..addListener(controllerListener);
    endDateController = TextEditingController()
      ..addListener(controllerListener);
    birdTypeController = TextEditingController()
      ..addListener(controllerListener);
    stateController = TextEditingController()..addListener(controllerListener);
    cityController = TextEditingController()..addListener(controllerListener);
    companyController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    farmerPriceController.dispose();
    commentController.dispose();
    qtyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    birdTypeController.dispose();
    stateController.dispose();
    cityController.dispose();
    companyController.dispose();
  }

  void controllerListener() {
    final eggPrice = farmerPriceController.text;
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
    prefs = await SharedPreferences.getInstance();
    final favStateRes = await AuthServices().getFavouriteStateList(
      context,
      prefs.getString(AppStrings.prefUserID)!,
    );
    if (favStateRes.errorCount == 0 && favStateRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < favStateRes.apiResponse!.length; i++) {
          statelist[favStateRes
                  .apiResponse![i]
                  .stateInfo![0]
                  .stateNameLanguage!] =
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
          birdBreedList[getBirdBreedRes
                  .apiResponse![i]
                  .birdbreedNameLanguage!] =
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
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
                                      allData.entries.where(
                                        (entry) =>
                                            entry.key.toLowerCase().contains(
                                              query.toLowerCase(),
                                            ) ||
                                            entry.value.toLowerCase().contains(
                                              query.toLowerCase(),
                                            ),
                                      ),
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
                                    final key = filteredData.keys.elementAt(
                                      index,
                                    );
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            key,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          onTap: () {
                                            controller.text = key;
                                            Navigator.pop(context);
                                            if (title == "State") {
                                              cityList.clear();
                                              cityController.text = "";
                                              getCityData(
                                                statelist[key].toString(),
                                              );
                                            } else if (title == "City") {
                                              selectedCityID = cityList[key]
                                                  .toString();
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
    if (!_isInitialized && pageType == 'chickenSaleDetails') {
      chickenPriceModel = arguments['chickenPriceModel'];
      selectedCityID = chickenPriceModel.addressDetails![0].cityId!;
      farmerPriceController.text = chickenPriceModel.farmLiveBirdCost!;
      startDateController.text = chickenPriceModel.chickensaleEffectFrom!;
      endDateController.text = chickenPriceModel.chickensaleEffectTo!;
      commentController.text = chickenPriceModel.chickensaleComment!;
      birdTypeController.text =
          chickenPriceModel.birdBreedInfo![0].birdbreedNameLanguage!;
      stateController.text =
          chickenPriceModel.addressDetails![0].stateNameLanguage!;
      cityController.text =
          chickenPriceModel.addressDetails![0].cityNameLanguage!;
      companyController.text =
          chickenPriceModel.companyBasicInfo![0].companyNameLanguage!;
      isSpecialSale = chickenPriceModel.isSpecialSale == 'Y';
      saleType = isSpecialSale ? 'Y' : 'N';
      getCityData(chickenPriceModel.addressDetails![0].stateId!);
      _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBar(title: AppStrings.sellChicken),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Card(
          color: Colors.white,
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == 'Select Bird Type') {
                                return 'Please select Bird type';
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
                            flex: 4,
                            child: AppTextFormField(
                              controller: qtyController,
                              labelText: "Kg",
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 3,
                              enabled: false,
                              prefixIcon: Icon(
                                Icons.production_quantity_limits,
                              ),
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
                            flex: 7,
                            child: AppTextFormField(
                              controller: farmerPriceController,
                              labelText: "Farmer Price",
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
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value == 'Start Date') {
                                      return 'Please select Start Date';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2040),
                                    );
                                    if (pickedDate != null) {
                                      String formattedDate = DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(pickedDate);
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
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.green.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == 'End Date') {
                                    return 'Please select End Date';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  // Try parsing start date
                                  DateTime startDate;
                                  try {
                                    startDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(startDateController.text);
                                  } catch (e) {
                                    startDate = DateTime.now();
                                  }

                                  // Try parsing current end date if it's not empty
                                  DateTime initialDate;
                                  if (endDateController.text.isNotEmpty) {
                                    try {
                                      initialDate = DateFormat(
                                        'yyyy-MM-dd',
                                      ).parse(endDateController.text);
                                    } catch (e) {
                                      initialDate = startDate.add(
                                        Duration(days: 0),
                                      );
                                    }
                                  } else {
                                    initialDate = startDate.add(
                                      Duration(days: 0),
                                    );
                                  }

                                  // Show date picker
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: startDate.add(Duration(days: 0)),
                                    lastDate: startDate.add(Duration(days: 14)),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(pickedDate);
                                    setState(
                                      () => endDateController.text =
                                          formattedDate,
                                    );
                                  }
                                },
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade200,
                                ),
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            readOnly: true,
                            enabled: stateController.text.isEmpty
                                ? false
                                : true,
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade200,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == 'Company') {
                                return 'Please select Company';
                              }
                              return null;
                            },
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
                      ),
                      if (prefs.getString(AppStrings.prefMembershipType) ==
                          "Platinum")
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
                              if (pageType == 'chickenSaleDetails') {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  var updateSellChickenRes =
                                      await AuthServices().updateSellChicken(
                                        context,
                                        companyList[companyController.text]
                                            .toString(),
                                        birdBreedList[birdTypeController.text]
                                            .toString(),
                                        qtyController.text,
                                        farmerPriceController.text,
                                        commentController.text,
                                        startDateController.text,
                                        endDateController.text,
                                        saleType,
                                        statelist[stateController.text]
                                            .toString(),
                                        selectedCityID,
                                        chickenPriceModel.chickensaleUuid
                                            .toString(),
                                        chickenPriceModel.chickensaleId
                                            .toString(),
                                      );
                                  if (updateSellChickenRes
                                          .apiResponse![0]
                                          .responseStatus ==
                                      true) {
                                    Navigator.pop(context);
                                  } else {
                                    SnackbarHelper.showSnackBar(
                                      updateSellChickenRes
                                          .apiResponse![0]
                                          .responseDetails,
                                    );
                                  }
                                }
                              } else {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  String uuids = uuid.v1();
                                  var sellEggRes = await AuthServices()
                                      .sellChicken(
                                        context,
                                        companyList[companyController.text]
                                            .toString(),
                                        birdBreedList[birdTypeController.text]
                                            .toString(),
                                        qtyController.text,
                                        farmerPriceController.text,
                                        commentController.text,
                                        startDateController.text,
                                        endDateController.text,
                                        saleType,
                                        statelist[stateController.text]
                                            .toString(),
                                        cityList[cityController.text]
                                            .toString(),
                                        uuids,
                                      );
                                  if (sellEggRes
                                          .apiResponse![0]
                                          .responseStatus ==
                                      true) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.bottomSlide,
                                      dialogType: DialogType.success,
                                      dialogBackgroundColor: Colors.white,
                                      title: sellEggRes
                                          .apiResponse![0]
                                          .responseDetails,
                                      titleTextStyle: AppTheme.appBarText,
                                      descTextStyle: AppTheme.appBarText,
                                      btnOkOnPress: () {
                                        NavigationHelper.pushReplacementNamed(
                                          AppRoutes.uploadFileScreen,
                                          arguments: {
                                            'reference_from': 'CHICKEN_SALE',
                                            'reference_uuid': uuids,
                                            'isSingleFilePick': false,
                                          },
                                        );
                                      },
                                      btnCancelOnPress: () {
                                        NavigationHelper.pushReplacementNamed(
                                          AppRoutes.chickenPriceScreen,
                                        );
                                      },
                                      btnOkText: 'Yes',
                                      btnCancelText: 'No',
                                      btnOkColor: Colors.greenAccent.shade700,
                                    ).show();
                                  } else {
                                    SnackbarHelper.showSnackBar(
                                      sellEggRes
                                          .apiResponse![0]
                                          .responseDetails,
                                    );
                                  }
                                }
                                _btnController.reset();
                              }
                            },
                            color: AppColors.primaryColor,
                            child: Row(
                              children: [
                                Text(
                                  pageType == 'chickenSaleDetails'
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
