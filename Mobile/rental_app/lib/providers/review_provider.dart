import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/api_service.dart'; // Assuming you have an ApiService

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  // Fetch reviews for a specific target (e.g., a property or a tenant)
  Future<void> fetchReviews({required String type, required int targetId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _apiService.fetchReviews(type: type, targetId: targetId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit a new review
  Future<void> submitReview({
    required int rating,
    String? comment,
    required String type,
    required int targetId,
    required int authorId, // Assuming you have the author's ID
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newReview = await _apiService.submitReview(
        rating: rating,
        comment: comment,
        type: type,
        targetId: targetId,
        authorId: authorId,
      );
      _reviews.add(newReview); // Optionally add the new review to the list
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}