// test/blocs/worker_service_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/domain/entities/service_entity.dart';
import 'package:usta_app/domain/repositories/service_repository_interface.dart';
import 'package:usta_app/presentation/blocs/service/worker_service_bloc.dart';

class MockServiceRepository extends Mock
    implements ServiceRepositoryInterface {}

void main() {
  late MockServiceRepository mockRepo;

  final testService = ServiceEntity(
    id: 's1',
    name: 'Repair',
    description: 'Fix things',
    category: 'Repair',
    price: 150.0,
    workerId: 'w1',
    workerName: 'Master',
    isActive: true,
    createdAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockServiceRepository();
    registerFallbackValue(testService);
  });

  WorkerServiceBloc buildBloc() =>
      WorkerServiceBloc(serviceRepository: mockRepo);

  group('WorkerServiceBloc', () {
    blocTest<WorkerServiceBloc, WorkerServiceState>(
      'loads services for worker',
      build: () {
        when(
          () => mockRepo.getServicesByWorker('w1'),
        ).thenAnswer((_) async => [testService]);
        return buildBloc();
      },
      act: (bloc) => bloc.add(WorkerServiceLoad('w1')),
      expect: () => [
        isA<WorkerServiceLoading>(),
        isA<WorkerServiceLoaded>().having(
          (s) => s.services.length,
          'length',
          1,
        ),
      ],
    );

    blocTest<WorkerServiceBloc, WorkerServiceState>(
      'creates service and emits action success',
      build: () {
        when(() => mockRepo.createService(any())).thenAnswer((_) async => 's1');
        when(
          () => mockRepo.getServicesByWorker('w1'),
        ).thenAnswer((_) async => [testService]);
        return buildBloc();
      },
      act: (bloc) {
        bloc.add(WorkerServiceLoad('w1')); // Set workerId
        bloc.add(WorkerServiceCreate(testService));
      },
      skip: 0,
      expect: () => [
        isA<WorkerServiceLoading>(),
        isA<WorkerServiceLoaded>(),
        isA<WorkerServiceActionSuccess>(),
      ],
    );

    blocTest<WorkerServiceBloc, WorkerServiceState>(
      'deletes service (soft delete) and emits action success',
      build: () {
        when(
          () => mockRepo.updateService(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockRepo.getServicesByWorker('w1'),
        ).thenAnswer((_) async => []);
        return buildBloc();
      },
      act: (bloc) {
        bloc.add(WorkerServiceLoad('w1'));
        bloc.add(WorkerServiceDelete('s1'));
      },
      skip: 0,
      expect: () => [
        isA<WorkerServiceLoading>(),
        isA<WorkerServiceLoaded>(),
        isA<WorkerServiceActionSuccess>(),
      ],
    );
  });
}
