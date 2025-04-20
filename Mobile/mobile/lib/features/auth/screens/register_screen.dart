import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                'assets/images/logo.png', // Substitua com o nome correto da imagem
                height: 180,
              ),

              const SizedBox(height: 20),

              const Text(
                'Cadastro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6D3C), // Verde escuro
                ),
              ),

              const SizedBox(height: 20),

              // Campo Nome
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F6D3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Campo E-mail
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-mail',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F6D3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Campo Senha
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F6D3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Campo Confirmar Senha
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirmar Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F6D3C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFD7F0D5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Botão: Cadastrar-se como locatário
              SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6D3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar-se como locatário',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão: Cadastrar-se como inquilino
              SizedBox(
                width: 320,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Color(0xFF2F6D3C), width: 2),
                  ),
                  child: const Text(
                    'Cadastrar-se como inquilino',
                    style: TextStyle(color: Color(0xFF2F6D3C), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Link para login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem cadastro? ',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF6D472F),
                        fontSize: 18,
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