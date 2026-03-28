import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel {
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
  final GeoPoint? location;
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

  const OrderModel({
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
    this.location,
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

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientAvatarUrl: data['clientAvatarUrl'],
      workerId: data['workerId'] ?? '',
      workerName: data['workerName'] ?? '',
      workerAvatarUrl: data['workerAvatarUrl'],
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      serviceCategory: data['serviceCategory'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: OrderStatusExtension.fromString(data['status'] ?? 'pending'),
      address: data['address'],
      location: data['location'] as GeoPoint?,
      notes: data['notes'],
      paymentId: data['paymentId'],
      chatId: data['chatId'] ?? '',
      scheduledAt:
          (data['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      acceptedAt: (data['acceptedAt'] as Timestamp?)?.toDate(),
      startedAt: (data['startedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
      cancellationReason: data['cancellationReason'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientAvatarUrl': clientAvatarUrl,
      'workerId': workerId,
      'workerName': workerName,
      'workerAvatarUrl': workerAvatarUrl,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceCategory': serviceCategory,
      'amount': amount,
      'status': status.firestoreValue,
      'address': address,
      'location': location,
      'notes': notes,
      'paymentId': paymentId,
      'chatId': chatId,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'cancelledAt': cancelledAt != null
          ? Timestamp.fromDate(cancelledAt!)
          : null,
      'cancellationReason': cancellationReason,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
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
      status: status,
      address: address,
      latitude: location?.latitude,
      longitude: location?.longitude,
      notes: notes,
      paymentId: paymentId,
      chatId: chatId,
      scheduledAt: scheduledAt,
      createdAt: createdAt,
      acceptedAt: acceptedAt,
      startedAt: startedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
      cancellationReason: cancellationReason,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      clientId: entity.clientId,
      clientName: entity.clientName,
      clientAvatarUrl: entity.clientAvatarUrl,
      workerId: entity.workerId,
      workerName: entity.workerName,
      workerAvatarUrl: entity.workerAvatarUrl,
      serviceId: entity.serviceId,
      serviceName: entity.serviceName,
      serviceCategory: entity.serviceCategory,
      amount: entity.amount,
      status: entity.status,
      address: entity.address,
      location: (entity.latitude != null && entity.longitude != null)
          ? GeoPoint(entity.latitude!, entity.longitude!)
          : null,
      notes: entity.notes,
      paymentId: entity.paymentId,
      chatId: entity.chatId,
      scheduledAt: entity.scheduledAt,
      createdAt: entity.createdAt,
      acceptedAt: entity.acceptedAt,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      cancelledAt: entity.cancelledAt,
      cancellationReason: entity.cancellationReason,
    );
  }
}
