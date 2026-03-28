import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../presentation/blocs/ai/ai_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/order/order_bloc.dart';
import '../../presentation/blocs/service/service_bloc.dart';
import '../ai/ai_assistant_service.dart';

class AppProviders extends StatefulWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final OrderRepository _orderRepository;
  late final ServiceRepository _serviceRepository;
  late final ReviewRepository _reviewRepository;
  late final AiAssistantService _aiService;

  late final AuthBloc _authBloc;
  late final ServiceBloc _serviceBloc;
  late final OrderBloc _orderBloc;
  late final AiBloc _aiBloc;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _userRepository = UserRepository();
    _orderRepository = OrderRepository();
    _serviceRepository = ServiceRepository();
    _reviewRepository = ReviewRepository();
    _aiService = AiAssistantService();

    _authBloc = AuthBloc(authRepository: _authRepository)
      ..add(AuthCheckRequested());
    _serviceBloc = ServiceBloc(serviceRepository: _serviceRepository);
    _orderBloc = OrderBloc(
      orderRepository: _orderRepository,
      reviewRepository: _reviewRepository,
    );
    _aiBloc = AiBloc(aiService: _aiService);
  }

  @override
  void dispose() {
    _authBloc.close();
    _serviceBloc.close();
    _orderBloc.close();
    _aiBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _orderRepository),
        RepositoryProvider.value(value: _serviceRepository),
        RepositoryProvider.value(value: _reviewRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authBloc),
          BlocProvider.value(value: _serviceBloc),
          BlocProvider.value(value: _orderBloc),
          BlocProvider.value(value: _aiBloc),
        ],
        child: widget.child,
      ),
    );
  }
}
