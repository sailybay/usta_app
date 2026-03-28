import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String orderId;
  final String clientId;
  final String clientName;
  final String? clientAvatarUrl;
  final String workerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
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

  @override
  List<Object?> get props => [
    id,
    orderId,
    clientId,
    clientName,
    clientAvatarUrl,
    workerId,
    rating,
    comment,
    createdAt,
  ];
}
