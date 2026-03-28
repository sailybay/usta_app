import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, completed, failed, refunded }

enum PaymentMethod { card, cash, wallet }

class PaymentModel {
  final String id;
  final String orderId;
  final String clientId;
  final String workerId;
  final double amount;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? stripePaymentIntentId;
  final DateTime createdAt;
  final DateTime? completedAt;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.clientId,
    required this.workerId,
    required this.amount,
    required this.status,
    required this.method,
    this.stripePaymentIntentId,
    required this.createdAt,
    this.completedAt,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      orderId: data['orderId'] ?? '',
      clientId: data['clientId'] ?? '',
      workerId: data['workerId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == (data['status'] ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == (data['method'] ?? 'cash'),
        orElse: () => PaymentMethod.cash,
      ),
      stripePaymentIntentId: data['stripePaymentIntentId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'orderId': orderId,
    'clientId': clientId,
    'workerId': workerId,
    'amount': amount,
    'status': status.name,
    'method': method.name,
    'stripePaymentIntentId': stripePaymentIntentId,
    'createdAt': Timestamp.fromDate(createdAt),
    'completedAt': completedAt != null
        ? Timestamp.fromDate(completedAt!)
        : null,
  };
}
