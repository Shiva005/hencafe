import 'package:flutter/material.dart';
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

  // Track selected states
  final Set<String> _selectedStates = {};

  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  // Function to check if at least two states are selected
  bool get _isSelectionValid => _selectedStates.length >= 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Select Favourite States',
          style: AppTheme.appBarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline,color: Colors.orange,),
                SizedBox(width: 10),
                Text(
                  "Maximum 5 Favourite States",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20,),
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
                          _selectedStates.add(state);
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
              width: double.infinity,
              controller: _btnController,
              onPressed: () async {
                NavigationHelper.pushNamed(
                  AppRoutes.stateSelection,
                );
                _btnController.reset();
              },
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
