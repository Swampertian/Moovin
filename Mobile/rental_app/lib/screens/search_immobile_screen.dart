import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/immobile.dart';


class SearchImmobileScreen extends StatefulWidget {
  const SearchImmobileScreen({super.key});

  @override
  State<SearchImmobileScreen> createState() => _SearchImmobileScreenState();
}

class _SearchImmobileScreenState extends State<SearchImmobileScreen> {

  TextEditingController _searchController = TextEditingController();
  String localization = '';
  final apiService = ApiService();
  List<Immobile> imoveis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImmobiles({});
    _searchController.addListener(() {
      setState(() {
        localization = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchImmobiles(Map<String, dynamic>? filtros) async {
    try {
      
      final lista = await apiService.fetchImmobile(
                                type: filtros?['tipo'],
                                bedrooms: filtros?['quartos'],
                                bathrooms: filtros?['banheiros'],
                                garage: filtros?['garagem'],
                                rentValue: filtros?['valorAluguel'],
                                areaSize: filtros?['tamanho'],
                                distance: filtros?['distancia'],
                                date: filtros?['data'],
                                wifi: filtros?['itens']?['Wi-Fi'],
                                airConditioning: filtros?['itens']?['Ar-condicionado'],
                                petFriendly: filtros?['itens']?['Aceita pets'],
                                furnished: filtros?['itens']?['Mobiliado'],
                                pool: filtros?['itens']?['Piscina'],
                                city: filtros?['city'],
                              );

      setState(() {
        imoveis = lista;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar imóveis: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _abrirBottomSheet(BuildContext context) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      DateTime? selectedDate;
      int quartos = 2;
      int banheiros = 1;
      double tamanho = 100;
      double distancia = 10;
      int garagem = 1;
      double valorAluguel = 1500;
      String tipoSelecionado = "";

      Map<String, bool> itens = {
        "Wi-Fi": true,
        "Ar-condicionado": false,
        "Aceita pets": true,
        "Mobiliado": false,
        "Piscina": false,
      };

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Filtros de Busca",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Categoria
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryButton(
                        context,
                        icon: Icons.home_work_outlined,
                        label: "Casa",
                        selected: tipoSelecionado == "Casa",
                        onTap: () {
                          setState(() {
                            tipoSelecionado = tipoSelecionado == "Casa" ? "" : "Casa";
                          });
                        },
                      ),
                      _buildCategoryButton(
                        context,
                        icon: Icons.apartment,
                        label: "Apartamento",
                        selected: tipoSelecionado == "Apartamento",
                        onTap: () {
                          setState(() {
                            tipoSelecionado = tipoSelecionado == "Apartamento" ? "" : "Apartamento";
                          });
                        },
                      ),
                      _buildCategoryButton(
                        context,
                        icon: Icons.house_outlined,
                        label: "Kitnet",
                        selected: tipoSelecionado == "Kitnet",
                        onTap: () {
                          setState(() {
                            tipoSelecionado = tipoSelecionado == "Kitnet" ? "" : "Kitnet";
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Número de Quartos
                  const Text("Número de quartos", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quartos > 0) quartos--;
                          });
                        },
                      ),
                      Text("$quartos"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quartos++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Número de Banheiros
                  const Text("Número de banheiros", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (banheiros > 0) banheiros--;
                          });
                        },
                      ),
                      Text("$banheiros"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            banheiros++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Garagem
                  const Text("Número de vagas na garagem", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (garagem > 0) garagem--;
                          });
                        },
                      ),
                      Text("$garagem"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            garagem++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Valor do aluguel
                  const Text("Valor máximo do aluguel (R\$)", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: valorAluguel,
                    min: 500,
                    max: 10000,
                    divisions: 95,
                    label: "R\$ ${valorAluguel.toInt()}",
                    onChanged: (value) {
                      setState(() {
                        valorAluguel = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Tamanho do imóvel
                  const Text("Tamanho do imóvel (m²)", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: tamanho,
                    min: 20,
                    max: 1000,
                    divisions: 50,
                    label: "${tamanho.toInt()} m²",
                    onChanged: (value) {
                      setState(() {
                        tamanho = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Distância
                  const Text("Distância máxima (km)", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: distancia,
                    min: 1,
                    max: 100,
                    divisions: 20,
                    label: "${distancia.toInt()} km",
                    onChanged: (value) {
                      setState(() {
                        distancia = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Data de Lançamento
                  const Text("Data de Lançamento do Anúncio", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "Selecionar data",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Itens
                  const Text("Itens", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...itens.entries.map((entry) => CheckboxListTile(
                        title: Text(entry.key),
                        value: entry.value,
                        onChanged: (value) {
                          setState(() {
                            itens[entry.key] = value ?? false;
                          });
                        },
                      )),

                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          "tipo": tipoSelecionado,
                          "quartos": quartos,
                          "banheiros": banheiros,
                          "garagem": garagem,
                          "valorAluguel": valorAluguel,
                          "tamanho": tamanho,
                          "distancia": distancia,
                          "data": selectedDate,
                          "itens": itens,
                        });
                      },
                      child: const Text("Aplicar Filtros"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


Widget _buildCategoryButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).primaryColor : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 30,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.black),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Color.fromRGBO(76, 228, 99, 100),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const Text(
              "Encontre seu imóvel dos sonhos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value){localization = value;},
              onSubmitted: (value) async {
                      setState(() {
                        isLoading = true;
                      });
                      await fetchImmobiles({'city': value});
                    },     
              decoration: InputDecoration(
                hintText: "Busque pela localização",
                prefixIcon: const Icon(Icons.search),
               suffixIcon: GestureDetector(
               onTap: () async {
                            final filtros = await _abrirBottomSheet(context);
                            
                            if (filtros != null) {
                              // Exibe os filtros para debug
                              print(filtros);
                              
                              // Avisa que está carregando antes de fazer a requisição
                              setState(() {
                                isLoading = true;
                              });

                              // Chama a função fetchImmobiles com os filtros
                              await fetchImmobiles(filtros);
                            }
                          },
                child: const Icon(Icons.tune),
              ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CategoryIcon(icon: Icons.house_outlined, label: "Casa"),
                CategoryIcon(icon: Icons.apartment, label: "Apartamento"),
                CategoryIcon(icon: Icons.home_work_outlined, label: "Kitnet"),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Recomendações",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Align(
                  alignment: Alignment.center,
                  child:imoveis.isEmpty ? const Text(
                                                'Nenhum imóvel encontrado',
                                                style: TextStyle(fontSize: 16, color: Colors.grey),
                                              )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: imoveis.length, 
                              itemBuilder: (context, index) {
                                final imovel = imoveis[index];
                                    return PropertyCard(
                                                  imageUrl: 'https://th.bing.com/th/id/OIP.Dzz0pHitTq_-nEuYC0dgtQHaFC?rs=1&pid=ImgDetMain', 
                                                  title: imovel.propertyType,
                                                  location: '${imovel.city}, ${imovel.state}',
                                                  beds: imovel.bedrooms,
                                                  baths: imovel.bathrooms,
                                                  size: 2,
                                                  rating: 4.5, 
);

                              },
  ),)
                  
                  ,
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int size;
  final double rating;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.size,
    required this.rating,
  });

  @override
 Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;

      return Center(
        child: Container(
          width: maxWidth > 600 ? 500 : maxWidth * 0.9, // Limita o tamanho máximo
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(location),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.bed, size: 16), Text(" $beds  "),
                        const Icon(Icons.bathtub, size: 16), Text(" $baths  "),
                        const Icon(Icons.square_foot, size: 16), Text(" ${size}m²"),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.green),
                  Text(rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
