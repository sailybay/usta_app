import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usta_app/core/ai/ai_assistant_service.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/data/repositories/repositories.dart';
import 'package:usta_app/presentation/blocs/blocs.dart';

/// Корневой провайдер — настраивает все репозитории и BLoC-и для всего приложения.
class AppProviders extends StatefulWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  // ─── Repositories ──────────────────────────────────────────────────────────
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final OrderRepository _orderRepository;
  late final ServiceRepository _serviceRepository;
  late final ReviewRepository _reviewRepository;
  late final AiAssistantService _aiService;

  // ─── BLoCs ─────────────────────────────────────────────────────────────────
  late final AuthBloc _authBloc;
  late final ServiceBloc _serviceBloc;
  late final OrderBloc _orderBloc;
  late final AiBloc _aiBloc;
  late final LocaleBloc _localeBloc;

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
    // C4-fix: Wire reactive router guard to AuthBloc stream
    AppRouter.setAuthStream(_authBloc.stream);
    _serviceBloc = ServiceBloc(serviceRepository: _serviceRepository);
    _orderBloc = OrderBloc(
      orderRepository: _orderRepository,
      reviewRepository: _reviewRepository,
    );
    _aiBloc = AiBloc(aiService: _aiService);
    _localeBloc = LocaleBloc()..add(LocaleLoaded());
  }

  @override
  void dispose() {
    _authBloc.close();
    _serviceBloc.close();
    _orderBloc.close();
    _aiBloc.close();
    _localeBloc.close();
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
          BlocProvider.value(value: _localeBloc),
        ],
        child: widget.child,
      ),
    );
  }
}
