// test/blocs/order_bloc_test.dart
// Tests for OrderBloc — covers A1 fix (ReviewEntity) and A2 fix (interface dependency)
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/domain/entities/review_entity.dart';
import 'package:usta_app/domain/repositories/order_repository_interface.dart';
import 'package:usta_app/data/repositories/review_repository.dart';
import 'package:usta_app/presentation/blocs/order/order_bloc.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────
class MockOrderRepository extends Mock implements OrderRepositoryInterface {}

class MockReviewRepository extends Mock implements ReviewRepository {}

// ─── Fixtures ─────────────────────────────────────────────────────────────────
OrderEntity _makeOrder({
  String id = 'o1',
  OrderStatus status = OrderStatus.pending,
}) {
  return OrderEntity(
    id: id,
    clientId: 'c1',
    clientName: 'Client',
    workerId: 'w1',
    workerName: 'Worker',
    serviceId: 's1',
    serviceName: 'Service',
    serviceCategory: 'Repair',
    amount: 200,
    status: status,
    chatId: 'chat1',
    scheduledAt: DateTime(2025, 6, 1),
    createdAt: DateTime(2025, 5, 1),
  );
}

ReviewEntity _makeReview() {
  return ReviewEntity(
    id: '',
    orderId: 'o1',
    clientId: 'c1',
    clientName: 'Client',
    workerId: 'w1',
    rating: 5.0,
    comment: 'Great!',
    createdAt: DateTime(2025, 6, 2),
  );
}

void main() {
  late MockOrderRepository mockOrderRepo;
  late MockReviewRepository mockReviewRepo;

  setUp(() {
    mockOrderRepo = MockOrderRepository();
    mockReviewRepo = MockReviewRepository();
    // Fallback for any OrderEntity argument
    registerFallbackValue(_makeOrder());
    registerFallbackValue(OrderStatus.pending);
    registerFallbackValue(_makeReview());
  });

  OrderBloc buildBloc() => OrderBloc(
    orderRepository: mockOrderRepo,
    reviewRepository: mockReviewRepo,
  );

  // ─── A2 Fix: BLoC accepts interface ─────────────────────────────────────────
  test('A2 fix — OrderBloc accepts OrderRepositoryInterface', () {
    expect(() => buildBloc(), returnsNormally);
  });

  // ─── OrderLoadClientOrders ───────────────────────────────────────────────────
  group('OrderLoadClientOrders', () {
    final orders = [_makeOrder()];

    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrdersLoaded] on stream data',
      build: () {
        when(
          () => mockOrderRepo.watchClientOrders(any()),
        ).thenAnswer((_) => Stream.value(orders));
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderLoadClientOrders('c1')),
      expect: () => [
        isA<OrderLoading>(),
        isA<OrdersLoaded>().having((s) => s.orders, 'orders', orders),
      ],
    );
  });

  // ─── OrderCreate ─────────────────────────────────────────────────────────────
  group('OrderCreate', () {
    final order = _makeOrder();

    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrderCreated] on success',
      build: () {
        when(
          () => mockOrderRepo.createOrder(any()),
        ).thenAnswer((_) async => order);
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderCreate(order)),
      expect: () => [
        isA<OrderLoading>(),
        isA<OrderCreated>().having((s) => s.order, 'order', order),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderLoading, OrderError] when createOrder throws',
      build: () {
        when(
          () => mockOrderRepo.createOrder(any()),
        ).thenThrow(Exception('network error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderCreate(order)),
      expect: () => [isA<OrderLoading>(), isA<OrderError>()],
    );
  });

  // ─── OrderCancel ─────────────────────────────────────────────────────────────
  group('OrderCancel', () {
    blocTest<OrderBloc, OrderState>(
      'emits OrderActionSuccess on successful cancel',
      build: () {
        when(
          () => mockOrderRepo.cancelOrder(any(), any()),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderCancel('o1', 'Changed mind')),
      expect: () => [isA<OrderActionSuccess>()],
    );

    blocTest<OrderBloc, OrderState>(
      'emits OrderError when cancelOrder throws',
      build: () {
        when(
          () => mockOrderRepo.cancelOrder(any(), any()),
        ).thenThrow(Exception('fail'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderCancel('o1', 'reason')),
      expect: () => [isA<OrderError>()],
    );
  });

  // ─── OrderUpdateStatus ───────────────────────────────────────────────────────
  group('OrderUpdateStatus', () {
    blocTest<OrderBloc, OrderState>(
      'emits OrderActionSuccess on successful update',
      build: () {
        when(
          () => mockOrderRepo.updateOrderStatus(any(), any()),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(OrderUpdateStatus('o1', OrderStatus.accepted)),
      expect: () => [isA<OrderActionSuccess>()],
    );
  });

  // ─── A1 Fix: OrderSubmitReview uses ReviewEntity ─────────────────────────────
  group('OrderSubmitReview — A1 fix', () {
    final review = _makeReview();

    blocTest<OrderBloc, OrderState>(
      'accepts ReviewEntity (not ReviewModel) — A1 fix',
      build: () {
        when(
          () => mockReviewRepo.createReview(any()),
        ).thenAnswer((_) async => 'rev1');
        when(
          () => mockReviewRepo.getWorkerReviews(any()),
        ).thenAnswer((_) async => [review]);
        when(
          () => mockReviewRepo.updateWorkerRating(any(), any()),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(OrderSubmitReview(review: review, workerId: 'w1')),
      expect: () => [isA<OrderActionSuccess>()],
    );

    blocTest<OrderBloc, OrderState>(
      'emits OrderError when createReview throws',
      build: () {
        when(
          () => mockReviewRepo.createReview(any()),
        ).thenThrow(Exception('review failed'));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(OrderSubmitReview(review: review, workerId: 'w1')),
      expect: () => [isA<OrderError>()],
    );
  });
}
