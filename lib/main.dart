import 'package:dashboard/Controllers/dashboard_controllers.dart';
import 'package:dashboard/Views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future <void> main() async {
  Get.put(DashboardController());
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin DashBoard',
     theme: ThemeData(useMaterial3: true),
     home: Dashboard(),
    );
  }
}