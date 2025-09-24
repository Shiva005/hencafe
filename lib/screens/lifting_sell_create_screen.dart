import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/user_favourite_state_model.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../helpers/snackbar_helper.dart';
import '../models/bird_breed_model.dart';
import '../models/city_list_model.dart';
import '../models/lifting_price_model.dart' as liftingPrice;
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class LiftingSellCreateScreen extends StatefulWidget {
  const LiftingSellCreateScreen({super.key});

  @override
  State<LiftingSellCreateScreen> createState() =>
      _LiftingSellCreateScreenState();
}

class _LiftingSellCreateScreenState extends State<LiftingSellCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController birdTypeController;
  late final TextEditingController birdPriceController;
  late final TextEditingController commentController;
  late final TextEditingController qtyController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController companyController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  late final TextEditingController addressController;
  var uuid = Uuid();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Map<String, String> birdBreedList = {};
  Map<String, String> statelist = {};
  Map<String, String> cityList = {};
  String selectedCityID = '';
  var saleType = "N";
  bool _isInitialized = false;
  late final liftingPrice.ApiResponse liftingPriceModel;
  late SharedPreferences prefs;

  void initializeControllers() {
    birdPriceController = TextEditingController()
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
    ageController = TextEditingController()..addListener(controllerListener);
    weightController = TextEditingController()..addListener(controllerListener);
    addressController = TextEditingController()
      ..addListener(controllerListener);
    companyController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    birdPriceController.dispose();
    commentController.dispose();
    qtyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    birdTypeController.dispose();
    stateController.dispose();
    cityController.dispose();
    ageController.dispose();
    weightController.dispose();
    addressController.dispose();
  }

  void controllerListener() {
    final eggPrice = birdPriceController.text;
    if (eggPrice.isEmpty) return;
  }

  @override
  void initState() {
    _initPrefs();
    initializeControllers();
    startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fetchStates();
    getBirdBreedData();
    super.initState();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
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
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String pageType = arguments['pageType'];
    if (!_isInitialized && pageType == 'liftingSaleDetails') {
      liftingPriceModel = arguments['liftingPriceModel'];
      qtyController.text = liftingPriceModel.liftingsaleTotalBirds!.toString();
      selectedCityID = liftingPriceModel.addressDetails![0].cityId!;
      birdPriceController.text = liftingPriceModel.liftingsaleCostPerKg!;
      startDateController.text = liftingPriceModel.liftingsaleEffectFrom!;
      endDateController.text = liftingPriceModel.liftingsaleEffectTo!;
      commentController.text = liftingPriceModel.liftingsaleComment!;
      birdTypeController.text =
          liftingPriceModel.birdBreedInfo![0].birdbreedNameLanguage!;
      stateController.text =
          liftingPriceModel.addressDetails![0].stateNameLanguage!;
      cityController.text =
          liftingPriceModel.addressDetails![0].cityNameLanguage!;

      ageController.text = liftingPriceModel.birdAgeInDays!.toString();
      weightController.text = liftingPriceModel.birdWeightInKg!.toString();
      addressController.text = liftingPriceModel.liftingsaleAddress!.toString();
      getCityData(liftingPriceModel.addressDetails![0].stateId!);
      _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBar(title: AppStrings.sellBird),
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
                      AppTextFormField(
                        controller: qtyController,
                        labelText: "Total Lifting Birds for sale",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 5,
                        enabled: true,
                        prefixIcon: Icon(Icons.production_quantity_limits),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter total Lifting Birds for sale';
                          }
                          return null;
                        },
                      ),
                      SizedBox(width: 10),
                      AppTextFormField(
                        controller: birdPriceController,
                        labelText: "Bird price/kg",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 6,
                        enabled: true,
                        prefixIcon: Icon(Icons.currency_rupee_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Bird price per Kg';
                          }
                          return null;
                        },
                      ),
                      AppTextFormField(
                        controller: ageController,
                        labelText: "Bird age in Days",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 3,
                        enabled: true,
                        prefixIcon: Icon(Icons.cake_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Bird age in Days';
                          }
                          return null;
                        },
                      ),
                      SizedBox(width: 10),
                      AppTextFormField(
                        controller: weightController,
                        labelText: "Bird total weight in Kg",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 6,
                        enabled: true,
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Bird weight in Kg';
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
                                    DateTime today = DateTime.now();
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: today,
                                      firstDate: DateTime(today.year, today.month, today.day),
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
                                    lastDate: startDate.add(Duration(days: 30)),
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
                      SizedBox(width: 10),
                      AppTextFormField(
                        controller: addressController,
                        labelText: "Address",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        minLines: 2,
                        maxLines: 2,
                        enabled: true,
                        prefixIcon: Icon(Icons.my_location),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Address';
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundedLoadingButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 45.0,
                            controller: _btnController,
                            onPressed: () async {
                              if (pageType == 'liftingSaleDetails') {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  var updateLiftingSaleRes =
                                      await AuthServices().updateLiftingSell(
                                        context,
                                        birdBreedList[birdTypeController.text]
                                            .toString(),
                                        qtyController.text,
                                        birdPriceController.text,
                                        commentController.text,
                                        addressController.text,
                                        startDateController.text,
                                        endDateController.text,
                                        statelist[stateController.text]
                                            .toString(),
                                        selectedCityID,
                                        liftingPriceModel.liftingsaleId!,
                                        liftingPriceModel.liftingsaleUuid!,
                                        ageController.text,
                                        weightController.text,
                                      );
                                  if (updateLiftingSaleRes
                                          .apiResponse![0]
                                          .responseStatus ==
                                      true) {
                                    Navigator.pop(context);
                                  } else {
                                    SnackbarHelper.showSnackBar(
                                      updateLiftingSaleRes
                                          .apiResponse![0]
                                          .responseDetails,
                                    );
                                  }
                                }
                              } else {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  String uuids = uuid.v1();
                                  var liftingSaleRes = await AuthServices()
                                      .createLiftingSell(
                                        context,
                                        birdBreedList[birdTypeController.text]
                                            .toString(),
                                        qtyController.text,
                                        birdPriceController.text,
                                        commentController.text,
                                        addressController.text,
                                        startDateController.text,
                                        endDateController.text,
                                        statelist[stateController.text]
                                            .toString(),
                                        cityList[cityController.text]
                                            .toString(),
                                        uuids,
                                        ageController.text,
                                        weightController.text,
                                      );
                                  if (liftingSaleRes
                                          .apiResponse![0]
                                          .responseStatus ==
                                      true) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.bottomSlide,
                                      dialogType: DialogType.success,
                                      dialogBackgroundColor: Colors.white,
                                      title: liftingSaleRes
                                          .apiResponse![0]
                                          .responseDetails,
                                      titleTextStyle: AppTheme.appBarText,
                                      descTextStyle: AppTheme.appBarText,
                                      btnOkOnPress: () {
                                        NavigationHelper.pushReplacementNamed(
                                          AppRoutes.uploadFileScreen,
                                          arguments: {
                                            'reference_from': 'LIFTING_SALE',
                                            'reference_uuid': uuids,
                                            'isSingleFilePick': false,
                                          },
                                        );
                                      },
                                      btnCancelOnPress: () {
                                        NavigationHelper.pop(context);
                                        /*NavigationHelper.pushReplacementNamed(
                                          AppRoutes.liftingPriceScreen,
                                        );*/
                                      },
                                      btnOkText: 'Yes',
                                      btnCancelText: 'No',
                                      btnOkColor: Colors.greenAccent.shade700,
                                    ).show();
                                  } else {
                                    SnackbarHelper.showSnackBar(
                                      liftingSaleRes
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
                                  pageType == 'liftingSaleDetails'
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
