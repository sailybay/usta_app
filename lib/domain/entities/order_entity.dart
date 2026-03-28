import 'package:equatable/equatable.dart';

enum OrderStatus { pending, accepted, inProgress, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get firestoreValue {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.inProgress:
        return 'in_progress';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'in_progress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

class OrderEntity extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String? clientAvatarUrl;
  final String workerId;
  final String workerName;
  final String? workerAvatarUrl;
  final String serviceId;
  final String serviceName;
  final String serviceCategory;
  final double amount;
  final OrderStatus status;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final String? paymentId;
  final String chatId;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  const OrderEntity({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientAvatarUrl,
    required this.workerId,
    required this.workerName,
    this.workerAvatarUrl,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCategory,
    required this.amount,
    required this.status,
    this.address,
    this.latitude,
    this.longitude,
    this.notes,
    this.paymentId,
    required this.chatId,
    required this.scheduledAt,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  OrderEntity copyWith({
    String? id,
    String? chatId,
    DateTime? createdAt,
    OrderStatus? status,
    String? paymentId,
    String? cancellationReason,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      clientId: clientId,
      clientName: clientName,
      clientAvatarUrl: clientAvatarUrl,
      workerId: workerId,
      workerName: workerName,
      workerAvatarUrl: workerAvatarUrl,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceCategory: serviceCategory,
      amount: amount,
      status: status ?? this.status,
      address: address,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      paymentId: paymentId ?? this.paymentId,
      chatId: chatId ?? this.chatId,
      scheduledAt: scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    clientAvatarUrl,
    workerId,
    workerName,
    workerAvatarUrl,
    serviceId,
    serviceName,
    serviceCategory,
    amount,
    status,
    address,
    latitude,
    longitude,
    notes,
    paymentId,
    chatId,
    scheduledAt,
    createdAt,
    acceptedAt,
    startedAt,
    completedAt,
    cancelledAt,
    cancellationReason,
  ];
}
