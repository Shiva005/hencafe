import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SnackbarHelper {
  const SnackbarHelper._();

  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static void showSnackBar(String? message, {bool isError = false}) =>
      _key.currentState
        ?..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
            content: Text(message ?? ''),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );

  static void openWhatsApp(String message) async {
    final String url =
        'https://wa.me/919885279787?text=${Uri.encodeFull(message)}';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // Opens in WhatsApp
    } else {
      throw 'Could not launch $url';
    }
  }
}
