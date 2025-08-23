import 'package:flutter/material.dart';
import 'package:hencafe/models/user_fav_state_info.dart';
import 'package:hencafe/utils/utils.dart';
import 'package:hencafe/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';

class FavouriteStateWidget extends StatefulWidget {
  final List<UserFavouriteStateInfo> favStateList;
  final String userID;

  const FavouriteStateWidget({
    super.key,
    required this.favStateList,
    required this.userID,
  });

  @override
  State<FavouriteStateWidget> createState() => _FavouriteStateWidgetState();
}

class _FavouriteStateWidgetState extends State<FavouriteStateWidget> {
  var prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return const CircularProgressIndicator(); // loading state
    }
    if (widget.favStateList.isEmpty) return const SizedBox();
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
                children: widget.favStateList
                    .map((e) => e.stateInfo![0].stateNameLanguage ?? '')
                    .where((name) => name.isNotEmpty) // filter null/empty names
                    .map((name) {
                      final color = Utils.getRandomColor(name);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
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
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),

            if (prefs!.getString(AppStrings.prefUserID) == widget.userID)
              ElevatedButton(
                onPressed: () {
                  NavigationHelper.pushNamed(AppRoutes.stateSelection)?.then((
                    result,
                  ) {
                    NavigationHelper.pushReplacementNamed(
                      AppRoutes.myProfileScreen,
                      arguments: {
                        'pageType': AppRoutes.dashboardScreen,
                        'userID': prefs.getString(AppStrings.prefUserID),
                      },
                    );
                  });
                },
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
          ],
        ),
      ),
    );
  }
}
