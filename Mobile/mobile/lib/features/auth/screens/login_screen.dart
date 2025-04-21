import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

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
      _errorMessage = null; // Resetando mensagem de erro
    });

    final apiService = ApiService(baseUrl: 'http://localhost:8000/api'); // URL do seu backend

    try {
      final loginData = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      // Envia as credenciais para o backend e recebe o token
      final result = await apiService.loginUser(loginData);

      // Armazena o token JWT de forma segura
      await _secureStorage.write(key: 'jwt_token', value: result['access']);

      // Redireciona para a tela inicial ou outra após login bem-sucedido
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Exibe mensagem de erro em caso de falha no login
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
              // Logo da empresa
              Image.asset(
                'assets/images/logo.png',
                height: 250,
              ),

              // Título "Login"
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6D3C), // verde escuro
                ),
              ),
              const SizedBox(height: 32),

              // Campo de E-mail
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

              // Campo de Senha
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

              // Exibe mensagem de erro se houver
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              // Esqueceu a senha?
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // ação de esqueceu senha
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
                    // lógica de autenticação com Google
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

              // Texto de cadastro
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
