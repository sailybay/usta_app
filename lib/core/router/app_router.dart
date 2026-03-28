import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/service_detail_screen.dart';
import '../../presentation/screens/orders/create_order_screen.dart';
import '../../presentation/screens/orders/order_detail_screen.dart';
import '../../presentation/screens/orders/orders_screen.dart';
import '../../presentation/screens/chat/chat_screen.dart';
import '../../presentation/screens/chat/ai_chat_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/worker/worker_dashboard_screen.dart';
import '../../presentation/screens/onboarding/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/map/map_screen.dart';

/// Routes that do not require authentication
const _publicRoutes = {'/', '/onboarding', '/login', '/register'};

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String serviceDetail = '/service/:id';
  static const String createOrder = '/order/create';
  static const String orderDetail = '/order/:id';
  static const String orders = '/orders';
  static const String chat = '/chat/:chatId';
  static const String aiChat = '/ai-chat';
  static const String profile = '/profile';
  static const String workerDashboard = '/worker-dashboard';
  static const String map = '/map';

  static final _authListenable = _AuthBlocListenable();

  /// Call this once when AuthBloc is created (from AppProviders.initState)
  static void setAuthStream(Stream<dynamic> stream) {
    _authListenable.setStream(stream);
  }

  // A4-fix: Auth guard via redirect
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      if (_publicRoutes.contains(location)) return null;

      final authState = context.read<AuthBloc>().state;
      final isLoggedIn = authState is AuthAuthenticated;

      if (!isLoggedIn) return login;
      return null;
    },
    refreshListenable: _authListenable,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: home, builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: orders,
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: aiChat,
            builder: (context, state) => const AiChatScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: serviceDetail,
        builder: (context, state) {
          // A5-fix: extra is the preferred path; if it's null (e.g. after hot-restart),
          // the screen handles the null case gracefully.
          final service = state.extra as ServiceEntity?;
          if (service == null) {
            // Fallback: go home if no data available (deep-link / restart scenario)
            return const HomeScreen();
          }
          return ServiceDetailScreen(service: service);
        },
      ),
      GoRoute(
        path: createOrder,
        builder: (context, state) {
          final service = state.extra as ServiceEntity?;
          if (service == null) return const HomeScreen();
          return CreateOrderScreen(service: service);
        },
      ),
      GoRoute(
        path: orderDetail,
        builder: (context, state) {
          final order = state.extra as OrderEntity?;
          if (order == null) return const OrdersScreen();
          return OrderDetailScreen(order: order);
        },
      ),
      GoRoute(
        path: chat,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          return ChatScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: workerDashboard,
        builder: (context, state) => const WorkerDashboardScreen(),
      ),
      GoRoute(path: map, builder: (context, state) => const MapScreen()),
    ],
  );
}

/// C4-fix: Reactive auth guard. AppProviders wires AuthBloc.stream into this
/// via [AppRouter.setAuthStream]. When the stream emits (login/logout/register),
/// GoRouter re-evaluates its redirect function and sends the user to the right place.
class _AuthBlocListenable extends ChangeNotifier {
  StreamSubscription<dynamic>? _sub;

  void setStream(Stream<dynamic> stream) {
    _sub?.cancel();
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Bottom navigation shell widget
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _tabs = [
    AppRouter.home,
    AppRouter.orders,
    AppRouter.aiChat,
    AppRouter.profile,
  ];

  int _locationToIndex(String location) {
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(_tabs[index]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context).navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: AppLocalizations.of(context).navOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome),
            label: AppLocalizations.of(context).navAiHelp,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context).navProfile,
          ),
        ],
      ),
    );
  }
}

/// C4-fix: Wraps the AuthBloc stream so GoRouter reacts to every auth change.
/// The old empty ChangeNotifier never called notifyListeners(), so logout
/// didn’t trigger redirect. This implementation does.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
