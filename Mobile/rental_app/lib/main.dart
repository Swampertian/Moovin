import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tenant_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

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
        textTheme: GoogleFonts.khulaTextTheme(), 
      ),
      home: const LoginScreen(),
      //home: const TenantProfileScreen(tenantId: 2),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}