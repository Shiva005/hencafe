import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hencafe/values/app_routes.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../helpers/navigation_helper.dart';
import '../helpers/snackbar_helper.dart';
import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../utils/loading_dialog_helper.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_icons.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final List<String> reasons = [
    'No longer using the service/platform',
    'Found a better alternative',
    'Privacy concerns',
    'Difficulty navigating the platform',
    'Account security concerns',
    'Personal reasons',
    'Others'
  ];

  String? selectedReason;
  final TextEditingController otherReasonController = TextEditingController();

  Widget _buildReasonTile(String reason) {
    return Column(
      children: [
        RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity(vertical: -3),
          title: Text(reason),
          value: reason,
          groupValue: selectedReason,
          onChanged: (value) {
            setState(() {
              selectedReason = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: MyAppBar(title: 'Delete Account'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                'Please, Provide a reason for account deletion.',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: reasons.length,
                  itemBuilder: (_, index) => _buildReasonTile(reasons[index]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: AppTextFormField(
                  controller: otherReasonController,
                  enabled: true,
                  maxLines: 4,
                  minLines: 4,
                  labelText: 'Type reason here...',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (selectedReason != null &&
                          otherReasonController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppPasswordScreen(
                                    reason: selectedReason!,
                                    comment: otherReasonController.text,
                                  )),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please select a reason & Type message')),
                        );
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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

class AppPasswordScreen extends StatefulWidget {
  final String reason;
  final String comment;

  const AppPasswordScreen(
      {super.key, required this.reason, required this.comment});

  @override
  State<AppPasswordScreen> createState() => _AppPasswordScreenState();
}

class _AppPasswordScreenState extends State<AppPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _isResendEnabled = false;
  late Timer _timer;
  int _start = 60; // Timer for Resend Button
  late SharedPreferences prefs;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _resendOTP();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isResendEnabled = false;
      _start = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          _isResendEnabled = true;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  Future<bool> _resendOTP() async {
    prefs = await SharedPreferences.getInstance();
    _startTimer();
    var generateOtpRes = await AuthServices()
        .otpGenerate(context, prefs.getString(AppStrings.prefMobileNumber)!);
    if (generateOtpRes.errorCount == 0) {
      SnackbarHelper.showSnackBar(
          generateOtpRes.apiResponse![0].responseDetails!);
      return true;
    }
    return false;
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.help_outline, size: 60, color: Colors.amber),
            const SizedBox(height: 10),
            const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'You want to delete your account permanently.\n\nEnsuring that the user understands the consequences of deleting their account (loss of data etc.)',
              style: TextStyle(fontSize: 13, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () async {
              LoadingDialogHelper.showLoadingDialog(context);
              var deleteProfileRes = await AuthServices().deleteProfile(
                  context,
                  prefs.getString(AppStrings.prefUserID)!,
                  prefs.getString(AppStrings.prefMobileNumber)!,
                  widget.reason,
                  widget.comment,
                  passwordController.text,
                  otpController.text);
              if (deleteProfileRes.apiResponse![0].responseStatus == true) {
                prefs.clear();
                NavigationHelper.pushReplacementNamedUntil(
                  AppRoutes.loginMobile,
                );
              }
              SnackbarHelper.showSnackBar(
                  deleteProfileRes.apiResponse![0].responseDetails!);
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Keep Account',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar(title: 'Confirm Deletion'),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: const Text(
                'Please, Enter the login pin and OTP to delete the account.',
                style: TextStyle(fontSize: 13, color: Colors.red),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueGrey.shade100),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Password',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    AppTextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: passwordController,
                        labelText: "",
                        obscureText: true,
                        enabled: true,
                        maxLength: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }
                          if (value.length != 4) {
                            return 'Passwords must be exact 4 character';
                          }
                          return null;
                        }),
                    const Text(
                      'Enter OTP',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    AppTextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: otpController,
                        labelText: "",
                        obscureText: true,
                        enabled: true,
                        maxLength: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter OTP';
                          }
                          if (value.length != 4) {
                            return 'OTP must be exact 4 character';
                          }
                          return null;
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive the OTP ?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: _isResendEnabled
                              ? () async {
                                  await _resendOTP();
                                }
                              : null, // Set to null when button is disabled
                          child: Text(
                            _isResendEnabled ? " RESEND OTP" : "$_start s",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 12),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _showConfirmDialog();
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
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Utils.openLink("https://wa.me/+919885279787/?text=Hello");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        border: Border.all(color: Colors.green.shade700),
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
                            Text('Chat Support',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Utils.openDialPad("+919885279787");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        border: Border.all(color: Colors.blue.shade700),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text('Call Support',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
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
