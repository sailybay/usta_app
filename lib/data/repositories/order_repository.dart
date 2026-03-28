import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository_interface.dart';

class OrderRepository implements OrderRepositoryInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Create a new order
  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    final docRef = _firestore.collection(AppConstants.ordersCollection).doc();
    final chatId = _uuid.v4();
    final newEntity = order.copyWith(
      id: docRef.id,
      chatId: chatId,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    final newOrderModel = OrderModel.fromEntity(newEntity);

    await docRef.set(newOrderModel.toFirestore());

    // Create an empty chat for this order
    await _firestore.collection(AppConstants.chatsCollection).doc(chatId).set({
      'orderId': docRef.id,
      'participantIds': [order.clientId, order.workerId],
      'lastMessage': null,
      'lastMessageAt': null,
      'unreadCount': 0,
    });

    return newEntity;
  }

  // Get single order
  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final doc = await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .get();
    if (!doc.exists) return null;
    return OrderModel.fromFirestore(doc).toEntity();
  }

  // Real-time stream for a single order
  @override
  Stream<OrderEntity?> watchOrder(String orderId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .map(
          (doc) => doc.exists ? OrderModel.fromFirestore(doc).toEntity() : null,
        );
  }

  // Get orders for client
  @override
  Stream<List<OrderEntity>> watchClientOrders(String clientId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => OrderModel.fromFirestore(d).toEntity())
              .toList(),
        )
        .handleError((e) {
          debugPrint('❌ watchClientOrders error: $e');
        });
  }

  // Get orders for worker
  @override
  Stream<List<OrderEntity>> watchWorkerOrders(String workerId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('workerId', isEqualTo: workerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => OrderModel.fromFirestore(d).toEntity())
              .toList(),
        )
        .handleError((e) {
          debugPrint('❌ watchWorkerOrders error: $e');
        });
  }

  // Get pending orders for worker (for notifications)
  @override
  Stream<List<OrderEntity>> watchPendingOrdersForWorker(String workerId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('workerId', isEqualTo: workerId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => OrderModel.fromFirestore(d).toEntity())
              .toList(),
        );
  }

  // Update order status
  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final updates = <String, dynamic>{'status': status.firestoreValue};
    final now = Timestamp.now();

    switch (status) {
      case OrderStatus.accepted:
        updates['acceptedAt'] = now;
        break;
      case OrderStatus.inProgress:
        updates['startedAt'] = now;
        break;
      case OrderStatus.completed:
        updates['completedAt'] = now;
        break;
      case OrderStatus.cancelled:
        updates['cancelledAt'] = now;
        break;
      default:
        break;
    }

    await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .update(updates);
  }

  // Cancel order with reason
  @override
  Future<void> cancelOrder(String orderId, String reason) async {
    await _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .update({
          'status': OrderStatus.cancelled.firestoreValue,
          'cancelledAt': Timestamp.now(),
          'cancellationReason': reason,
        });
  }

  // Worker income analytics
  @override
  Future<Map<String, dynamic>> getWorkerAnalytics(String workerId) async {
    final orders = await _firestore
        .collection(AppConstants.ordersCollection)
        .where('workerId', isEqualTo: workerId)
        .where('status', isEqualTo: 'completed')
        .get();

    double totalIncome = 0;
    int totalOrders = orders.docs.length;
    final Map<String, double> incomeByMonth = {};

    for (final doc in orders.docs) {
      final order = OrderModel.fromFirestore(doc);
      totalIncome += order.amount;
      final monthKey =
          '${order.completedAt?.year ?? order.createdAt.year}-${(order.completedAt?.month ?? order.createdAt.month).toString().padLeft(2, '0')}';
      incomeByMonth[monthKey] = (incomeByMonth[monthKey] ?? 0) + order.amount;
    }

    return {
      'totalIncome': totalIncome,
      'totalOrders': totalOrders,
      'incomeByMonth': incomeByMonth,
    };
  }
}
