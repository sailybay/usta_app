import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository_interface.dart';

class ServiceRepository implements ServiceRepositoryInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all active services, optionally filtered by category
  @override
  Future<List<ServiceEntity>> getServices({
    String? category,
    String? sortBy,
  }) async {
    Query query = _firestore
        .collection(AppConstants.servicesCollection)
        .where('isActive', isEqualTo: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (sortBy == 'rating') {
      query = query.orderBy('rating', descending: true);
    } else if (sortBy == 'price_asc') {
      query = query.orderBy('price', descending: false);
    } else if (sortBy == 'price_desc') {
      query = query.orderBy('price', descending: true);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    final result = await query.get();
    return result.docs
        .map((doc) => ServiceModel.fromFirestore(doc).toEntity())
        .toList();
  }

  // Real-time services stream
  @override
  Stream<List<ServiceEntity>> watchServices({String? category}) {
    Query query = _firestore
        .collection(AppConstants.servicesCollection)
        .where('isActive', isEqualTo: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    return query
        .orderBy('rating', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((doc) => ServiceModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  // Get services by worker
  @override
  Future<List<ServiceEntity>> getServicesByWorker(String workerId) async {
    final result = await _firestore
        .collection(AppConstants.servicesCollection)
        .where('workerId', isEqualTo: workerId)
        .get();
    return result.docs
        .map((doc) => ServiceModel.fromFirestore(doc).toEntity())
        .toList();
  }

  // Search services by name
  @override
  Future<List<ServiceEntity>> searchServices(String query) async {
    final lower = query.toLowerCase();
    final upper = '$lower\uf8ff';
    final result = await _firestore
        .collection(AppConstants.servicesCollection)
        .where('name', isGreaterThanOrEqualTo: lower)
        .where('name', isLessThanOrEqualTo: upper)
        .where('isActive', isEqualTo: true)
        .get();
    return result.docs
        .map((doc) => ServiceModel.fromFirestore(doc).toEntity())
        .toList();
  }

  // Get a single service
  @override
  Future<ServiceEntity?> getServiceById(String serviceId) async {
    final doc = await _firestore
        .collection(AppConstants.servicesCollection)
        .doc(serviceId)
        .get();
    if (!doc.exists) return null;
    return ServiceModel.fromFirestore(doc).toEntity();
  }

  // Create service
  @override
  Future<String> createService(ServiceEntity service) async {
    final model = ServiceModel.fromEntity(service);
    final ref = await _firestore
        .collection(AppConstants.servicesCollection)
        .add(model.toFirestore());
    return ref.id;
  }

  // Update service
  @override
  Future<void> updateService(
    String serviceId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore
        .collection(AppConstants.servicesCollection)
        .doc(serviceId)
        .update(updates);
  }
}
