import 'package:flutter/material.dart';
import 'package:hencafe/models/user_fav_state_info.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:hencafe/values/app_colors.dart';

class FavouriteStateWidget extends StatelessWidget {
  final List<UserFavouriteStateInfo> favStateList;

  const FavouriteStateWidget({
    super.key,
    required this.favStateList,
  });

  @override
  Widget build(BuildContext context) {
    if (favStateList.isEmpty) return const SizedBox();
    logger.w(favStateList);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
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
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: favStateList
                    .map((e) => e.stateInfo![0].stateNameLanguage ?? '')
                    .where((name) => name.isNotEmpty) // filter null/empty names
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
                  Text("Edit Favourite State"),
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
        ),
      ),
    );
  }
}
