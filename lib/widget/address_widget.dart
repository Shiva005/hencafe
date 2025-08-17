import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_details_model.dart';
import '../models/attachment_model.dart';
import '../services/services.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';
import 'attachment_widget.dart';

class AddressWidget extends StatelessWidget {
  final List<AddressDetails> addressList;

  const AddressWidget({super.key, required this.addressList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        return AddressWidgetData(address: addressList[index]);
      },
    );
  }
}

class AddressWidgetData extends StatefulWidget {
  final AddressDetails address;

  const AddressWidgetData({super.key, required this.address});

  @override
  State<AddressWidgetData> createState() => _AddressWidgetDataState();
}

class _AddressWidgetDataState extends State<AddressWidgetData> {
  int selectedTab = 0;
  final PageController _attachmentController = PageController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _fetchPrefs();
  }

  Future<void> _fetchPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: Card(
        color: Colors.white,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTabButtons(),
            const SizedBox(height: 10),
            selectedTab == 0
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildAddressCard(widget.address),
                  )
                : _buildAttachmentsSection(widget.address),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabButton("Address", 0),
        const SizedBox(width: 12),
        _tabButton("Attachments", 1),
      ],
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: () => setState(() => selectedTab = index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.indigo : Colors.grey.shade300,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildAddressCard(AddressDetails address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRow(Icons.location_on, "Address Type", address.addressType ?? "-"),
        const SizedBox(height: 8),
        buildRow(Icons.home, "Address", address.addressAddress ?? "-"),
        const SizedBox(height: 8),
        buildRow(Icons.location_city, "City",
            address.locationInfo?.first.cityNameLanguage ?? "-"),
        const SizedBox(height: 8),
        buildRow(Icons.map, "State",
            address.locationInfo?.first.stateNameLanguage ?? "-"),
        const SizedBox(height: 8),
        buildRow(Icons.pin_drop, "Pincode", address.addressZipcode ?? "-"),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Edit Address"),
              SizedBox(width: 8),
              Icon(Icons.arrow_right_alt, color: Colors.white),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.delete_forever, color: Colors.white),
              SizedBox(width: 8),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(AddressDetails address) {
    final attachments = address.attachmentInfo;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: PageView.builder(
            controller: _attachmentController,
            itemCount: attachments!.length,
            itemBuilder: (context, index) {
              return AttachmentWidget(
                attachments: address.attachmentInfo ?? [],
                userId: address.userBasicInfo![0].userId ?? '',
                currentUserId: prefs.getString(AppStrings.prefUserID) ?? '',
                onDelete: (index) {
                  showDeleteAttachmentDialog(
                    context: context,
                    index: index,
                    attachment: attachments[index],
                    attachments: attachments,
                    onUpdate: () => setState(() {}),
                  );
                },
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }

  void showDeleteAttachmentDialog({
    required BuildContext context,
    required int index,
    required AttachmentInfo attachment,
    required List<AttachmentInfo> attachments,
    required VoidCallback onUpdate,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.warning,
      dialogBackgroundColor: Colors.white,
      titleTextStyle: AppTheme.appBarText,
      title: 'Are you sure you want to delete this file?',
      btnCancelOnPress: () {},
      btnCancelText: 'Cancel',
      btnOkOnPress: () async {
        var attachmentDeleteRes = await AuthServices().attachmentDelete(
          context,
          attachment.attachmentId!,
          attachment.attachmentPath!,
        );

        if (attachmentDeleteRes.apiResponse![0].responseStatus == true) {
          attachments.removeAt(index);
          onUpdate();
        }
      },
      btnOkText: 'Yes',
      btnOkColor: Colors.yellow.shade700,
    ).show();
  }
}

Widget buildRow(IconData icon, String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(
            "$label:",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    ],
  );
}
