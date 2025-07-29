import 'package:flutter/material.dart';
import 'package:hencafe/values/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/profile_model.dart';
import '../../services/services.dart';
import '../../values/app_colors.dart';
import '../image_preview_screen.dart';

class SellerListFragment extends StatefulWidget {
  const SellerListFragment({super.key});

  @override
  State<SellerListFragment> createState() => _SellerListFragmentState();
}

class _SellerListFragmentState extends State<SellerListFragment> {
  late SharedPreferences prefs;
  late Future<ProfileModel?> profileListData;

  @override
  void initState() {
    super.initState();
    profileListData = _fetchData();
  }

  Future<ProfileModel?> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getUsers(context, 'true');
  }

  Color _getRandomColor(String key) {
    final colors = [
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.brown,
    ];
    // Pick based on hash to keep color consistent per item
    int index = key.hashCode % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: RefreshIndicator(
        onRefresh: () {
          return _fetchData();
        },
        child: FutureBuilder<ProfileModel?>(
          future: profileListData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final profiles = snapshot.data?.apiResponse ?? [];
            return profiles.isNotEmpty
                ? ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 0.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppColors.primaryColor, width: 1),
                            // Change color here
                            borderRadius: BorderRadius.circular(
                                8.0), // Optional: Adjust border radius
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (profile.attachmentInfo![0]
                                        .attachmentPath!.isNotEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ImagePreviewScreen(
                                                imageUrl: profile
                                                    .attachmentInfo![0]
                                                    .attachmentPath!),
                                          ));
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: profile.attachmentInfo != null &&
                                            profile
                                                .attachmentInfo!.isNotEmpty
                                        ? Image.network(
                                            profile.attachmentInfo![0]
                                                .attachmentPath!,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            AppIconsData
                                                .noImage, // your fallback asset image
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile.userFirstName ?? 'No Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(height: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (profile.supplyInfo != null &&
                                              profile.supplyInfo!.isNotEmpty)
                                            Expanded(
                                              child: Wrap(
                                                spacing: 8.0,
                                                runSpacing: 6.0,
                                                children: profile.supplyInfo!
                                                    .map((e) =>
                                                        e.supplytypeNameLanguage ??
                                                        '')
                                                    .where((name) =>
                                                        name.isNotEmpty)
                                                    .map((name) {
                                                  final bgColor =
                                                      _getRandomColor(name);
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: bgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      name,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_right_alt_outlined,
                                    color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: Text("No companies available"));
          },
        ),
      ),
    );
  }
}
