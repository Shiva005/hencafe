import 'package:flutter/material.dart';
import 'package:hencafe/helpers/navigation_helper.dart';
import 'package:hencafe/models/city_list_model.dart' as city;
import 'package:hencafe/models/profile_model.dart';
import 'package:hencafe/models/state_model.dart' as state;
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../components/app_text_form_field.dart';
import '../helpers/snackbar_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_strings.dart';

class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({super.key});

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController addressTypeController;
  late final TextEditingController zipCodeController;
  late final TextEditingController addressController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  var uuid = Uuid();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<state.ApiResponse> _states = [];
  List<city.ApiResponse> _city = [];
  String? _selectedStateID;
  String? _selectedCityID;
  bool _isInitialized = false;
  late final AddressDetails addressDetailsModel;

  void initializeControllers() {
    addressTypeController = TextEditingController()
      ..addListener(controllerListener);
    stateController = TextEditingController()..addListener(controllerListener);
    cityController = TextEditingController()..addListener(controllerListener);
    addressController = TextEditingController()
      ..addListener(controllerListener);
    zipCodeController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    zipCodeController.dispose();
    addressController.dispose();
    stateController.dispose();
    cityController.dispose();
  }

  void controllerListener() {
    final email = zipCodeController.text;
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

  void _showAddressTypeBottomSheet() {
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
                children: ['Home', 'Office', 'Others'].map((type) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align content to the left
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          type,
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
                      addressTypeController.text = type;
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String pageType = args?['pageType'] ?? '';

    if (!_isInitialized && pageType != AppRoutes.createAddressScreen) {
      addressDetailsModel = args!['addressModel'];
      addressController.text = addressDetailsModel.addressAddress!;
      addressTypeController.text = addressDetailsModel.addressType!;
      stateController.text =
          addressDetailsModel.locationInfo![0].stateNameLanguage!;
      cityController.text =
          addressDetailsModel.locationInfo![0].cityNameLanguage!;
      zipCodeController.text = addressDetailsModel.addressZipcode!;
      _selectedCityID = addressDetailsModel.locationInfo![0].cityId!;
      _selectedStateID = addressDetailsModel.locationInfo![0].stateId!;
      _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppBar(
              title: pageType == AppRoutes.createAddressScreen
                  ? AppStrings.createAccount
                  : 'Update Address')),
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
                            controller: addressTypeController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.my_location),
                              iconColor: Colors.white,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Address Type",
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
                                  value == 'Select Address Type') {
                                return 'Please select address type';
                              }
                              return null;
                            },
                            onTap: _showAddressTypeBottomSheet,
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
                              enabled: stateController.text.isNotEmpty,
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
                        controller: zipCodeController,
                        labelText: AppStrings.zipCode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        enabled: true,
                        prefixIcon: Icon(Icons.folder_zip_rounded),
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
                                var createAddressRes;
                                if (pageType == AppRoutes.createAddressScreen) {
                                  createAddressRes = await AuthServices()
                                      .createAddress(
                                          context,
                                          uuid.v1(),
                                          'USER',
                                          addressTypeController.text,
                                          addressController.text,
                                          _selectedStateID!,
                                          _selectedCityID!,
                                          zipCodeController.text);
                                } else {
                                  createAddressRes = await AuthServices()
                                      .updateAddress(
                                          context,
                                          addressDetailsModel.addressId!,
                                          addressDetailsModel.addressUuid!,
                                          'USER',
                                          addressTypeController.text,
                                          addressController.text,
                                          _selectedStateID!,
                                          _selectedCityID!,
                                          zipCodeController.text);
                                }

                                if (createAddressRes
                                        .apiResponse![0].responseStatus ==
                                    true) {
                                  SnackbarHelper.showSnackBar(createAddressRes
                                      .apiResponse![0].responseDetails!);
                                  NavigationHelper.pop(context);
                                } else {
                                  SnackbarHelper.showSnackBar(createAddressRes
                                      .apiResponse![0].responseDetails!);
                                }
                              }
                              _btnController.reset();
                            },
                            color: AppColors.primaryColor,
                            child: Row(
                              children: [
                                Text(
                                  pageType == AppRoutes.createAddressScreen
                                      ? 'Create Address'
                                      : 'Update Address',
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
