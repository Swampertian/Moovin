import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';
import '../screens/review_create_screen.dart'; // Importe a tela de criação

class ReviewsScreen extends StatefulWidget {
  final String reviewType; // 'TENANT', 'OWNER', 'PROPERTY'
  final int targetId;
  final String title; // Optional title for the screen

  const ReviewsScreen({
    super.key,
    required this.reviewType,
    required this.targetId,
    this.title = 'Avaliações',
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String? _targetName;

  @override
  void initState() {
    super.initState();
    print('ReviewsScreen - targetId: ${widget.targetId}, reviewType: ${widget.reviewType}');
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    Future.wait([
      reviewProvider.fetchReviews(type: widget.reviewType, targetId: widget.targetId),
      _fetchTargetDetails(reviewProvider),
    ]);
  }

  Future<void> _fetchTargetDetails(ReviewProvider reviewProvider) async {
    final details = await reviewProvider.fetchTargetDetails(
      type: widget.reviewType,
      id: widget.targetId,
    );
    setState(() {
      if (widget.reviewType == 'TENANT' || widget.reviewType == 'OWNER') {
        _targetName = details['name'] as String?;
      } else if (widget.reviewType == 'PROPERTY') {
        _targetName = details['property_type'] as String?;
      }
    });
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _targetName ?? widget.title,
          ),
        ),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          if (reviewProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reviewProvider.error != null) {
            return Center(child: Text('Erro ao carregar as avaliações: ${reviewProvider.error}'));
          }

          final reviews = reviewProvider.reviews;

          if (reviews.isEmpty) {
            return const Center(child: Text('Ainda não há avaliações.'));
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Usuário ${review.authorId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        _buildRatingStars(review.rating),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(review.comment.isNotEmpty ? review.comment : 'Sem comentário.', style: const TextStyle(color: Colors.grey)),
                    const Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_review_button', // Opcional: tag única para o FAB
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => ReviewProvider(),
                child: Builder(
                  builder: (newContext) {
                    final args = ModalRoute.of(newContext)?.settings.arguments as Map<String, dynamic>?;
                    final reviewType = widget.reviewType; // Use o reviewType da tela atual
                    final targetId = widget.targetId;     // Use o targetId da tela atual
                    // Tente pegar o targetName, se disponível, senão use um padrão
                    final targetName = _targetName ?? widget.title ?? 'Detalhe';
                    return CreateReviewScreen(
                      reviewType: 'PROPERTY',
                      targetId: targetId,
                      targetName: targetName,
                    );
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
