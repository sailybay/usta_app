import '../entities/order_entity.dart';

abstract class OrderRepositoryInterface {
  Future<OrderEntity> createOrder(OrderEntity order);
  Future<OrderEntity?> getOrderById(String orderId);
  Stream<OrderEntity?> watchOrder(String orderId);
  Stream<List<OrderEntity>> watchClientOrders(String clientId);
  Stream<List<OrderEntity>> watchWorkerOrders(String workerId);
  Stream<List<OrderEntity>> watchPendingOrdersForWorker(String workerId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<void> cancelOrder(String orderId, String reason);
  Future<Map<String, dynamic>> getWorkerAnalytics(String workerId);
}
