import '../entities/service_entity.dart';

abstract class ServiceRepositoryInterface {
  Future<List<ServiceEntity>> getServices({String? category, String? sortBy});

  Stream<List<ServiceEntity>> watchServices({String? category});

  Future<List<ServiceEntity>> getServicesByWorker(String workerId);

  Future<List<ServiceEntity>> searchServices(String query);

  Future<ServiceEntity?> getServiceById(String serviceId);

  Future<String> createService(ServiceEntity service);

  Future<void> updateService(String serviceId, Map<String, dynamic> updates);
}
