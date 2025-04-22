import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

//Tela de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;
  String? _errorMessage;

  // Função para login
  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; 
    });

    final apiService = ApiService(baseUrl: 'http://localhost:8000'); 

    try {
    String email = _emailController.text;
    String password = _passwordController.text;

    final result = await apiService.loginUser(email, password);

    print('Resultado do login: $result');

    if (result['access'] != null) {

      await _secureStorage.write(key: 'jwt_token', value: result['access']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login bem-sucedido!'),
          backgroundColor: Colors.green,
        ),
      );

    } else {
      throw Exception('Token de acesso não encontrado.');
    }
  } catch (e) {
    print('Erro ao fazer login: $e');
    
    setState(() {
      _errorMessage = 'Erro ao fazer login. Tente novamente.';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/logo.png',
                height: 250,
              ),

              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6D3C), 
                ),
              ),
              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-mail',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F6D3C)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Senha',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F6D3C)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                  },
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6D472F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6D3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 320,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                  },
                  icon: Image.asset(
                    'assets/images/devicon_google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    'Entrar com o Google',
                    style: TextStyle(
                      color: Color(0xFF2F6D3C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Color(0xFF2F6D3C), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não tem login? ',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF6D472F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
