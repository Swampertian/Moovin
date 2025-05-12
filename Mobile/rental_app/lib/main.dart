import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/tenant_profile_screen.dart';
import 'screens/owner_profile_screen.dart';
import 'screens/detail_immobile_screen.dart';
import 'screens/owner_dashboard_screen.dart';
import 'screens/search_immobile_screen.dart';
import 'screens/review_screen.dart';
import 'screens/create_profile_screen.dart';
import 'screens/create_review_screen.dart';
import 'screens/review_screen.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tenant': (context) => const TenantProfileScreen(),
        '/owner': (context) => const OwnerProfileScreen(ownerId: 1),
        '/immobile_details': (context) => const DetailImmobileScreen(immobileId: 1),
        '/owner_dashboard': (context) => const OwnerDashboardScreen(),
        '/search-immobile': (context) => const SearchImmobileScreen(),
        '/review': (context) => const ReviewsScreen(reviewType:  'PROPERTY', targetId: 1),
        // '/review': (context) => const ReviewScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create-profile') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey('userId')) {
            return _errorRoute();
          }

          return MaterialPageRoute(
            builder: (_) => CreateProfileScreen(
              userId: args['userId'].toString(),
              name: args['name'] ?? '',
              email: args['email'] ?? '',
              isOwner: args['isOwner'] ?? false,
            ),
          );
        }

        return _errorRoute();
      },
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Rota não encontrada')),
      ),
    );
  }
}
    

//nao apague os comentarios que chamam funcoes nem importacoes desnecessarios, elas serviram para testes.
