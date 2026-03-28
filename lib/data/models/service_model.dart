import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service_entity.dart';

class ServiceModel {
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
  final GeoPoint? location;
  final String? city;
  final DateTime createdAt;

  const ServiceModel({
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
    this.location,
    this.city,
    required this.createdAt,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      priceType: data['priceType'] ?? 'fixed',
      imageUrl: data['imageUrl'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      workerId: data['workerId'] ?? '',
      workerName: data['workerName'] ?? '',
      workerAvatarUrl: data['workerAvatarUrl'],
      isActive: data['isActive'] ?? true,
      tags: List<String>.from(data['tags'] ?? []),
      location: data['location'] as GeoPoint?,
      city: data['city'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'priceType': priceType,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'workerId': workerId,
      'workerName': workerName,
      'workerAvatarUrl': workerAvatarUrl,
      'isActive': isActive,
      'tags': tags,
      'location': location,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

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

  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      priceType: priceType,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      workerId: workerId,
      workerName: workerName,
      workerAvatarUrl: workerAvatarUrl,
      isActive: isActive,
      tags: tags,
      latitude: location?.latitude,
      longitude: location?.longitude,
      city: city,
      createdAt: createdAt,
    );
  }

  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      price: entity.price,
      priceType: entity.priceType,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      workerId: entity.workerId,
      workerName: entity.workerName,
      workerAvatarUrl: entity.workerAvatarUrl,
      isActive: entity.isActive,
      tags: entity.tags,
      location: (entity.latitude != null && entity.longitude != null)
          ? GeoPoint(entity.latitude!, entity.longitude!)
          : null,
      city: entity.city,
      createdAt: entity.createdAt,
    );
  }
}
