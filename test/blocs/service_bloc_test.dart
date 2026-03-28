// test/blocs/service_bloc_test.dart
// Tests for ServiceBloc — covers A2 fix (interface dependency) and P1 fix (search logic)
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/domain/entities/service_entity.dart';
import 'package:usta_app/domain/repositories/service_repository_interface.dart';
import 'package:usta_app/presentation/blocs/service/service_bloc.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────
class MockServiceRepository extends Mock
    implements ServiceRepositoryInterface {}

// ─── Fixtures ─────────────────────────────────────────────────────────────────
ServiceEntity _makeService({String id = '1', String category = 'Repair'}) {
  return ServiceEntity(
    id: id,
    name: 'Test Service',
    description: 'Description',
    category: category,
    price: 100,
    workerId: 'w1',
    workerName: 'Worker 1',
    isActive: true,
    createdAt: DateTime(2024),
  );
}

void main() {
  late MockServiceRepository mockRepo;

  setUp(() {
    mockRepo = MockServiceRepository();
  });

  // ─── A2 Fix: BLoC accepts interface ─────────────────────────────────────────
  test('A2 fix — ServiceBloc accepts ServiceRepositoryInterface', () {
    // Should not throw — proves the constructor accepts the interface type
    expect(() => ServiceBloc(serviceRepository: mockRepo), returnsNormally);
  });

  // ─── ServiceLoadAll ──────────────────────────────────────────────────────────
  group('ServiceLoadAll', () {
    final services = [_makeService()];

    blocTest<ServiceBloc, ServiceState>(
      'emits [ServiceLoading, ServiceLoaded] on successful stream',
      build: () {
        when(
          () => mockRepo.watchServices(category: any(named: 'category')),
        ).thenAnswer((_) => Stream.value(services));
        return ServiceBloc(serviceRepository: mockRepo);
      },
      act: (bloc) => bloc.add(ServiceLoadAll()),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceLoaded>().having((s) => s.services, 'services', services),
      ],
    );

    blocTest<ServiceBloc, ServiceState>(
      'emits [ServiceLoading, ServiceLoaded(empty)] when stream has no services',
      build: () {
        when(
          () => mockRepo.watchServices(category: any(named: 'category')),
        ).thenAnswer((_) => Stream.value([]));
        return ServiceBloc(serviceRepository: mockRepo);
      },
      act: (bloc) => bloc.add(ServiceLoadAll()),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceLoaded>().having((s) => s.services, 'services', isEmpty),
      ],
    );
  });

  // ─── ServiceSearch ───────────────────────────────────────────────────────────
  group('ServiceSearch', () {
    final results = [_makeService(id: 'search1')];

    blocTest<ServiceBloc, ServiceState>(
      'emits [ServiceLoading, ServiceLoaded] with query results',
      build: () {
        when(
          () => mockRepo.watchServices(category: any(named: 'category')),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => mockRepo.searchServices(any()),
        ).thenAnswer((_) async => results);
        return ServiceBloc(serviceRepository: mockRepo);
      },
      act: (bloc) => bloc.add(ServiceSearch('plumber')),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceLoaded>()
            .having((s) => s.services, 'services', results)
            .having((s) => s.searchQuery, 'searchQuery', 'plumber'),
      ],
    );

    blocTest<ServiceBloc, ServiceState>(
      'emits ServiceError when searchServices throws',
      build: () {
        when(
          () => mockRepo.watchServices(category: any(named: 'category')),
        ).thenAnswer((_) => Stream.value([]));
        when(() => mockRepo.searchServices(any())).thenThrow(Exception('fail'));
        return ServiceBloc(serviceRepository: mockRepo);
      },
      act: (bloc) => bloc.add(ServiceSearch('boom')),
      expect: () => [isA<ServiceLoading>(), isA<ServiceError>()],
    );

    blocTest<ServiceBloc, ServiceState>(
      'triggers ServiceLoadAll when query is empty',
      build: () {
        when(
          () => mockRepo.watchServices(category: any(named: 'category')),
        ).thenAnswer((_) => Stream.value([]));
        return ServiceBloc(serviceRepository: mockRepo);
      },
      act: (bloc) => bloc.add(ServiceSearch('')),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceLoaded>().having((s) => s.services, 'services', isEmpty),
      ],
    );
  });

  // ─── ServiceSelectCategory ───────────────────────────────────────────────────
  blocTest<ServiceBloc, ServiceState>(
    'ServiceSelectCategory triggers reload with new category',
    build: () {
      when(
        () => mockRepo.watchServices(category: any(named: 'category')),
      ).thenAnswer((_) => Stream.value([]));
      return ServiceBloc(serviceRepository: mockRepo);
    },
    act: (bloc) => bloc.add(ServiceSelectCategory('Cleaning')),
    verify: (_) {
      verify(
        () => mockRepo.watchServices(category: 'Cleaning'),
      ).called(greaterThan(0));
    },
  );

  // ─── ServiceToggleSort ───────────────────────────────────────────────────────
  blocTest<ServiceBloc, ServiceState>(
    'ServiceToggleSort triggers reload',
    build: () {
      when(
        () => mockRepo.watchServices(category: any(named: 'category')),
      ).thenAnswer((_) => Stream.value([]));
      return ServiceBloc(serviceRepository: mockRepo);
    },
    act: (bloc) => bloc.add(ServiceToggleSort('price_asc')),
    expect: () => [
      isA<ServiceLoading>(),
      isA<ServiceLoaded>().having((s) => s.services, 'services', isEmpty),
    ],
  );
}
