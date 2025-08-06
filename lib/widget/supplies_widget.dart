import 'package:flutter/material.dart';
import 'package:hencafe/models/company_providers_model.dart';
import 'package:hencafe/utils/utils.dart'; // Assuming Utils.getRandomColor exists
import 'package:hencafe/values/app_colors.dart';

class SuppliesWidget extends StatelessWidget {
  final List<SupplyInfo> supplyList;

  const SuppliesWidget({
    super.key,
    required this.supplyList,
  });

  @override
  Widget build(BuildContext context) {
    if (supplyList.isEmpty) return const SizedBox();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company Supplies',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: supplyList
                    .map((e) => e.supplytypeNameLanguage ?? '')
                    .where((name) => name.isNotEmpty)
                    .map((name) {
                  final color = Utils.getRandomColor(name);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Update"),
                  SizedBox(width: 8),
                  Icon(Icons.double_arrow_rounded, color: Colors.white),
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
                  borderRadius: BorderRadius.circular(8),
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
        ),
      ),
    );
  }
}
