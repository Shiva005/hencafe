import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/egg_price_model.dart';
import '../services/services.dart';
import '../values/app_colors.dart';
import '../values/app_icons.dart';
import '../values/app_theme.dart';

class EggPriceScreen extends StatefulWidget {
  const EggPriceScreen({super.key});

  @override
  State<EggPriceScreen> createState() => _EggPriceScreenState();
}

class _EggPriceScreenState extends State<EggPriceScreen> {
  bool cardVisibility = false;
  var prefs;
  late Future<List<ApiResponse>> eggPriceData;

  @override
  void initState() {
    super.initState();
    eggPriceData = _fetchData();
  }

  Future<List<ApiResponse>> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    final getEggListRes = await AuthServices()
        .getEggPriceList(context, '', '2024-12-14', '2024-12-19', 'G');

    if (getEggListRes.errorCount == 0 && getEggListRes.apiResponse != null) {
      return getEggListRes.apiResponse!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              NavigationHelper.pop();
            },
          ),
          title: Text(
            'Egg Price',
            style: AppTheme.primaryHeadingDrawer,
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  cardVisibility = !cardVisibility;
                });
              },
              icon: Icon(
                Icons.filter_list_alt,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Buttons Section
          Visibility(
            visible: cardVisibility,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: [
                        FilterChipWidget(
                          label: "Sale Type",
                          onPressed: () =>
                              _showBottomSheet(context, "Special Sale"),
                        ),
                        FilterChipWidget(
                          label: "Status",
                          onPressed: () => _showBottomSheet(context, "Status"),
                        ),
                        FilterChipWidget(
                          label: "State",
                          onPressed: () => _showBottomSheet(context, "State"),
                        ),
                        FilterChipWidget(
                          label: "Birds",
                          onPressed: () => _showBottomSheet(context, "Birds"),
                        ),
                        FilterChipWidget(
                          label: "Hatching Eggs",
                          onPressed: () =>
                              _showBottomSheet(context, "Hatching Eggs"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Egg Price List using FutureBuilder
          Expanded(
            child: FutureBuilder<List<ApiResponse>>(
              future: eggPriceData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No data available"));
                } else {
                  // List of data
                  final eggList = snapshot.data!;
                  return ListView.builder(
                    itemCount: eggList.length,
                    itemBuilder: (context, index) {
                      ApiResponse response = eggList[index];
                      return EggPriceCard(response: response);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to show a bottom sheet
  void _showBottomSheet(BuildContext context, String filter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Bottom Sheet for $filter",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "You can add additional actions or content for $filter here.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 20,
                        itemBuilder: (context, index) => ListTile(
                          title: Text("Item $index"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EggPriceCard extends StatelessWidget {
  final ApiResponse response;

  const EggPriceCard({required this.response, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Rs/egg',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            response.eggpriceCost ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 3),
                          Text(response.locationInfo?.stateNameDisplay ?? ''),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Image.asset(
                              AppIconsData.hen,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(response.birdbreedInfo?.birdbreedName ?? ''),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.business,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 3),
                          Text(response.companyInfo?.companyNameDisplay ?? ''),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Image.asset(
                        AppIconsData.chick,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Icon(Icons.card_giftcard,
                        color: Colors.orange, size: 20.0),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${response.userInfo?.userLastName} ${response.userInfo?.userFirstName}',
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text(response.eggpricePriceEffectFromdateDisplay ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FilterChipWidget({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: false,
      onSelected: (_) => onPressed(),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.orange.shade700, width: 1),
      ),
    );
  }
}
