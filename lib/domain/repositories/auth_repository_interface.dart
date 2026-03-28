import '../entities/user_entity.dart';

abstract class AuthRepositoryInterface {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> getCurrentUserData();

  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  });

  Future<void> updateFcmToken(String userId, String token);

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  Future<void> deleteAccount(String userId);
}
