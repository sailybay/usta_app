// test/blocs/auth_bloc_test.dart
// Tests for AuthBloc — covers A3 fix (password reset via BLoC) and auth flows
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/data/repositories/auth_repository.dart';
import 'package:usta_app/domain/entities/user_entity.dart';
import 'package:usta_app/presentation/blocs/auth/auth_bloc.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────
class MockAuthRepository extends Mock implements AuthRepository {}

// ─── Fixtures ─────────────────────────────────────────────────────────────────
UserEntity _makeUser({UserRole role = UserRole.client}) {
  return UserEntity(
    id: 'u1',
    name: 'Test User',
    email: 'test@test.com',
    phone: '+7 777 000 0000',
    role: role,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );
}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    registerFallbackValue(UserRole.client);
  });

  AuthBloc buildBloc() => AuthBloc(authRepository: mockRepo);

  // ─── AuthCheckRequested ──────────────────────────────────────────────────────
  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when user exists',
      build: () {
        when(
          () => mockRepo.getCurrentUserData(),
        ).thenAnswer((_) async => _makeUser());
        return buildBloc();
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no user',
      build: () {
        when(() => mockRepo.getCurrentUserData()).thenAnswer((_) async => null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] on exception',
      build: () {
        when(() => mockRepo.getCurrentUserData()).thenThrow(Exception('error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );
  });

  // ─── AuthLoginRequested ──────────────────────────────────────────────────────
  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(
          () => mockRepo.signInWithEmailPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => _makeUser());
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthLoginRequested(email: 'test@test.com', password: 'password123'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (s) => s.user.email,
          'email',
          'test@test.com',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on wrong-password failure',
      build: () {
        when(
          () => mockRepo.signInWithEmailPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('[firebase_auth/wrong-password]'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthLoginRequested(email: 'test@test.com', password: 'wrong'),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  // ─── AuthRegisterRequested ───────────────────────────────────────────────────
  group('AuthRegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on successful register',
      build: () {
        when(
          () => mockRepo.registerWithEmailPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
            phone: any(named: 'phone'),
            role: any(named: 'role'),
          ),
        ).thenAnswer((_) async => _makeUser());
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AuthRegisterRequested(
          email: 'new@test.com',
          password: 'password123',
          name: 'New User',
          phone: '+7 700 000 0000',
          role: UserRole.client,
        ),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );
  });

  // ─── A3 Fix: Password reset via BLoC ─────────────────────────────────────────
  group('AuthPasswordResetRequested — A3 fix', () {
    blocTest<AuthBloc, AuthState>(
      'emits AuthPasswordResetSent on success (A3 fix — no direct repo call)',
      build: () {
        when(
          () => mockRepo.sendPasswordResetEmail(any()),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(AuthPasswordResetRequested(email: 'test@test.com')),
      expect: () => [isA<AuthPasswordResetSent>()],
      verify: (_) {
        // Verify the repository WAS called through the BLoC (not bypassed)
        verify(
          () => mockRepo.sendPasswordResetEmail('test@test.com'),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthError when sendPasswordResetEmail throws',
      build: () {
        when(
          () => mockRepo.sendPasswordResetEmail(any()),
        ).thenThrow(Exception('invalid email'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(AuthPasswordResetRequested(email: 'bad-email')),
      expect: () => [isA<AuthError>()],
    );
  });

  // ─── AuthLogoutRequested ─────────────────────────────────────────────────────
  blocTest<AuthBloc, AuthState>(
    'AuthLogoutRequested emits AuthUnauthenticated',
    build: () {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(AuthLogoutRequested()),
    expect: () => [isA<AuthUnauthenticated>()],
  );

  // ─── Worker redirect ─────────────────────────────────────────────────────────
  test('AuthAuthenticated state exposes isWorker correctly', () async {
    final workerUser = _makeUser(role: UserRole.worker);
    when(
      () => mockRepo.signInWithEmailPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => workerUser);

    final bloc = buildBloc();
    bloc.add(AuthLoginRequested(email: 'w@test.com', password: '123456'));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final state = bloc.state;
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user.isWorker, isTrue);
    bloc.close();
  });
}
