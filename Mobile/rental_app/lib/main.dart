import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/review_provider.dart'; 
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/tenant_profile_screen.dart';
import 'screens/owner_profile_screen.dart';
import 'screens/detail_immobile_screen.dart';
import 'screens/owner_dashboard_screen.dart';
import 'screens/search_immobile_screen.dart';
import 'screens/review_screen.dart';
import 'screens/create_profile_screen.dart';
import 'screens/notification_screen.dart';
import '../providers/notification_provider.dart';
import 'screens/review_create_screen.dart';
import 'screens/review_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/review_create_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // Outros providers
      ],
      child: const MyApp(),
    ),
  );
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
        '/owner': (context) => const OwnerProfileScreen(),
        '/verify-email': (context) => const VerifyEmailScreen(),
        '/immobile_details': (context) => const DetailImmobileScreen(immobileId: 1),
        '/owner_dashboard': (context) => const OwnerDashboardScreen(),
        '/search-immobile': (context) => const SearchImmobileScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/create_review': (context) => ChangeNotifierProvider( // Forneça o ReviewProvider aqui
  create: (_) => ReviewProvider(),
  child: Builder(
    builder: (newContext) {
      final args = ModalRoute.of(newContext)?.settings.arguments as Map<String, dynamic>?;
      final reviewType = args?['reviewType'] as String? ?? 'PROPERTY';
      final targetId = args?['targetId'] as int? ?? 3;
      final targetName = args?['targetName'] as String? ?? 'admin'; // Pegue o targetName também
      return CreateReviewScreen(
        reviewType: reviewType,
        targetId: targetId,
        targetName: targetName,
      );
    },
  ),
),
'/review': (context) => ChangeNotifierProvider( // Ou Provider
  create: (_) => ReviewProvider(),
  child: Builder(
    builder: (newContext) {
      final args = ModalRoute.of(newContext)?.settings.arguments as Map<String, dynamic>?;
      final reviewType = args?['reviewType'] as String? ?? 'immobile';
      final targetId = args?['targetId'] as int? ?? 1;
      return ReviewsScreen(
        reviewType: reviewType,
        targetId: targetId,
      );
    },
  )
)
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
