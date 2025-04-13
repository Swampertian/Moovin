import 'package:flutter/material.dart';
import 'screens/tenant_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const TenantProfileScreen(tenantId: 1),
    );
  }
}