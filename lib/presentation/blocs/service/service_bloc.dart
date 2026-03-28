import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/service_entity.dart';
import '../../../domain/repositories/service_repository_interface.dart';

// ─── Events ───────────────────────────────────────────────────────────────────
abstract class ServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServiceLoadAll extends ServiceEvent {
  final String? category;
  final String? sortBy;
  ServiceLoadAll({this.category, this.sortBy});
  @override
  List<Object?> get props => [category, sortBy];
}

class ServiceSearch extends ServiceEvent {
  final String query;
  ServiceSearch(this.query);
  @override
  List<Object?> get props => [query];
}

class ServiceSelectCategory extends ServiceEvent {
  final String? category;
  ServiceSelectCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class ServiceToggleSort extends ServiceEvent {
  final String sortBy;
  ServiceToggleSort(this.sortBy);
  @override
  List<Object?> get props => [sortBy];
}

class ServicesUpdated extends ServiceEvent {
  final List<ServiceEntity> services;
  ServicesUpdated(this.services);
  @override
  List<Object?> get props => [services];
}

// ─── States ───────────────────────────────────────────────────────────────────
abstract class ServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<ServiceEntity> services;
  final String? selectedCategory;
  final String? sortBy;
  final String? searchQuery;
  ServiceLoaded({
    required this.services,
    this.selectedCategory,
    this.sortBy,
    this.searchQuery,
  });
  @override
  List<Object?> get props => [services, selectedCategory, sortBy, searchQuery];
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────
class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepositoryInterface _serviceRepository;
  StreamSubscription<List<ServiceEntity>>? _streamSub;
  String? _currentCategory;
  String? _currentSort;

  ServiceBloc({required ServiceRepositoryInterface serviceRepository})
    : _serviceRepository = serviceRepository,
      super(ServiceInitial()) {
    on<ServiceLoadAll>(_onLoadAll);
    on<ServiceSearch>(_onSearch);
    on<ServiceSelectCategory>(_onSelectCategory);
    on<ServiceToggleSort>(_onToggleSort);
    on<ServicesUpdated>((event, emit) {
      if (state is ServiceLoaded) {
        final s = state as ServiceLoaded;
        emit(
          ServiceLoaded(
            services: event.services,
            selectedCategory: s.selectedCategory,
            sortBy: s.sortBy,
          ),
        );
      } else {
        emit(ServiceLoaded(services: event.services));
      }
    });
  }

  Future<void> _onLoadAll(
    ServiceLoadAll event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoading());
    _currentCategory = event.category;
    _currentSort = event.sortBy;
    await _streamSub?.cancel();
    _streamSub = _serviceRepository
        .watchServices(category: event.category)
        .listen((services) => add(ServicesUpdated(services)));
  }

  Future<void> _onSearch(
    ServiceSearch event,
    Emitter<ServiceState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(ServiceLoadAll(category: _currentCategory, sortBy: _currentSort));
      return;
    }
    emit(ServiceLoading());
    try {
      final results = await _serviceRepository.searchServices(event.query);
      emit(ServiceLoaded(services: results, searchQuery: event.query));
    } catch (e) {
      emit(ServiceError('Search failed.'));
    }
  }

  Future<void> _onSelectCategory(
    ServiceSelectCategory event,
    Emitter<ServiceState> emit,
  ) async {
    _currentCategory = event.category;
    add(ServiceLoadAll(category: _currentCategory, sortBy: _currentSort));
  }

  Future<void> _onToggleSort(
    ServiceToggleSort event,
    Emitter<ServiceState> emit,
  ) async {
    _currentSort = event.sortBy;
    add(ServiceLoadAll(category: _currentCategory, sortBy: _currentSort));
  }

  @override
  Future<void> close() {
    _streamSub?.cancel();
    return super.close();
  }
}
