import '../entities/review_entity.dart';

/// C2 fix: Domain interface for the review repository.
/// OrderBloc depends on this interface, not on the concrete ReviewRepository.
abstract class ReviewRepositoryInterface {
  Future<String> createReview(ReviewEntity review);
  Future<List<ReviewEntity>> getWorkerReviews(String workerId);
  Future<void> updateWorkerRating(String workerId, double rating);
}
