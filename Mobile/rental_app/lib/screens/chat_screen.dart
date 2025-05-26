import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Se for usar Providers futuramente
import '../providers/notification_provider.dart'; // Para a nav bar
import 'notification_screen.dart'; // Para a nav bar
import 'search_immobile_screen.dart'; // Para a nav bar
import 'tenant_profile_screen.dart'; // Para a nav bar

class ChatScreen extends StatefulWidget { // Pode ser StatelessWidget se não precisar de estado
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Se precisar de alguma inicialização, coloque aqui
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        backgroundColor: Colors.green,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction, // Ícone de construção ou similar
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                'Ops! A tela de conversas ainda não está disponível.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Estamos trabalhando duro para trazer essa funcionalidade em breve. Volte mais tarde!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              // Você pode adicionar um botão aqui, se quiser
              // ElevatedButton.icon(
              //   onPressed: () {
              //     Navigator.pop(context); // Volta para a tela anterior
              //   },
              //   icon: const Icon(Icons.arrow_back),
              //   label: const Text('Voltar'),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificações',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Conversas',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.green,
          ),
        ],
        backgroundColor: Colors.green[600],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2, // Definido para 2, pois é a tela de Conversas
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchImmobileScreen()));
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => NotificationProvider(),
                    child: const NotificationScreen(),
                  ),
                ),
              );
              break;
            case 2:
              // Já está na tela de conversas
              break;
            case 3:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TenantProfileScreen()));
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}