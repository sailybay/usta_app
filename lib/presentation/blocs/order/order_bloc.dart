import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../domain/repositories/order_repository_interface.dart';
import '../../../domain/repositories/review_repository_interface.dart';

// ─── Events ───────────────────────────────────────────────────────────────────
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderLoadClientOrders extends OrderEvent {
  final String clientId;
  OrderLoadClientOrders(this.clientId);
  @override
  List<Object?> get props => [clientId];
}

class OrderLoadWorkerOrders extends OrderEvent {
  final String workerId;
  OrderLoadWorkerOrders(this.workerId);
  @override
  List<Object?> get props => [workerId];
}

class OrderCreate extends OrderEvent {
  final OrderEntity order;
  OrderCreate(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderUpdateStatus extends OrderEvent {
  final String orderId;
  final OrderStatus status;
  OrderUpdateStatus(this.orderId, this.status);
  @override
  List<Object?> get props => [orderId, status];
}

class OrderCancel extends OrderEvent {
  final String orderId;
  final String reason;
  OrderCancel(this.orderId, this.reason);
  @override
  List<Object?> get props => [orderId, reason];
}

/// A1-fix: OrderSubmitReview now uses ReviewEntity (domain layer) instead of ReviewModel (data layer)
class OrderSubmitReview extends OrderEvent {
  final ReviewEntity review;
  final String workerId;
  OrderSubmitReview({required this.review, required this.workerId});
  @override
  List<Object?> get props => [review];
}

class OrdersUpdated extends OrderEvent {
  final List<OrderEntity> orders;
  OrdersUpdated(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrderLoadPublicOrders extends OrderEvent {
  final String? category;
  OrderLoadPublicOrders({this.category});
  @override
  List<Object?> get props => [category];
}

class OrderAccept extends OrderEvent {
  final String orderId;
  final String workerId;
  final String workerName;
  final String? workerAvatarUrl;
  OrderAccept({
    required this.orderId,
    required this.workerId,
    required this.workerName,
    this.workerAvatarUrl,
  });
  @override
  List<Object?> get props => [orderId, workerId];
}

class OrderReset extends OrderEvent {}

// ─── States ───────────────────────────────────────────────────────────────────
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrderCreated extends OrderState {
  final OrderEntity order;
  OrderCreated(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderActionSuccess extends OrderState {
  final String message;
  OrderActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

/// A2-fix: Depends on OrderRepositoryInterface (not concrete OrderRepository)
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepositoryInterface _orderRepository;
  final ReviewRepositoryInterface _reviewRepository;
  StreamSubscription<List<OrderEntity>>? _orderSubscription;

  OrderBloc({
    required OrderRepositoryInterface orderRepository,
    required ReviewRepositoryInterface reviewRepository,
  }) : _orderRepository = orderRepository,
       _reviewRepository = reviewRepository,
       super(OrderInitial()) {
    on<OrderLoadClientOrders>(_onLoadClientOrders);
    on<OrderLoadWorkerOrders>(_onLoadWorkerOrders);
    on<OrderCreate>(_onCreateOrder);
    on<OrderUpdateStatus>(_onUpdateStatus);
    on<OrderCancel>(_onCancelOrder);
    on<OrderSubmitReview>(_onSubmitReview);
    on<OrderLoadPublicOrders>(_onLoadPublicOrders);
    on<OrderAccept>(_onAcceptOrder);
    on<OrdersUpdated>((event, emit) => emit(OrdersLoaded(event.orders)));
    on<OrderReset>((event, emit) {
      _orderSubscription?.cancel();
      emit(OrderInitial());
    });
  }

  Future<void> _onLoadClientOrders(
    OrderLoadClientOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    _orderSubscription = _orderRepository
        .watchClientOrders(event.clientId)
        .listen(
          (orders) => add(OrdersUpdated(orders)),
          onError: (e) => add(OrderReset()),
        );
  }

  Future<void> _onLoadWorkerOrders(
    OrderLoadWorkerOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    _orderSubscription = _orderRepository
        .watchWorkerOrders(event.workerId)
        .listen(
          (orders) => add(OrdersUpdated(orders)),
          onError: (e) => add(OrderReset()),
        );
  }

  Future<void> _onCreateOrder(
    OrderCreate event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final created = await _orderRepository.createOrder(event.order);
      emit(OrderCreated(created));
    } catch (e) {
      emit(OrderError('Failed to create order. Please try again.'));
    }
  }

  Future<void> _onUpdateStatus(
    OrderUpdateStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _orderRepository.updateOrderStatus(event.orderId, event.status);
      emit(OrderActionSuccess('Order status updated.'));
    } catch (e) {
      emit(OrderError('Failed to update order.'));
    }
  }

  Future<void> _onCancelOrder(
    OrderCancel event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _orderRepository.cancelOrder(event.orderId, event.reason);
      emit(OrderActionSuccess('Order cancelled.'));
    } catch (e) {
      emit(OrderError('Failed to cancel order.'));
    }
  }

  Future<void> _onSubmitReview(
    OrderSubmitReview event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _reviewRepository.createReview(event.review);
      // Recalculate and persist worker rating
      final reviews = await _reviewRepository.getWorkerReviews(event.workerId);
      final avgRating = reviews.isEmpty
          ? 0.0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length;
      await _reviewRepository.updateWorkerRating(event.workerId, avgRating);
      emit(OrderActionSuccess('Review submitted. Thank you!'));
    } catch (e) {
      emit(OrderError('Failed to submit review.'));
    }
  }

  Future<void> _onAcceptOrder(
    OrderAccept event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _orderRepository.acceptOrder(
        event.orderId,
        event.workerId,
        event.workerName,
        event.workerAvatarUrl,
      );
      emit(OrderActionSuccess('Order accepted! You are now the provider.'));
    } catch (e) {
      emit(OrderError('Failed to accept order.'));
    }
  }

  Future<void> _onLoadPublicOrders(
    OrderLoadPublicOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    await _orderSubscription?.cancel();
    _orderSubscription = _orderRepository
        .watchPublicOrders(category: event.category)
        .listen(
          (orders) => add(OrdersUpdated(orders)),
          onError: (e) => add(OrderReset()),
        );
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}
