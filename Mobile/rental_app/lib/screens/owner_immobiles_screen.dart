import 'package:flutter/material.dart';
import '../models/owner.dart'; // Immobile está dentro de owner.dart
import '../services/api_service.dart';
import 'edit_immobile_screen.dart';

class OwnerImmobilesScreen extends StatefulWidget {
  final int ownerId;

  const OwnerImmobilesScreen({Key? key, required this.ownerId}) : super(key: key);

  @override
  State<OwnerImmobilesScreen> createState() => _OwnerImmobilesScreenState();
}

class _OwnerImmobilesScreenState extends State<OwnerImmobilesScreen> {
  List<Immobile> immobiles = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchImmobiles();
  }

  Future<void> fetchImmobiles() async {
    try {
      final apiService = ApiService();
      final owner = await apiService.fetchOwner(widget.ownerId);
      setState(() {
        immobiles = owner.properties;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _refreshList() async {
    await fetchImmobiles();
  }

  void _navigateToEdit(Immobile immobile) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditImmobileScreen(immobile: immobile)),
    );

    if (updated == true) {
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Imóveis'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(child: Text('Erro ao carregar imóveis.'))
          : RefreshIndicator(
        onRefresh: _refreshList,
        child: immobiles.isEmpty
            ? const Center(child: Text('Nenhum imóvel encontrado.'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: immobiles.length,
          itemBuilder: (context, index) {
            final immobile = immobiles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: immobile.imageUrl != null
                    ? Image.network(
                  immobile.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, size: 32),
                ),
                title: Text(immobile.idImmobile.toString() ?? 'Sem título'),
                subtitle: Text('${immobile.city}, ${immobile.state}'),
                trailing: const Icon(Icons.edit),
                onTap: () => _navigateToEdit(immobile),
              ),
            );
          },
        ),
      ),
    );
  }
}
