import 'package:flutter/material.dart';
import 'package:hencafe/helpers/snackbar_helper.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../helpers/navigation_helper.dart';
import '../values/app_colors.dart';
import '../values/app_routes.dart';
import '../values/app_strings.dart';
import '../values/app_theme.dart';

class StateSelectionPage extends StatefulWidget {
  const StateSelectionPage({super.key});

  @override
  State<StateSelectionPage> createState() => _StateSelectionPageState();
}

class _StateSelectionPageState extends State<StateSelectionPage> {
  // List of states
  final List<String> states = [
    "California",
    "Texas",
    "New York",
    "Florida",
    "Illinois",
    "Ohio",
    "Georgia",
    "North Carolina",
    "California",
    "Texas",
    "New York",
    "Florida",
    "Illinois",
    "Ohio",
    "Georgia",
    "North Carolina"
  ];

  final Set<String> _selectedStates = {};

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Select Favourite States',
          style: AppTheme.appBarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text(
                  "Maximum 5 Favourite States",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: states.length,
                itemBuilder: (context, index) {
                  final state = states[index];
                  return CheckboxListTile(
                    title: Text(state),
                    value: _selectedStates.contains(state),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          if (_selectedStates.length < 5) {
                            _selectedStates.add(state);
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Favourite States"),
                                content: Text(
                                  'Only 5 selection allowed',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          _selectedStates.remove(state);
                        }
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 1, // Reduce height to make the divider more compact
                  ),
                ),
              ),
            ),
            RoundedLoadingButton(
              width: double.maxFinite,
              controller: _btnController,
              onPressed: _selectedStates.isNotEmpty
                  ? () async {
                      /*NavigationHelper.pushNamed(
                  AppRoutes.stateSelection,
                );*/
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Selected States"),
                          content: Text(
                            _selectedStates.join(", "),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                      _btnController.reset();
                    }
                  : null,
              color: Colors.orange.shade400,
              child: Text(
                AppStrings.finish,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
