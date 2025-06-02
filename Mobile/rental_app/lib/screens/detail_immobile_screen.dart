import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/immobile_provider.dart';
import '../providers/review_provider.dart';
import '../models/immobile.dart';
import '../services/auth_service.dart';
import 'review_screen.dart';
import 'owner_profile_screen.dart';
import 'tenant_profile_screen.dart';
import 'search_immobile_screen.dart';
import 'notification_screen.dart'; 
import 'chat_screen.dart'; 
import '../providers/notification_provider.dart';
import 'unauthorized_screen.dart';

class DetailImmobileScreen extends StatefulWidget {
  final int immobileId;
  const DetailImmobileScreen({super.key, required this.immobileId});

  @override
  _DetailImmobileScreenState createState() => _DetailImmobileScreenState();
}

class _DetailImmobileScreenState extends State<DetailImmobileScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  String? _userType; 

  @override
  void initState() {
    super.initState();
    _checkAccess();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final authService = AuthService();
    _userType = await authService.getUserType();
    setState(() {});
  }

  void _checkAccess() async {
    // Placeholder: Replace with your actual authentication service
    final authService = AuthService(); // Inject or initialize your auth service
    bool loggedIn = await authService.isLoggedIn();
    //bool isOwner = await authService.isOwner();

    if (!loggedIn) {
      // Navigator.of(context).pushReplacementNamed('/login');
      Navigator.of(context).pushReplacementNamed('/erro-screen');
      return;
    }

    // if (!isOwner) {
    //   
    //   return;
    // }

    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    final authService = AuthService();

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchImmobileScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => NotificationProvider(),
              child: const NotificationScreen(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
        break;
      case 3:
        _userType = await authService.getUserType();
        if (_userType == 'Proprietario') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OwnerProfileScreen()),
          );
        } else if (_userType == 'Inquilino') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TenantProfileScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UnauthorizedScreen()),
          );
        }
        break;
    }
  }

  Widget _buildThumbnail(String? imageBase64, String contentType) {
    if (imageBase64 == null || imageBase64.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.image_not_supported_outlined),
      );
    }
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: MemoryImage(Uri.parse('data:$contentType;base64,$imageBase64').data!.contentAsBytes()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.brown[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(bool value, IconData icon, String label) {
    return value
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey[600]),
          );
  }

  Widget _buildMapLabelWithIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[800]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildMapLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
    );
  }

  Widget _buildMapBlockLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
    );
  }

@override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => ImmobileProvider()..fetchImmobile(widget.immobileId),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<ImmobileProvider>(
            builder: (context, provider, child) {
              return const Text('Detalhes do imóvel');
            },
          ),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.star_border),
              onPressed: () {
                // Handle adding/removing from favorites
              },
            ),
          ],
        ),
        body: Consumer<ImmobileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final immobile = provider.immobile;

            if (immobile == null) {
              return const Center(child: Text('Erro ao carregar detalhes do imóvel.'));
            }

            // Simulação da média de avaliação - REMOVER QUANDO INTEGRADO COM A API
            double averageRating = 4.2;
            bool hasFetchedReviews = false;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        PageView(
                          children: immobile.photosBlob.map((photo) {
                            return Image.memory(
                              Uri.parse('data:${photo.contentType};base64,${photo.imageBase64}').data!.contentAsBytes(),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }).toList().isNotEmpty
                              ? immobile.photosBlob.map((photo) {
                                  return Image.memory(
                                    Uri.parse('data:${photo.contentType};base64,${photo.imageBase64}').data!.contentAsBytes(),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.contain,
                                  );
                                }).toList()
                              : [
                                  Container(
                                    color: Colors.grey[300],
                                    child: const Center(child: Icon(Icons.image_not_supported_outlined, size: 50)),
                                  )
                                ],
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...immobile.photosBlob.map((photo) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: _buildThumbnail(photo.imageBase64, photo.contentType),
                                  );
                                }).toList(),
                                if (immobile.photosBlob.length > 3)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+${immobile.photosBlob.length - 3}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(Icons.star_border, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              immobile.propertyType == 'house' ? 'Casa'
                                  : immobile.propertyType == 'apartment' ? 'Apartamento'
                                  : immobile.propertyType, // tradução
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'R\$ ${immobile.rent.toStringAsFixed(2)}/mês',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${immobile.city}, ${immobile.state}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDetailChip(Icons.zoom_out_map, '${immobile.area} m²'),
                            _buildDetailChip(Icons.bed, '${immobile.bedrooms}'),
                            _buildDetailChip(Icons.bathtub, '${immobile.bathrooms}'),
                            if (immobile.airConditioning)
                              _buildDetailChip(Icons.ac_unit, 'Ar Cond.'),
                            if (immobile.garage)
                              _buildDetailChip(Icons.garage_outlined, 'Garagem'),
                            if (immobile.pool)
                              _buildDetailChip(Icons.pool, 'Piscina'),
                            if (immobile.furnished)
                              _buildDetailChip(Icons.chair, 'Mobiliado'),
                            if (immobile.petFriendly)
                              _buildDetailChip(Icons.pets, 'Pet Friendly'),
                            if (immobile.nearbyMarket)
                              _buildDetailChip(Icons.shopping_cart, 'Mercado P.'),
                            if (immobile.nearbyBus)
                              _buildDetailChip(Icons.directions_bus, 'Ônibus P.'),
                            if (immobile.internet)
                              _buildDetailChip(Icons.wifi, 'Internet'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Consumer<ReviewProvider>(
                          builder: (context, reviewProvider, child) {
                            if (!hasFetchedReviews) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                reviewProvider.fetchReviews(type: 'immobile', targetId: immobile.idImmobile);
                                hasFetchedReviews = true;
                              });
                            }
                              
                            if (reviewProvider.isLoading) {
                              return const CircularProgressIndicator();
                            }
                            print('Reviews: ${reviewProvider.reviews}');
                            final reviews = reviewProvider.reviews;
                            double averageRating = 0;

                            if (reviews.isNotEmpty) {
            final totalRating = reviews.fold<double>(0, (sum, review) => sum + review.rating);
            final averageRating = totalRating / reviews.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsScreen(
                          reviewType: 'PROPERTY',
                          targetId: immobile.idImmobile,
                          title: 'Avaliações do Imóvel',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      StarRating(rating: averageRating, starSize: 20),
                      const SizedBox(width: 8),
                      Text('(${reviews.length} avaliações)', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/review',
                                        arguments: {
                                          'reviewType': 'immobile',
                                          'targetId': immobile.idImmobile,
                                          'targetName': immobile.propertyType,
                                        },
                                      );
                                    },
                                    child: const Text('Ver avaliações'),
                                  ),
                ),
              ],
            );
          }       else{
                              // Sem avaliações
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Sem avaliações ainda.', style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/review',
                                        arguments: {
                                          'reviewType': 'immobile',
                                          'targetId': immobile.idImmobile,
                                          'targetName': immobile.propertyType,
                                        },
                                      );
                                    },
                                    child: const Text('Ver avaliações'),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        const Text(
                          'Detalhes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          immobile.description,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        if (immobile.additionalRules != null && immobile.additionalRules!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'Regras Adicionais',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                immobile.additionalRules!,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
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
              label: 'Pesquisar',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificações',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Conversas',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.green[600],
          onTap: _onItemTapped,
        ),
        floatingActionButton: Transform.scale(
        scale: 0.9,
        child: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('O Chat será implementado em breve!')),
            );
          },
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.chat, color: Colors.white),
          label: const Text('Falar com proprietário', style: TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

// Crie um widget separado para a exibição das estrelas
class StarRating extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 18,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          color: color,
          size: starSize,
        );
      }),
    );
  }
}