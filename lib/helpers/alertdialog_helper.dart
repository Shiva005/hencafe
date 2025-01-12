import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class AlertDialogHelper {
  static void openLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: <Widget>[
            const SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                text,
                style: const TextStyle(color: AppColors.lightBlue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
