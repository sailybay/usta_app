import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  // Real-time user stream
  Stream<UserModel?> watchUser(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? bio,
    String? avatarUrl,
    List<String>? serviceCategories,
  }) async {
    final updates = <String, dynamic>{'updatedAt': Timestamp.now()};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
    if (serviceCategories != null) {
      updates['serviceCategories'] = serviceCategories;
    }

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update(updates);
  }

  // Get workers by category (empty = all verified workers)
  Future<List<UserModel>> getWorkersByCategory(String category) async {
    Query query = _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'worker')
        .where('isVerified', isEqualTo: true);

    if (category.isNotEmpty) {
      query = query.where('serviceCategories', arrayContains: category);
    }

    final result = await query.orderBy('rating', descending: true).get();
    return result.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Workers with location set — used by the map screen
  Future<List<UserModel>> getWorkersWithLocation() async {
    final result = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'worker')
        .where('isVerified', isEqualTo: true)
        .get();
    return result.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .where((u) => u.latitude != null && u.longitude != null)
        .toList();
  }

  // Search workers by name
  Future<List<UserModel>> searchWorkers(String query) async {
    final lower = query.toLowerCase();
    final upper = '${query.toLowerCase()}\uf8ff';
    final result = await _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: 'worker')
        .where('name', isGreaterThanOrEqualTo: lower)
        .where('name', isLessThanOrEqualTo: upper)
        .get();

    return result.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Update worker rating after a review
  Future<void> updateWorkerRating(
    String workerId,
    double newRating,
    int newReviewCount,
  ) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(workerId)
        .update({'rating': newRating, 'reviewCount': newReviewCount});
  }
}
