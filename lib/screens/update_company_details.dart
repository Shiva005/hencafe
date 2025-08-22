import 'package:flutter/material.dart';
import 'package:hencafe/helpers/navigation_helper.dart';
import 'package:hencafe/values/app_regex.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/app_text_form_field.dart';
import '../helpers/snackbar_helper.dart';
import '../models/company_providers_model.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../values/app_colors.dart';
import '../values/app_strings.dart';

class UpdateCompanyDetailsScreen extends StatefulWidget {
  const UpdateCompanyDetailsScreen({super.key});

  @override
  State<UpdateCompanyDetailsScreen> createState() =>
      _UpdateCompanyDetailsScreenState();
}

class _UpdateCompanyDetailsScreenState
    extends State<UpdateCompanyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController companyNameController;
  late final TextEditingController companyDetailsController;
  late final TextEditingController websiteUrlController;
  late final TextEditingController contactPersonNameController;
  late final TextEditingController mobileController;
  late final TextEditingController emailController;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  late Future<CompanyProvidersModel> companyData;
  String referenceUUID = '';
  String companyPromotionStatus = '';
  bool isDataSet = false;

  void initializeControllers() {
    companyNameController = TextEditingController()
      ..addListener(controllerListener);
    companyDetailsController = TextEditingController()
      ..addListener(controllerListener);
    mobileController = TextEditingController()..addListener(controllerListener);
    emailController = TextEditingController()..addListener(controllerListener);
    websiteUrlController = TextEditingController()
      ..addListener(controllerListener);
    contactPersonNameController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    companyNameController.dispose();
    companyDetailsController.dispose();
    mobileController.dispose();
    emailController.dispose();
    websiteUrlController.dispose();
    contactPersonNameController.dispose();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (referenceUUID.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      referenceUUID = args['companyUUID'] ?? '';
      companyPromotionStatus = args['companyUUID'] ?? '';
      companyData = _fetchCompanyDetails(referenceUUID, companyPromotionStatus);
    }
  }

  Future<CompanyProvidersModel> _fetchCompanyDetails(
    String referenceUUID,
    String companyPromotionStatus,
  ) async {
    return await AuthServices().getCompanyProvidersList(
      context,
      referenceUUID,
      companyPromotionStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBar(title: 'Update Company Details'),
      ),
      body: FutureBuilder<CompanyProvidersModel>(
        future: companyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.apiResponse == null) {
            return const Center(child: Text("No data available"));
          }
          if (!isDataSet) {
            // ✅ Now set the text
            companyNameController.text =
                snapshot.data!.apiResponse![0].companyNameLanguage!;
            companyDetailsController.text =
                snapshot.data!.apiResponse![0].companyDetails!;
            websiteUrlController.text =
                snapshot.data!.apiResponse![0].companyWebsite!;
            contactPersonNameController.text =
                snapshot.data!.apiResponse![0].companyContactUserName!;
            mobileController.text =
                snapshot.data!.apiResponse![0].companyContactUserMobile!;
            emailController.text =
                snapshot.data!.apiResponse![0].companyContactUserEmail!;
            isDataSet = true; // ✅ prevents resetting on rebuild
          }

          return Padding(
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
                          AppTextFormField(
                            controller: companyNameController,
                            labelText: "Company Name",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            enabled: true,
                            prefixIcon: Icon(Icons.business_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter company name';
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: companyDetailsController,
                            labelText: "Company Details",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            enabled: true,
                            minLines: 3,
                            maxLines: 3,
                            prefixIcon: Icon(Icons.business_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter company details';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          AppTextFormField(
                            controller: websiteUrlController,
                            labelText: "Website Url",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            enabled: true,
                            prefixIcon: Icon(Icons.web_sharp),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter website url';
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: contactPersonNameController,
                            labelText: "Contact Person Name",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            enabled: true,
                            prefixIcon: Icon(Icons.person),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact person name';
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: mobileController,
                            labelText: AppStrings.mobile,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            enabled: true,
                            prefixIcon: Icon(Icons.call),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              if (value.length != 10) {
                                return 'Mobile number must be exact 10 character';
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: emailController,
                            labelText: '${AppStrings.email}*',
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
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RoundedLoadingButton(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40.0,
                                controller: _btnController,
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    var companyUpdateRes = await AuthServices()
                                        .companyUpdate(
                                          context,
                                          snapshot
                                              .data!
                                              .apiResponse![0]
                                              .companyId!,
                                          snapshot
                                              .data!
                                              .apiResponse![0]
                                              .companyUuid!,
                                          companyNameController.text,
                                          companyDetailsController.text,
                                          contactPersonNameController.text,
                                          mobileController.text,
                                          emailController.text,
                                          websiteUrlController.text,
                                        );
                                    if (companyUpdateRes
                                            .apiResponse![0]
                                            .responseStatus ==
                                        true) {
                                      NavigationHelper.pop(context);
                                      SnackbarHelper.showSnackBar(
                                        companyUpdateRes
                                            .apiResponse![0]
                                            .responseDetails!,
                                      );
                                    } else {
                                      SnackbarHelper.showSnackBar(
                                        companyUpdateRes
                                            .apiResponse![0]
                                            .responseDetails!,
                                      );
                                    }
                                  }
                                  _btnController.reset();
                                },
                                color: AppColors.primaryColor,
                                child: Text(
                                  AppStrings.update,
                                  style: TextStyle(color: Colors.white),
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
        },
      ),
    );
  }
}
