// DATA MODELS

// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { client, worker, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String? bio;
  final List<String> serviceCategories; // for workers
  final String? fcmToken;
  final double? latitude; // worker location on map
  final double? longitude; // worker location on map
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.bio,
    this.serviceCategories = const [],
    this.fcmToken,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == (data['role'] ?? 'client'),
        orElse: () => UserRole.client,
      ),
      avatarUrl: data['avatarUrl'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      bio: data['bio'],
      serviceCategories: List<String>.from(data['serviceCategories'] ?? []),
      fcmToken: data['fcmToken'],
      latitude: (data['lat'] as num?)?.toDouble(),
      longitude: (data['lng'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'bio': bio,
      'serviceCategories': serviceCategories,
      'fcmToken': fcmToken,
      if (latitude != null) 'lat': latitude,
      if (longitude != null) 'lng': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? avatarUrl,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    String? bio,
    List<String>? serviceCategories,
    String? fcmToken,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      fcmToken: fcmToken ?? this.fcmToken,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isWorker => role == UserRole.worker;
  bool get isClient => role == UserRole.client;
  bool get isAdmin => role == UserRole.admin;
}
