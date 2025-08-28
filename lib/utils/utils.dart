import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String getTodayDateFormatted() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String threeLetterDateFormatted(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      return formatter.format(parsedDate);
    } catch (_) {
      return formatDate(DateTime.now());
    }
  }

  static openDialPad(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not open dial pad';
    }
  }

  static void openLink(String urlLink) async {
    final Uri url = Uri.parse(urlLink);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  static void openExternalApp(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static int calculateAge(String dob) {
    DateTime birthDate = DateTime.parse(dob); // parse "1998-05-12"
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static int calculateTotalDays(String endDate) {
    DateTime fromDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    DateTime toDate = DateTime.parse(endDate);

    int totalDays = toDate.difference(fromDate).inDays;
    return totalDays;
  }

  static Color getRandomColor(String key) {
    final colors = [
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.brown,
    ];
    int index = key.hashCode % colors.length;
    return colors[index];
  }

  static String getUserRoleName(String? userRoleType) {
    switch (userRoleType) {
      case 'U':
        return "User";
      case 'A':
        return "Admin";
      case 'SA':
      case 'S':
        return "Super Admin";
      default:
        return "Unknown";
    }
  }

  static String getVerifiedEnum(String? isVerified) {
    switch (isVerified) {
      case 'Y':
        return "Yes";
      case 'N':
        return "No";
      default:
        return "No";
    }
  }
}
