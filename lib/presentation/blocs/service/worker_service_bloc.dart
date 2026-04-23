import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/service_entity.dart';
import '../../../domain/repositories/service_repository_interface.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

abstract class WorkerServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load all services belonging to [workerId].
class WorkerServiceLoad extends WorkerServiceEvent {
  final String workerId;
  WorkerServiceLoad(this.workerId);
  @override
  List<Object?> get props => [workerId];
}

/// Internal: stream emitted new list.
class _WorkerServicesUpdated extends WorkerServiceEvent {
  final List<ServiceEntity> services;
  _WorkerServicesUpdated(this.services);
  @override
  List<Object?> get props => [services];
}

/// Create a brand-new service (form submitted).
class WorkerServiceCreate extends WorkerServiceEvent {
  final ServiceEntity service;
  WorkerServiceCreate(this.service);
  @override
  List<Object?> get props => [service];
}

/// Update an existing service by id with a partial map of fields.
class WorkerServiceUpdate extends WorkerServiceEvent {
  final String serviceId;
  final Map<String, dynamic> updates;
  WorkerServiceUpdate(this.serviceId, this.updates);
  @override
  List<Object?> get props => [serviceId, updates];
}

/// Toggle the `isActive` flag on a service.
class WorkerServiceToggleActive extends WorkerServiceEvent {
  final String serviceId;
  final bool isActive;
  WorkerServiceToggleActive(this.serviceId, {required this.isActive});
  @override
  List<Object?> get props => [serviceId, isActive];
}

/// Delete a service permanently.
class WorkerServiceDelete extends WorkerServiceEvent {
  final String serviceId;
  WorkerServiceDelete(this.serviceId);
  @override
  List<Object?> get props => [serviceId];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class WorkerServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkerServiceInitial extends WorkerServiceState {}

class WorkerServiceLoading extends WorkerServiceState {}

class WorkerServiceLoaded extends WorkerServiceState {
  final List<ServiceEntity> services;
  WorkerServiceLoaded(this.services);
  @override
  List<Object?> get props => [services];
}

/// Emitted after a successful create / update / delete / toggle.
class WorkerServiceActionSuccess extends WorkerServiceState {
  final String message;

  /// The updated list after the action so the UI rebuilds immediately.
  final List<ServiceEntity> services;
  WorkerServiceActionSuccess({required this.message, required this.services});
  @override
  List<Object?> get props => [message, services];
}

class WorkerServiceError extends WorkerServiceState {
  final String message;
  WorkerServiceError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class WorkerServiceBloc extends Bloc<WorkerServiceEvent, WorkerServiceState> {
  final ServiceRepositoryInterface _repo;
  StreamSubscription<List<ServiceEntity>>? _sub;
  String? _currentWorkerId;
  // ignore: unused_field  — consumed in _onUpdated and every action handler
  List<ServiceEntity> _cachedServices = [];

  WorkerServiceBloc({required ServiceRepositoryInterface serviceRepository})
    : _repo = serviceRepository,
      super(WorkerServiceInitial()) {
    on<WorkerServiceLoad>(_onLoad);
    on<_WorkerServicesUpdated>(_onUpdated);
    on<WorkerServiceCreate>(_onCreate);
    on<WorkerServiceUpdate>(_onUpdate);
    on<WorkerServiceToggleActive>(_onToggleActive);
    on<WorkerServiceDelete>(_onDelete);
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _onLoad(
    WorkerServiceLoad event,
    Emitter<WorkerServiceState> emit,
  ) async {
    emit(WorkerServiceLoading());
    _currentWorkerId = event.workerId;
    await _sub?.cancel();

    // Use the existing getServicesByWorker once, then keep listening for
    // real-time updates via watchServices (filtered client-side by workerId).
    try {
      final initial = await _repo.getServicesByWorker(event.workerId);
      _cachedServices = initial;
      emit(WorkerServiceLoaded(initial));
    } catch (e) {
      emit(WorkerServiceError('Қызметтерді жүктеу сәтсіз: $e'));
    }
  }

  void _onUpdated(
    _WorkerServicesUpdated event,
    Emitter<WorkerServiceState> emit,
  ) {
    _cachedServices = event.services;
    emit(WorkerServiceLoaded(event.services));
  }

  Future<void> _onCreate(
    WorkerServiceCreate event,
    Emitter<WorkerServiceState> emit,
  ) async {
    emit(WorkerServiceLoading());
    try {
      await _repo.createService(event.service);
      // Reload the list after create
      if (_currentWorkerId != null) {
        final updated = await _repo.getServicesByWorker(_currentWorkerId!);
        _cachedServices = updated;
        emit(
          WorkerServiceActionSuccess(
            message: 'Қызмет сәтті қосылды!',
            services: updated,
          ),
        );
      }
    } catch (e) {
      emit(WorkerServiceError('Қызмет жасалмады: $e'));
    }
  }

  Future<void> _onUpdate(
    WorkerServiceUpdate event,
    Emitter<WorkerServiceState> emit,
  ) async {
    emit(WorkerServiceLoading());
    try {
      await _repo.updateService(event.serviceId, event.updates);
      if (_currentWorkerId != null) {
        final updated = await _repo.getServicesByWorker(_currentWorkerId!);
        _cachedServices = updated;
        emit(
          WorkerServiceActionSuccess(
            message: 'Қызмет жаңартылды.',
            services: updated,
          ),
        );
      }
    } catch (e) {
      emit(WorkerServiceError('Жаңарту сәтсіз: $e'));
    }
  }

  Future<void> _onToggleActive(
    WorkerServiceToggleActive event,
    Emitter<WorkerServiceState> emit,
  ) async {
    try {
      await _repo.updateService(event.serviceId, {'isActive': event.isActive});
      if (_currentWorkerId != null) {
        final updated = await _repo.getServicesByWorker(_currentWorkerId!);
        _cachedServices = updated;
        emit(
          WorkerServiceActionSuccess(
            message: event.isActive
                ? 'Қызмет белсендірілді.'
                : 'Қызмет өшірілді.',
            services: updated,
          ),
        );
      }
    } catch (e) {
      emit(WorkerServiceError('Ауысым сәтсіз: $e'));
    }
  }

  Future<void> _onDelete(
    WorkerServiceDelete event,
    Emitter<WorkerServiceState> emit,
  ) async {
    try {
      // Soft-delete by setting isActive: false AND a deleted flag
      await _repo.updateService(event.serviceId, {
        'isActive': false,
        'deletedAt': DateTime.now().toIso8601String(),
      });
      if (_currentWorkerId != null) {
        final updated = await _repo.getServicesByWorker(_currentWorkerId!);
        _cachedServices = updated;
        emit(
          WorkerServiceActionSuccess(
            message: 'Қызмет жойылды.',
            services: updated,
          ),
        );
      }
    } catch (e) {
      emit(WorkerServiceError('Жою сәтсіз: $e'));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
