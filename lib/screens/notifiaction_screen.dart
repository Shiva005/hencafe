import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/contact_history_model.dart';

import '../services/services.dart';
import '../utils/appbar_widget.dart';
import '../utils/utils.dart';
import '../values/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        await AuthServices().getContactHistory(context, "NOT", "");
    setState(() {
      complaintList = contactData.apiResponse ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const MyAppBar(title: 'Notifications'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaintList.isEmpty
              ? const Center(child: Text('No data available'))
              : RefreshIndicator(
                  onRefresh: fetchContactHistory,
                  child: ListView.builder(
                    itemCount: complaintList.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = complaintList[index];
                      final statusCode = item.status?.code ?? "Unknown";

                      return Dismissible(
                        key: Key(item.id ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 40),
                          child: const Icon(Icons.delete_forever,
                              color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          // show() returns Future<void>; wrap in a bool
                          bool? shouldDelete = await AwesomeDialog(
                            context: context,
                            animType: AnimType.bottomSlide,
                            dialogType: DialogType.warning,
                            dialogBackgroundColor: Colors.white,
                            titleTextStyle: AppTheme.appBarText,
                            title:
                                'Are you sure you want to delete this record?',
                            btnCancelOnPress: () {},
                            btnCancelText: 'Cancel',
                            btnOkOnPress: () async {
                              var deleteRecordRes =
                                  await AuthServices().deleteContactRecord(
                                context,
                                item.uuid.toString(),
                              );
                              if (deleteRecordRes
                                      .apiResponse![0].responseStatus ==
                                  true) {
                                setState(() => complaintList.removeAt(index));
                              }
                              SnackbarHelper.showSnackBar(deleteRecordRes
                                  .apiResponse![0].responseDetails);
                            },
                            btnOkText: 'Yes',
                            btnOkColor: Colors.yellow.shade700,
                          ).show();

                          // If dialog closed via back‑tap or outside‑tap, don’t delete
                          return shouldDelete == true;
                        },
                        child: Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.subjectLanguage ?? "No Subject",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.detailsLanguage ?? "No Details",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 15),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Created: ${Utils.threeLetterDateFormatted(item.createdOn.toString()).substring(0, 10)}",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
