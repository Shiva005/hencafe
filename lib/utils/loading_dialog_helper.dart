import 'package:flutter/material.dart';
import 'package:hencafe/values/app_colors.dart';

class LoadingDialogHelper {
  const LoadingDialogHelper._();

  static void showLoadingDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
