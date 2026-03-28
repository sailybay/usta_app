import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String orderId;
  final String clientId;
  final String clientName;
  final String? clientAvatarUrl;
  final String workerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.orderId,
    required this.clientId,
    required this.clientName,
    this.clientAvatarUrl,
    required this.workerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      orderId: data['orderId'] ?? '',
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientAvatarUrl: data['clientAvatarUrl'],
      workerId: data['workerId'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'clientId': clientId,
    'clientName': clientName,
    'clientAvatarUrl': clientAvatarUrl,
    'workerId': workerId,
    'rating': rating,
    'comment': comment,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    orderId: orderId,
    clientId: clientId,
    clientName: clientName,
    clientAvatarUrl: clientAvatarUrl,
    workerId: workerId,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
  );

  factory ReviewModel.fromEntity(ReviewEntity entity) => ReviewModel(
    id: entity.id,
    orderId: entity.orderId,
    clientId: entity.clientId,
    clientName: entity.clientName,
    clientAvatarUrl: entity.clientAvatarUrl,
    workerId: entity.workerId,
    rating: entity.rating,
    comment: entity.comment,
    createdAt: entity.createdAt,
  );
}
