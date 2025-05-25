import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../services/api_service.dart';
import './tenant_edit_profile_screen.dart';
import 'search_immobile_screen.dart'; 
import '../services/auth_service.dart';
class TenantProfileScreen extends StatefulWidget {
  const TenantProfileScreen({super.key});

  @override
  _TenantProfileScreenState createState() => _TenantProfileScreenState();
}

class _TenantProfileScreenState extends State<TenantProfileScreen> {
  bool _isLoading = true;

   @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Widget _buildHistoryItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  void _checkAccess() async {
    // Placeholder: Replace with your actual authentication service
    final authService = AuthService(); // Inject or initialize your auth service
    bool loggedIn = await authService.isLoggedIn();
    bool isTenant = await authService.isTenant();

    if (!loggedIn) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    } else if (!isTenant) {
      Navigator.of(context).pushReplacementNamed('/erro-screen');
      return;
    }


    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TenantProvider()..fetchTenant(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'Perfil',
            style: TextStyle(color: Colors.white), // Texto "Perfil" branco
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white, // Ícone da seta branco
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Consumer<TenantProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white, // Ícone de editar branco
                  ),
                  onPressed: provider.tenant != null
                      ? () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TenantEditProfileScreen(
                                tenant: provider.tenant!,
                              ),
                            ),
                          );
                          if (result == true) {
                            provider.fetchTenant(); // Refresh the data after editing
                          }
                        }
                      : null,
                );
              },
            ),
          ],
        ),
        body: Consumer<TenantProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text('Erro: ${provider.error}'));
            }

            final tenant = provider.tenant;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        color: Colors.green,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      tenant != null && tenant.name.isNotEmpty && tenant.age > 0
                                          ? '${tenant.name}, ${tenant.age}'
                                          : 'Nome não informado',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.work, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          tenant != null && tenant.job.isNotEmpty
                                              ? tenant.job
                                              : 'Profissão não informada',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          tenant != null &&
                                                  tenant.city.isNotEmpty &&
                                                  tenant.state.isNotEmpty
                                              ? '${tenant.city}, ${tenant.state}'
                                              : 'Localização não informada',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sobre mim',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tenant != null && tenant.aboutMe.isNotEmpty
                              ? tenant.aboutMe
                              : 'Nenhuma informação fornecida',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Procurando por',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (tenant != null && tenant.prefersStudio)
                              Chip(
                                label: const Text('Estúdio'),
                                avatar: const Icon(Icons.home),
                                backgroundColor: Colors.blue[100],
                              ),
                            if (tenant != null && tenant.prefersApartment)
                              Chip(
                                label: const Text('Apartamento'),
                                avatar: const Icon(Icons.apartment),
                                backgroundColor: Colors.orange[100],
                              ),
                            if (tenant != null && tenant.prefersSharedRent)
                              Chip(
                                label: const Text('Aluguel compartilhado'),
                                avatar: const Icon(Icons.group),
                                backgroundColor: Colors.red[100],
                              ),
                            if (tenant != null && tenant.acceptsPets)
                              Chip(
                                label: const Text('Aceita pets'),
                                avatar: const Icon(Icons.pets),
                                backgroundColor: Colors.green[100],
                              ),
                            if (tenant == null ||
                                (!tenant.prefersStudio &&
                                    !tenant.prefersApartment &&
                                    !tenant.prefersSharedRent &&
                                    !tenant.acceptsPets))
                              const Text(
                                'Nenhuma preferência informada',
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Avaliação do usuário',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tenant != null
                                  ? tenant.userRating.toStringAsFixed(1)
                                  : '0.0',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index <
                                          (tenant != null
                                                  ? tenant.userRating.floor()
                                                  : 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Histórico na plataforma',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  _buildHistoryItem(
                                    tenant != null
                                        ? 'Alugou ${tenant.propertiesRented} propriedades pela plataforma'
                                        : 'Nenhuma propriedade alugada',
                                    Icons.home,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildHistoryItem(
                                    tenant != null
                                        ? 'Perfil avaliado por ${tenant.ratedByLandlords} proprietários'
                                        : 'Nenhum proprietário avaliou',
                                    Icons.star_rate,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildHistoryItem(
                                    tenant != null
                                        ? 'Recomendado por ${tenant.recommendedByLandlords} proprietários'
                                        : 'Nenhuma recomendação',
                                    Icons.recommend,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildHistoryItem(
                                    tenant != null
                                        ? 'Favoritou ${tenant.favoritedProperties} propriedades'
                                        : 'Nenhuma propriedade favoritada',
                                    Icons.favorite,
                                  ),
                                  if (tenant != null && tenant.fastResponder)
                                    const SizedBox(height: 8),
                                  if (tenant != null && tenant.fastResponder)
                                    _buildHistoryItem(
                                      'Responde rapidamente',
                                      Icons.speed,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            tenant != null
                                ? 'Usuário desde ${tenant.memberSince}'
                                : 'Usuário desde: Não informado',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificações',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
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
          currentIndex: 3, // Mantido 3, pois Perfil é o último item (índice 3)
          onTap: (index) {
            // Lógica de navegação
            if (index == 0) {
              // Redireciona para a tela de busca (SearchImmobileScreen)
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchImmobileScreen()));
            } else if (index == 1) {
              // Lógica para Notificações (ainda não implementada)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
            } else if (index == 2) {
              // Lógica para Conversas (ainda não implementada)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
            } else if (index == 3) {
              // Já está na tela de perfil, talvez fazer nada ou rolar para o topo
            }
          },
        ),
      ),
    );
  }
}