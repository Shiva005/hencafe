import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_text_form_field.dart';
import '../utils/utils.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar(
        title: 'Contact Us',
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primaryColor,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Create Request'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ContactForm(),
                  ),
                  const Center(child: Text('History Page')),
                ],
              ),
            ),
          ],
        ),
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  late SharedPreferences prefs;
  String? email, phone;

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

    return Column(
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
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 1, width: 50, color: AppColors.primaryColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'OR',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
              Container(height: 1, width: 50, color: AppColors.primaryColor),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter email' : null,
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
                  controller: nameController,
                  labelText: "Subject",
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  enabled: true,
                  prefixIcon: const Icon(Icons.my_library_books_outlined),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter name' : null,
                ),

                AppTextFormField(
                  controller: messageController,
                  labelText: "Message Details",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  minLines: 2,
                  maxLines: 2,
                  enabled: true,
                  prefixIcon: const Icon(Icons.message_outlined),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter message' : null,
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
                    onPressed: () {},
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
