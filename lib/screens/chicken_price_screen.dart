import 'package:flutter/material.dart';
import 'package:hencafe/values/app_colors.dart';

import '../values/app_icons.dart';
import '../values/app_theme.dart';

class ChickenPriceScreen extends StatefulWidget {
  const ChickenPriceScreen({super.key});

  @override
  State<ChickenPriceScreen> createState() => _ChickenPriceScreenState();
}

class _ChickenPriceScreenState extends State<ChickenPriceScreen> {
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
          'Chicken Price',
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
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.black54, fontSize: 11),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            )
          ],
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
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
        padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 10.0,bottom: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price Section
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Farm Live',
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
                ),
                // Details Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.0,),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
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
                          const SizedBox(width: 5),
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
                          const SizedBox(width: 5),
                          const Text('Sri Venkateswara Hatcheries'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icons Section
                const Icon(Icons.card_giftcard,
                    color: Colors.orange, size: 20.0),
              ],
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: false,
                    child: Expanded(
                      child: Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Farm Live',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '1',
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
                  ),
                  Visibility(
                    visible: false,
                    child: Expanded(
                      child: Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Retail Live',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '55',
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
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'With Skin',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Column(
                              children: [
                                Text(
                                  '12',
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
                  Expanded(
                    child: Card(
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Skinless',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Column(
                              children: [
                                Text(
                                  '623',
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Suresh Ch',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey)),
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
