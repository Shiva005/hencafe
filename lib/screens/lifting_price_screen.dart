import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hencafe/models/lifting_price_model.dart';
import 'package:hencafe/utils/my_logger.dart';
import 'package:hencafe/values/app_strings.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

import '../helpers/navigation_helper.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../values/app_colors.dart';
import '../values/app_icons.dart';
import '../values/app_routes.dart';
import '../values/app_theme.dart';

class LiftingPriceScreen extends StatefulWidget {
  const LiftingPriceScreen({super.key});

  @override
  State<LiftingPriceScreen> createState() => _LiftingPriceScreenState();
}

class _LiftingPriceScreenState extends State<LiftingPriceScreen> {
  bool cardVisibility = false;
  late SharedPreferences prefs;
  late Future<LiftingPriceModel> liftingPriceData;
  Map<String, String> selectedFilters = {};
  List<String> birdBreedList = [];
  List<String> favouriteStateList = [];
  DateTime selectedDate = DateTime.now();
  String _packageName = '';
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> captureAndShare() async {
    try {
      Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/screenshot.png';
        File imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        await Share.shareXFiles([
          XFile(imagePath),
        ], text: '${AppStrings.shareText}$_packageName}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture screenshot')),
        );
      }
    } catch (e) {
      print("Error capturing or sharing: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    getBirdBreedData();
    getFavouriteStateData();
    liftingPriceData = _fetchData(Utils.formatDate(selectedDate));
  }

  Future<LiftingPriceModel> _fetchData(String selectedDate) async {
    prefs = await SharedPreferences.getInstance();
    return await AuthServices().getLiftingPriceList(
      context,
      '',
      selectedDate,
      selectedDate,
      '',
    );
  }

  Future<void> getBirdBreedData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _packageName = packageInfo.packageName;
    final res = await AuthServices().getBirdList(context);
    if (res.errorCount == 0 && res.apiResponse != null) {
      setState(() {
        birdBreedList = res.apiResponse!
            .map((e) => e.birdbreedNameLanguage ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      });
    }
  }

  Future<void> getFavouriteStateData() async {
    prefs = await SharedPreferences.getInstance();
    final res = await AuthServices().getFavouriteStateList(
      context,
      prefs.getString(AppStrings.prefUserID)!,
    );
    if (res.errorCount == 0 && res.apiResponse != null) {
      setState(() {
        favouriteStateList = res.apiResponse!
            .map((e) => e.stateInfo?.first.stateNameLanguage ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      });
    }
  }

  List<String> _getFilterItems(String filter) {
    final filterMap = {
      "State": favouriteStateList,
      "Bird Type": birdBreedList,
      "My Data Only": ["All", "My Data Only"],
    };
    return filterMap[filter] ?? [];
  }

  void _showBottomSheet(BuildContext context, String filter) {
    final items = _getFilterItems(filter);
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
                  Text(
                    filter,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (items.isEmpty)
                    const Text(
                      "No items available for this filter.",
                      textAlign: TextAlign.center,
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(items[index]),
                        trailing: Radio<String>(
                          value: items[index],
                          groupValue: selectedFilters[filter],
                          onChanged: (value) {
                            setModalState(() {});
                            setState(() {
                              selectedFilters[filter] = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        height: 2.0,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> applyLocalFilters(
    List<Map<String, dynamic>> allItems,
    Map<String, String> selectedFilters,
  ) {
    final filterMapping = {
      "Bird Type": {
        "key": "bird_breed_info.0.birdbreed_name_language",
        "transform": (String value) => value.toLowerCase(),
      },
      "State": {
        "key": "address_details.0.state_name_language",
        "transform": (String value) => value.toLowerCase(),
      },
      "My Data Only": {
        "key": "user_basic_info.0.user_id",
        "transform": (String value) {
          final trimmed = value.trim().toLowerCase();
          if (trimmed == "my data only") {
            final uid = prefs.getString(AppStrings.prefUserID);
            return uid ?? "n";
          }
          return "n";
        },
      },
    };

    return allItems.where((item) {
      for (final filterLabel in selectedFilters.keys) {
        final filterValue = selectedFilters[filterLabel]?.toLowerCase() ?? '';
        if (filterValue.isEmpty || filterValue == 'all') continue;

        final mapping = filterMapping[filterLabel];
        if (mapping == null) continue;

        final key = mapping['key'] as String;
        final transform = mapping['transform'] as String Function(String);

        final itemValueRaw = getNestedValue(
          item,
          key,
        ); // 'key' from the filter map
        final itemValue = itemValueRaw?.toString().toLowerCase() ?? '';
        final transformedValue = transform(filterValue.toLowerCase());
        if (itemValue != transformedValue) return false;
      }
      return true;
    }).toList();
  }

  dynamic getNestedValue(dynamic data, String keyPath) {
    final keys = keyPath.split('.');
    dynamic value = data;
    for (final key in keys) {
      if (value is Map<String, dynamic>) {
        value = value[key];
      } else if (value is List) {
        final index = int.tryParse(key);
        if (index != null && index >= 0 && index < value.length) {
          value = value[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
              onPressed: NavigationHelper.pop,
            ),
            title: Text('Lifting Sale', style: AppTheme.appbarTextStyle),
            actions: [
              GestureDetector(
                onTap: () async {
                  if (prefs.getString(AppStrings.prefMembershipType) !=
                      "Trial") {
                    NavigationHelper.pushNamed(
                      AppRoutes.sellLiftingScreen,
                      arguments: {'pageType': AppRoutes.liftingPriceScreen},
                    );
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.bottomSlide,
                      dialogType: DialogType.warning,
                      dialogBackgroundColor: Colors.white,
                      titleTextStyle: AppTheme.appBarText,
                      title:
                          'Your membership (${prefs.getString(AppStrings.prefMembershipType)}) does not have permission to create new sale.\n\nPlease contact HenCafe Team to get this access.',
                      btnOkOnPress: () async {},
                      btnOkText: 'OK',
                      btnOkColor: Colors.yellow.shade700,
                    ).show();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Chip(
                    backgroundColor: Colors.white,
                    label: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Create Lifting sale",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2040),
                      );
                      if (pickedDate != null) {
                        final formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                        setState(() {
                          selectedDate = pickedDate;
                          liftingPriceData = _fetchData(formattedDate);
                        });
                      }
                    },
                    child: Chip(
                      backgroundColor: Colors.white,
                      label: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            Utils.threeLetterDateFormatted(
                              selectedDate.toString(),
                            ),
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => cardVisibility = !cardVisibility),
                    icon: const Icon(
                      Icons.filter_list_alt,
                      color: Colors.black54,
                    ),
                  ),
                  IconButton(
                    onPressed: () => NavigationHelper.pushReplacementNamed(
                      AppRoutes.liftingPriceScreen,
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.black54),
                  ),
                  IconButton(
                    onPressed: captureAndShare,
                    icon: const Icon(Icons.share, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (cardVisibility)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Wrap(
                        spacing: 7.0,
                        children: [
                          for (final filter in [
                            "State",
                            "Bird Type",
                            "My Data Only",
                          ])
                            FilterChipWidget(
                              label: filter,
                              onPressed: () =>
                                  _showBottomSheet(context, filter),
                              isSelected: selectedFilters.containsKey(filter),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder<LiftingPriceModel>(
                future: liftingPriceData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.apiResponse == null) {
                    return const Center(child: Text("No data available"));
                  }

                  final filteredItems = applyLocalFilters(
                    snapshot.data!.apiResponse!.map((e) => e.toJson()).toList(),
                    selectedFilters,
                  );

                  logger.d(selectedFilters);
                  logger.d(filteredItems);

                  return filteredItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final filteredIndex = snapshot.data!.apiResponse!
                                .indexWhere(
                                  (e) =>
                                      e.toJson().toString() ==
                                      filteredItems[index].toString(),
                                );
                            return LiftingSaleCard(
                              liftingPriceModel: snapshot.data!,
                              index: filteredIndex,
                            );
                          },
                        )
                      : const Center(
                          child: Text("No matching data for selected filters"),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiftingSaleCard extends StatelessWidget {
  final LiftingPriceModel liftingPriceModel;
  final int index;

  const LiftingSaleCard({
    required this.liftingPriceModel,
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.pushNamed(
          AppRoutes.saleDetailsScreen,
          arguments: {
            'saleID': liftingPriceModel.apiResponse![index].liftingsaleId,
            'pageType': AppRoutes.liftingPriceScreen,
          },
        );
      },
      child: Card(
        elevation: 0.2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 1),
          // Change color here
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Optional: Adjust border radius
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          8.0,
                        ), // Optional: Adjust border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Rs/Kg',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              liftingPriceModel
                                      .apiResponse![index]
                                      .liftingsaleCostPerKg ??
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
                            Expanded(
                              child: TextScroll(
                                "${liftingPriceModel.apiResponse![index].addressDetails![0].cityNameLanguage!}, ${liftingPriceModel.apiResponse![index].addressDetails![0].stateNameLanguage!}",
                                intervalSpaces: 10,
                                velocity: const Velocity(
                                  pixelsPerSecond: Offset(30, 0),
                                ),
                                fadedBorder: true,
                                fadeBorderVisibility: FadeBorderVisibility.auto,
                                fadeBorderSide: FadeBorderSide.both,
                              ),
                            ),
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
                            Text(
                              liftingPriceModel
                                      .apiResponse![index]
                                      .birdBreedInfo![0]
                                      .birdbreedNameLanguage ??
                                  '',
                            ),
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
                            Text(
                              '${liftingPriceModel.apiResponse![index].liftingsaleTotalBirds} Bird for sale',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${liftingPriceModel.apiResponse![index].birdAgeInDays!} Days',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    height: 15,
                                    AppIconsData.weighingMachine,
                                    color: Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${liftingPriceModel.apiResponse![index].birdWeightInKg!} Kg/Bird',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date: ${Utils.threeLetterDateFormatted(liftingPriceModel.apiResponse![index].liftingsaleEffectFrom.toString())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                      Text(
                        'End Date: ${Utils.threeLetterDateFormatted(liftingPriceModel.apiResponse![index].liftingsaleEffectTo.toString())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${liftingPriceModel.apiResponse![index].userBasicInfo![0].userLastName} ${liftingPriceModel.apiResponse![index].userBasicInfo![0].userFirstName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const FilterChipWidget({
    required this.label,
    required this.onPressed,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Chip(
        backgroundColor: Colors.white,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryColor : Colors.black54,
            fontSize: 11,
          ),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
