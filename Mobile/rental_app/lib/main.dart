import 'package:flutter/material.dart';
import 'package:rental_app/screens/owner_profile_screen.dart';
import 'screens/owner_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tenant_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_immobile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moovin',
      theme: ThemeData(
        primarySwatch: Colors.green,

        textTheme: GoogleFonts.khulaTextTheme(), 
      ),
      home: const LoginScreen(),
      //home: const OwnerProfileScreen(ownerId: 1),
      //home: const TenantProfileScreen(tenantId: 1),
      // home:SearchImmobileScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tenant': (context) => const TenantProfileScreen(tenantId: 1),
        '/owner' : (context) => const OwnerProfileScreen(ownerId: 1),
        '/search-immobile': (context) => SearchImmobileScreen(),
      },
    );
  }
}

//nao apague os comentarios que chamam funcoes nem importacoes desnecessarios, elas serviram para testes.