import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mnursing_payouts/staff_payouts_screen.dart';

void main() {
  HttpOverrides.global= MyHttpOverrides();
  runApp(const StaffPayoutsScreen());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
} 