import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    const coffee = Color(0xFF6F4E37);
    return MaterialApp(
      title: 'Coffee Shop Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: coffee),
        scaffoldBackgroundColor: const Color(0xFFF8F6F2),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
