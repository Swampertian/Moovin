import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/owner_provider.dart';
import '../models/owner.dart';
import 'edit_owner_profile_screen.dart';
import 'owner_immobiles_screen.dart';
import 'edit_immobile_screen.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OwnerProvider()..fetchOwner(),
      child: Consumer<OwnerProvider>(
        builder: (context, provider, _) {
          final owner = provider.owner;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text('Perfil'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar Perfil',
                  onPressed: owner == null
                      ? null
                      : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditOwnerProfileScreen(owner: owner),
                      ),
                    );
                    if (result == true) {
                      provider.fetchOwner();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home_work),
                  tooltip: 'Meus Imóveis',
                  onPressed: owner == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OwnerImmobilesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text('Erro: ${provider.error}'))
                : owner == null
                ? const Center(child: Text('Nenhum dado encontrado.'))
                : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(height: 150, color: Colors.green),
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
                                      child: Icon(Icons.person, size: 50, color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      owner.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${owner.city}, ${owner.state}'),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(owner.aboutMe.isNotEmpty ? owner.aboutMe : 'Nenhuma informação fornecida'),
                        const SizedBox(height: 24),

                        const Text('Avaliação do proprietário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(owner.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < owner.rating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text('Histórico na plataforma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildItem('🟢 ${owner.rentedProperties} imóveis alugados pela plataforma'),
                              _buildItem('🟢 Perfil verificado'),
                              _buildItem(owner.fastResponder
                                  ? '🟢 Responde rapidamente'
                                  : '🔴 Responde lentamente'),
                              _buildItem('🟢 ${owner.rating.toStringAsFixed(1)} de avaliação dos inquilinos'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text('${owner.properties.length} imóveis anunciados',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        ListView.builder(
                          itemCount: owner.properties.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final p = owner.properties[index];
                            final imageUrl = p.photosBlob.isNotEmpty
                                ? p.photosBlob.first.imageBase64
                                : null;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                                    : Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.home, size: 32),
                                ),
                                title: Text('${p.propertyType} em ${p.city}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${p.street}, ${p.number ?? 'S/N'}'),
                                trailing: const Icon(Icons.edit, color: Colors.green),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditImmobileScreen(immobile: p),
                                    ),
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
                                  builder: (_) => const OwnerImmobilesScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Ver todos'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          );
        },
      ),
    );
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
}
