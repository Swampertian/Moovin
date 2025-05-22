import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _verificationCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final code = _verificationCodeController.text;
    final email = widget.arguments?['email'];
    final name = widget.arguments?['name'];
    final password = widget.arguments?['password'];
    final isOwner = widget.arguments?['isOwner'];

    
    await Future.delayed(const Duration(seconds: 2));

    if (code == '123456') { // Simulação de código correto
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verificado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navegar para a próxima tela (ex: tela de criação de perfil)
      Navigator.pushReplacementNamed(
        context,
        '/create-profile',
        arguments: {
          'name': name,
          'email': email,
          'password': password,
          'isOwner': isOwner,
        },
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Código de verificação inválido.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.arguments?['email'] ?? 'seu_email@exemplo.com';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Verificação de E-mail',
                style: GoogleFonts.khula(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F6D3C),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Um código de verificação foi enviado para:',
                style: GoogleFonts.khula(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: GoogleFonts.khula(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                'Digite o código de verificação:',
                style: GoogleFonts.khula(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _verificationCodeController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.khula(fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD7F0D5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.khula(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6D3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _verifyCode,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Verificar Código',
                          style: GoogleFonts.khula(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Adicionar lógica para reenviar o código
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reenviando código... (funcionalidade a ser implementada)'),
                      ),
                    );
                  },
                  child: Text(
                    'Reenviar código',
                    style: GoogleFonts.khula(color: const Color(0xFF6D472F), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}