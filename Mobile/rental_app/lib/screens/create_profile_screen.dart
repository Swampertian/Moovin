import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:rental_app/models/owner.dart';
import 'package:rental_app/models/tenant.dart';

class CreateProfileScreen extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  final bool isOwner;

  const CreateProfileScreen({
    Key? key,
    required this.userId,
    required this.name,
    required this.email,
    required this.isOwner,
  }) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _ageController = TextEditingController();
  final _jobController = TextEditingController();
  final _aboutMeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (widget.isOwner) {
      final owner = Owner(
        id: int.parse(widget.userId),
        name: widget.name,
        phone: _phoneController.text,
        city: _cityController.text,
        state: _stateController.text,
        aboutMe: _aboutMeController.text,
        revenueGenerated: 0.0,
        rentedProperties: 0,
        ratedByTenants: 0,
        recommendedByTenants: 0,
        fastResponder: true,
        rating: 0.0,
        properties: [],
      );

      await prefs.setString('owner_email', widget.email);
      await prefs.setString('owner_name', owner.name);
      await prefs.setString('owner_phone', owner.phone);
      await prefs.setString('owner_city', owner.city);
      await prefs.setString('owner_state', owner.state);
      await prefs.setString('owner_aboutMe', owner.aboutMe);

    } else {
      final tenant = Tenant(
        id: int.parse(widget.userId),
        name: widget.name,
        age: int.parse(_ageController.text),
        job: _jobController.text,
        city: _cityController.text,
        state: _stateController.text,
        aboutMe: _aboutMeController.text,
        prefersStudio: false,
        prefersApartment: false,
        prefersSharedRent: false,
        acceptsPets: false,
        userRating: 0.0,
        propertiesRented: 0,
        ratedByLandlords: 0,
        recommendedByLandlords: 0,
        favoritedProperties: 0,
        fastResponder: false,
        memberSince: '',
      );

      await prefs.setString('tenant_email', widget.email);
      await prefs.setString('tenant_name', tenant.name);
      await prefs.setString('tenant_phone', _phoneController.text);
      await prefs.setString('tenant_city', tenant.city);
      await prefs.setString('tenant_state', tenant.state);
      await prefs.setString('tenant_aboutMe', tenant.aboutMe);

    }
  }

  void _goToLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _saveProfile();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 180),
                const SizedBox(height: 20),

                const Text(
                  'Criação de Perfil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F6D3C),
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: TextEditingController(text: widget.name),
                  label: 'Nome',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira o nome' : null,
                  enabled: false,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Telefone',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira o telefone' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _cityController,
                  label: 'Cidade',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira a cidade' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _stateController,
                  label: 'Estado',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira o estado' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _ageController,
                  label: 'Idade',
                  validator: (value) {
                    final age = int.tryParse(value ?? '');
                    if (age == null || age <= 0) {
                      return 'Por favor, insira uma idade válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _jobController,
                  label: 'Profissão',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira sua profissão' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _aboutMeController,
                  label: 'Sobre mim',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Por favor, insira uma descrição sobre você' : null,
                ),
                const SizedBox(height: 40),

                _buildSubmitButton(
                  text: 'Salvar e Ir para Login',
                  onPressed: _goToLogin,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F6D3C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: label == 'Idade' ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFD7F0D5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _buildSubmitButton({
    required String text,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 320,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6D3C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
