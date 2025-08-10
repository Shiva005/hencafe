import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/contact_history_model.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/utils/loading_dialog_helper.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../components/app_text_form_field.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../values/app_theme.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: MyAppBar(title: 'Contact Us'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: AppColors.primaryColor,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  Tab(text: 'Create Request'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ContactForm(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ContactHistoryPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactHistoryPage extends StatefulWidget {
  const ContactHistoryPage({super.key});

  @override
  State<ContactHistoryPage> createState() => _ContactHistoryPageState();
}

class _ContactHistoryPageState extends State<ContactHistoryPage> {
  List<ApiResponse> complaintList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContactHistory();
  }

  Future<void> fetchContactHistory() async {
    setState(() => isLoading = true);
    final contactData =
        await AuthServices().getContactHistory(context, "CON", "");
    setState(() {
      complaintList = contactData.apiResponse ?? [];
      isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'N':
        return Colors.blue;
      case 'I':
        return Colors.orange;
      case 'C':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (complaintList.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: fetchContactHistory,
      child: ListView.builder(
        itemCount: complaintList.length,
        itemBuilder: (context, index) {
          final item = complaintList[index];
          final statusValue = item.status?.value ?? "Unknown";
          final statusCode = item.status?.code ?? "Unknown";
          final statusColor = _getStatusColor(statusCode);

          return Dismissible(
            key: Key(item.id ?? index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              padding: const EdgeInsets.only(right: 40),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete_forever, color: Colors.white),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await AwesomeDialog(
                context: context,
                animType: AnimType.bottomSlide,
                dialogType: DialogType.warning,
                dialogBackgroundColor: Colors.white,
                titleTextStyle: AppTheme.appBarText,
                title: 'Are you sure you want to delete this record?',
                btnCancelOnPress: () {},
                btnCancelText: 'Cancel',
                btnOkOnPress: () async {
                  var deleteRecordRes =
                      await AuthServices().deleteContactRecord(
                    context,
                    item.uuid.toString(),
                  );
                  if (deleteRecordRes.apiResponse![0].responseStatus == true) {
                    setState(() {
                      complaintList.removeAt(index); // ✅ REMOVE FROM STATE
                    });
                  }
                  SnackbarHelper.showSnackBar(
                      deleteRecordRes.apiResponse![0].responseDetails);
                },
                btnOkText: 'Yes',
                btnOkColor: Colors.yellow.shade700,
              ).show();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("ID: #${item.id ?? ''}",
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 13)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusValue,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subjectLanguage ?? "No Subject",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.detailsLanguage ?? "No Details",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Updated: ${Utils.threeLetterDateFormatted(item.updatedOn.toString()).substring(0, 10)}",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        "Created: ${Utils.threeLetterDateFormatted(item.createdOn.toString()).substring(0, 10)}",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  late SharedPreferences prefs;
  String? email, phone;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString(AppStrings.prefEmail) ?? '';
      phone = prefs.getString(AppStrings.prefMobileNumber) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = email!;
    phoneController.text = phone!;
    return ListView(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Utils.openLink("https://wa.me/+919885279787/?text=Hello");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    border: Border.all(color: Colors.green.shade800),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            AppIconsData.whatsappOutline,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('WhatsApp Chat',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 1, width: 50, color: AppColors.primaryColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                  Container(
                      height: 1, width: 50, color: AppColors.primaryColor),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Fill the form',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryColor)),
                        ),
                      ),
                      AppTextFormField(
                        controller: emailController,
                        labelText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter email'
                            : null,
                      ),
                      AppTextFormField(
                        controller: phoneController,
                        labelText: "Phone",
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        enabled: false,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter phone number'
                            : null,
                      ),

                      // AppTextFormField Inputs
                      AppTextFormField(
                        controller: subjectController,
                        labelText: "Subject",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        enabled: true,
                        minLines: 2,
                        maxLines: 2,
                        prefixIcon: const Icon(Icons.my_library_books_outlined),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter name'
                            : null,
                      ),

                      AppTextFormField(
                        controller: messageController,
                        labelText: "Message Details",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        minLines: 3,
                        maxLines: 3,
                        enabled: true,
                        prefixIcon: const Icon(Icons.message_outlined),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter message'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      // Submit Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () async {
                            LoadingDialogHelper.showLoadingDialog(context);
                            if (_formKey.currentState?.validate() ?? false) {
                              var createContactRes = await AuthServices()
                                  .createContactSupport(
                                      context,
                                      uuid.v1(),
                                      'CON',
                                      subjectController.text,
                                      messageController.text,
                                      emailController.text,
                                      phoneController.text);
                              if (createContactRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                LoadingDialogHelper.dismissLoadingDialog(
                                    context);
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.bottomSlide,
                                  dialogType: DialogType.success,
                                  dialogBackgroundColor: Colors.white,
                                  title: createContactRes
                                      .apiResponse![0].responseDetails,
                                  titleTextStyle: AppTheme.appBarText,
                                  descTextStyle: AppTheme.appBarText,
                                  btnOkOnPress: () {
                                    subjectController.clear();
                                    messageController.clear();
                                  },
                                  btnOkText: 'OK',
                                  btnOkColor: Colors.greenAccent.shade700,
                                ).show();
                              }
                            }
                          },
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
