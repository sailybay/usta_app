import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/review_entity.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<String> createReview(ReviewEntity review) async {
    final model = ReviewModel.fromEntity(review);
    final ref = await _firestore
        .collection(AppConstants.reviewsCollection)
        .add(model.toFirestore());
    return ref.id;
  }

  Future<List<ReviewEntity>> getWorkerReviews(String workerId) async {
    final result = await _firestore
        .collection(AppConstants.reviewsCollection)
        .where('workerId', isEqualTo: workerId)
        .orderBy('createdAt', descending: true)
        .get();
    return result.docs
        .map((d) => ReviewModel.fromFirestore(d).toEntity())
        .toList();
  }

  Future<void> updateWorkerRating(String workerId, double rating) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(workerId)
        .update({'rating': rating});
  }
}
