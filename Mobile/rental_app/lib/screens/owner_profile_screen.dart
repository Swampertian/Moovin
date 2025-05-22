import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/owner_provider.dart';
import '../models/owner.dart';
import 'edit_owner_profile_screen.dart';
import 'owner_immobiles_screen.dart';
import 'edit_immobile_screen.dart';
import '../services/auth_service.dart';
class OwnerProfileScreen extends StatefulWidget {
  final int ownerId;

  const OwnerProfileScreen({super.key, required this.ownerId});

  @override
  _OwnerProfileScreenState createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Widget _buildItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
  
  void _checkAccess() async {
    final authService = AuthService();
    bool loggedIn = await authService.isLoggedIn();
    bool isOwner = await authService.isOwner();

    if (!loggedIn) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    } else if (!isOwner) {
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
      create: (_) => OwnerProvider()..fetchOwner(widget.ownerId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar Perfil',
              onPressed: () async {
                final provider = context.read<OwnerProvider>();
                final owner = provider.owner!;
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditOwnerProfileScreen(owner: owner),
                  ),
                );
                if (updated == true) {
                  provider.fetchOwner(widget.ownerId);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.home_work),
              tooltip: 'Meus Imóveis',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OwnerImmobilesScreen(ownerId: widget.ownerId),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<OwnerProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text('Erro: ${provider.error}'));
            }
            final owner = provider.owner!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER CARD
                  InkWell(
                    onTap: () async {
                      final provider = context.read<OwnerProvider>();
                      final owner = provider.owner!;
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditOwnerProfileScreen(owner: owner),
                        ),
                      );
                      if (updated == true) {
                        provider.fetchOwner(widget.ownerId);
                      }
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              child: Icon(Icons.person, size: 40),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(owner.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text('Proprietário individual'),
                                  Text('${owner.city}, ${owner.state}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // IMÓVEIS ANUNCIADOS
                  Text('${owner.properties.length} imóveis anunciados',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ListView.builder(
                    itemCount: owner.properties.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final p = owner.properties[index];
                      // pega a primeira foto, se existir
                      final imageUrl =
                      p.photosBlob.isNotEmpty ? p.photosBlob.first.imageBase64 : null;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover)
                              : const SizedBox(width: 60, height: 60),
                          title: Text(p.street),
                          subtitle: Text('${p.city}, ${p.state}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // exibe rating do OWNER, não do imóvel
                              Text('${owner.rating.toStringAsFixed(1)} ★'),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.king_bed, size: 16),
                                  Text(' ${p.bedrooms}'),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.square_foot, size: 16),
                                  Text(' ${p.area}m²'),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditImmobileScreen(immobile: p)),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OwnerImmobilesScreen(ownerId: widget.ownerId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Ver todos'),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // AVALIAÇÃO
                  const Text('Avaliação do Locatário',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rate_rounded, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(owner.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < owner.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(owner.aboutMe),

                  const SizedBox(height: 24),
                  const Text('Sobre o proprietário',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildItem(
                            '🟢 ${owner.rentedProperties} imóveis alugados pela plataforma'),
                        _buildItem(owner.fastResponder
                            ? '🟢 Responde rapidamente'
                            : '🔴 Responde lentamente'),
                        _buildItem(
                            '🟢 ${owner.rating} inquilinos avaliaram este proprietário'),
                        _buildItem('🟢 Perfil verificado'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.green,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}