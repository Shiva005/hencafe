import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:hencafe/models/bird_breed_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/navigation_helper.dart';
import '../models/egg_price_model.dart';
import '../models/user_favourite_state_model.dart';
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
  late SharedPreferences prefs;
  late Future<EggPriceModel> eggPriceData;
  Map<String, String> selectedFilters = {};
  late List<String> birdBreedList = [];
  late List<String> favouriteStateList = [];

  @override
  void initState() {
    super.initState();
    getBirdBreedData();
    getFavouriteStateData();
    eggPriceData = _fetchData();
  }

  Future<EggPriceModel> _fetchData() async {
    prefs = await SharedPreferences.getInstance();
    final getEggListRes = await AuthServices()
        .getEggPriceList(context, '', '2024-12-14', '2024-12-19', '');
    return getEggListRes;
  }

  Future<BirdBreedModel> getBirdBreedData() async {
    var getBirdBreedRes = await AuthServices().getBirdList(context);
    if (getBirdBreedRes.errorCount == 0 &&
        getBirdBreedRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < getBirdBreedRes.apiResponse!.length; i++) {
          birdBreedList
              .add(getBirdBreedRes.apiResponse![i].birdbreedNameLanguage!);
        }
      });
    }
    return getBirdBreedRes;
  }

  Future<UserFavouriteStateModel> getFavouriteStateData() async {
    var getFaveStateRes = await AuthServices().getFavouriteStateList(context);
    if (getFaveStateRes.errorCount == 0 &&
        getFaveStateRes.apiResponse != null) {
      setState(() {
        for (int i = 0; i < getFaveStateRes.apiResponse!.length; i++) {
          favouriteStateList
              .add(getFaveStateRes.apiResponse![i].stateNameLanguage!);
        }
      });
    }
    return getFaveStateRes;
  }

  List<String> _getFilterItems(String filter) {
    return {
          "Sale Type": ["All", "General Sale", "Special Sale"],
          "Status": ["All", "Active", "In-active", "Pending"],
          "State": favouriteStateList,
          "Birds": birdBreedList,
          "Hatching Eggs": ["All", "Yes", "No"],
          "My Data": ["All", "My Data"],
        }[filter] ??
        [];
  }

  void _showBottomSheet(BuildContext context, String filter) {
    List<String> items = _getFilterItems(filter);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Filter for $filter",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  items.isEmpty
                      ? const Text("No items available for this filter.",
                          textAlign: TextAlign.center)
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(items[index]),
                            trailing: Radio<String>(
                              value: items[index],
                              groupValue: selectedFilters[filter],
                              onChanged: (value) {
                                setModalState(() {
                                  selectedFilters[filter] = value!;
                                });
                                setState(() {
                                  selectedFilters[filter] = value!;
                                  if (selectedFilters["Sale Type"] == "All") {}
                                  _fetchData();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                              height: 2.0,
                              color: Colors.grey.shade300),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close")),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 1.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: NavigationHelper.pop),
          title: Text('Egg Price', style: AppTheme.primaryHeadingDrawer),
          actions: [
            IconButton(
                onPressed: () =>
                    setState(() => cardVisibility = !cardVisibility),
                icon: const Icon(Icons.filter_list_alt, color: Colors.white)),
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh, color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Visibility(
            visible: cardVisibility,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Wrap(
                      spacing: 7.0,
                      children: [
                        for (var filter in [
                          "Sale Type",
                          "Status",
                          "State",
                          "Birds",
                          "Hatching Eggs"
                        ])
                          FilterChipWidget(
                            label: filter,
                            onPressed: () => _showBottomSheet(context, filter),
                            isSelected: selectedFilters.containsKey(filter),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<EggPriceModel>(
              future: eggPriceData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No data available"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.apiResponse!.length,
                  itemBuilder: (context, index) => EggPriceCard(
                    eggPriceModel: snapshot.data!,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EggPriceCard extends StatelessWidget {
  final EggPriceModel eggPriceModel;
  final int index;

  const EggPriceCard(
      {required this.eggPriceModel, super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryColor, width: 1),
        // Change color here
        borderRadius:
            BorderRadius.circular(8.0), // Optional: Adjust border radius
      ),
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
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black38, width: 1),
                      // Change color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Adjust border radius
                    ),
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
                            eggPriceModel.apiResponse![index].eggpriceCost ??
                                '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
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
                          Text(eggPriceModel.apiResponse![index].locationInfo
                                  ?.stateNameDisplay ??
                              ''),
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
                          Text(eggPriceModel.apiResponse![index].birdbreedInfo
                                  ?.birdbreedName ??
                              ''),
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
                          Text(eggPriceModel.apiResponse![index].companyInfo![0].companyNameLanguage!),
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
                        color: AppColors.primaryColor,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Icon(Icons.card_giftcard,
                        color: AppColors.primaryColor, size: 20.0),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${eggPriceModel.apiResponse![index].userInfo?.userLastName} ${eggPriceModel.apiResponse![index].userInfo?.userFirstName}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text(
                    eggPriceModel.apiResponse![index]
                            .eggpricePriceEffectFromdateDisplay ??
                        '',
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
  final bool isSelected;

  const FilterChipWidget(
      {required this.label,
      required this.onPressed,
      required this.isSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Chip(
        label: Text(label,
            style: TextStyle(
                color: isSelected ? AppColors.primaryColor : Colors.black54,
                fontSize: 11)),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
              width: 1.5),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
