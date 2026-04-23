import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../models/user_model.dart' as model; // Use model's UserRole

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get authStateChanges =>
      _auth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        return await getCurrentUserData();
      });

  @override
  Future<UserEntity?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;
    // Map UserModel to UserEntity
    final userModel = model.UserModel.fromFirestore(doc);
    return _mapToEntity(userModel);
  }

  @override
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    // Firestore profile missing — create a minimal one from Auth data
    if (!doc.exists) {
      debugPrint(
        '⚠️ AuthRepository: Firestore doc missing for uid=$uid, creating profile',
      );
      final authUser = credential.user!;
      final minimalModel = model.UserModel(
        id: uid,
        name: authUser.displayName ?? email.split('@').first,
        email: authUser.email ?? email,
        phone: authUser.phoneNumber ?? '',
        role: model.UserRole.client,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(minimalModel.toFirestore());
      return _mapToEntity(minimalModel);
    }

    return _mapToEntity(model.UserModel.fromFirestore(doc));
  }

  @override
  Future<UserEntity> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);

    final userModel = model.UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      // Map domain role to model role
      role: model.UserRole.values.byName(role.name),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userModel.id)
        .set(userModel.toFirestore());

    return _mapToEntity(userModel);
  }

  @override
  Future<void> updateFcmToken(String userId, String token) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'fcmToken': token});
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .delete();
    await _auth.currentUser?.delete();
  }

  UserEntity _mapToEntity(model.UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      name: userModel.name,
      email: userModel.email,
      phone: userModel.phone,
      role: UserRole.values.byName(userModel.role.name),
      avatarUrl: userModel.avatarUrl,
      rating: userModel.rating,
      reviewCount: userModel.reviewCount,
      isVerified: userModel.isVerified,
      bio: userModel.bio,
      serviceCategories: userModel.serviceCategories,
      fcmToken: userModel.fcmToken,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }
}
