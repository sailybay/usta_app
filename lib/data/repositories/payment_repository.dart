import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';
import '../../core/constants/app_constants.dart';

class PaymentRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final ref = await _firestore
        .collection(AppConstants.paymentsCollection)
        .add(payment.toFirestore());
    final doc = await ref.get();
    return PaymentModel.fromFirestore(doc);
  }

  Future<void> updatePaymentStatus(
    String paymentId,
    PaymentStatus status,
  ) async {
    await _firestore
        .collection(AppConstants.paymentsCollection)
        .doc(paymentId)
        .update({'status': status.name});
  }

  Future<PaymentModel?> getPaymentByOrderId(String orderId) async {
    final result = await _firestore
        .collection(AppConstants.paymentsCollection)
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .get();
    if (result.docs.isEmpty) return null;
    return PaymentModel.fromFirestore(result.docs.first);
  }
}
