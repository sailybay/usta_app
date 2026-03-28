import 'package:equatable/equatable.dart';

enum UserRole { client, worker, admin }

class UserEntity extends Equatable {
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
  final List<String> serviceCategories;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
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
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isWorker => role == UserRole.worker;
  bool get isClient => role == UserRole.client;
  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    role,
    avatarUrl,
    rating,
    reviewCount,
    isVerified,
    bio,
    serviceCategories,
    fcmToken,
    createdAt,
    updatedAt,
  ];
}
