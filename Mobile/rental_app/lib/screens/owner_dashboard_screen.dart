import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  _OwnerDashboardScreenState createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = true;
  String? _errorMessage;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? userType = await _secureStorage.read(key: 'user_type');
      String? token = await _secureStorage.read(key: 'access_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'Você precisa estar logado para acessar esta página.';
          _isLoading = false;
        });
        return;
      }

      if (userType == 'Proprietario') {
        setState(() {
          _isOwner = true;
        });
      } else {
        setState(() {
          _errorMessage = 'Apenas proprietários podem acessar as estatísticas.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao verificar tipo de usuário: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchStatisticsPage() async {
    final url = Uri.parse('http://localhost:8000/api/owners/reports/statistics/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _errorMessage = 'Não foi possível abrir a página de estatísticas.';
      });
    }
  }
  Future<void> _launchManagementPage() async {
    String? token = await _secureStorage.read(key: 'jwt_token');
    final url = Uri.parse('http://localhost:8000/api/owners/management/');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _errorMessage = 'Não foi possível abrir a página de gerenciamento.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // Center widget to vertically and horizontally center the content
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 250,
                ),
                const Text(
                  'Dashboard do Proprietário',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F6D3C),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const CircularProgressIndicator(
                    color: Color(0xFF2F6D3C),
                  ),
                if (!_isLoading && _errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!_isLoading && _isOwner)
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _launchStatisticsPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F6D3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Ver Estatísticas',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _launchManagementPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F6D3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Ver Gerenciamento de imóveis',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (!_isLoading && _isOwner)
                  const Text(
                    'Clique acima para acessar as estatísticas financeiras.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF999999),
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}