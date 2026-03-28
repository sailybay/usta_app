import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? priceType; // 'fixed', 'hourly', 'from'
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final String workerId;
  final String workerName;
  final String? workerAvatarUrl;
  final bool isActive;
  final List<String> tags;
  final double? latitude;
  final double? longitude;
  final String? city;
  final DateTime createdAt;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.priceType = 'fixed',
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.workerId,
    required this.workerName,
    this.workerAvatarUrl,
    this.isActive = true,
    this.tags = const [],
    this.latitude,
    this.longitude,
    this.city,
    required this.createdAt,
  });

  String get formattedPrice {
    switch (priceType) {
      case 'hourly':
        return '\$${price.toStringAsFixed(0)}/hr';
      case 'from':
        return 'From \$${price.toStringAsFixed(0)}';
      default:
        return '\$${price.toStringAsFixed(0)}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    price,
    priceType,
    imageUrl,
    rating,
    reviewCount,
    workerId,
    workerName,
    workerAvatarUrl,
    isActive,
    tags,
    latitude,
    longitude,
    city,
    createdAt,
  ];
}
