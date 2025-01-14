import 'package:flutter/material.dart';

import '../values/app_icons.dart';
import '../values/app_theme.dart';

class EggPriceScreen extends StatefulWidget {
  const EggPriceScreen({super.key});

  @override
  State<EggPriceScreen> createState() => _EggPriceScreenState();
}

class _EggPriceScreenState extends State<EggPriceScreen> {
  bool cardVisibility = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Egg Price',
          style: AppTheme.appBarText,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (cardVisibility) {
                  cardVisibility = false;
                } else {
                  cardVisibility = true;
                }
              });
            },
            icon: Icon(
              Icons.filter_list_alt,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
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
          // Egg Price List
          Expanded(
            child: ListView.builder(
              itemCount: 8, // Adjust the count as per your requirement
              itemBuilder: (context, index) {
                return const EggPriceCard();
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
      isScrollControlled: true, // Allows the height to expand dynamically
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.8, // 90% of screen height
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
                      // Add dynamic content here
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 20, // Example content
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
    return GestureDetector(
      onTap: onPressed,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: Colors.black54,fontSize: 11),
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0), // Adjust radius for curve
        ),
      ),
    );
  }
}

class EggPriceCard extends StatelessWidget {
  const EggPriceCard({super.key});

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
                // Price Section
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Rs/egg',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Column(
                            children: [
                              Text(
                                '6.60',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Details Section
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
                          const Text('Nellore'),
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
                          const Text('Layer'),
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
                          const Text('Sri Venkateswara Hatcheries'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icons Section
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
                Text('Suresh Ch',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                const Text('10-Dec-2024 Monday',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
