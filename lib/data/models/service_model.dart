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
  final double? latitude;
  final double? longitude;
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
    this.latitude,
    this.longitude,
    this.city,
    required this.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      priceType: json['priceType'] ?? 'fixed',
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      workerId: json['workerId']?.toString() ?? '',
      workerName: json['workerName'] ?? '',
      workerAvatarUrl: json['workerAvatarUrl'],
      isActive: json['isActive'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
      latitude: (json['latitude'] ?? json['location']?['lat'])?.toDouble(),
      longitude: (json['longitude'] ?? json['location']?['lng'])?.toDouble(),
      city: json['city'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Firestore compatibility
  factory ServiceModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ServiceModel(
      id: documentId,
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
      latitude: data['location']?.latitude,
      longitude: data['location']?.longitude,
      city: data['city'],
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
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
      'city': city,
      'location': latitude != null && longitude != null
          ? GeoPoint(latitude!, longitude!)
          : null,
      'createdAt': FieldValue.serverTimestamp(),
    };
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
      latitude: latitude,
      longitude: longitude,
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
      latitude: entity.latitude,
      longitude: entity.longitude,
      city: entity.city,
      createdAt: entity.createdAt,
    );
  }
}
