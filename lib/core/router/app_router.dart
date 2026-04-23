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
import '../../presentation/screens/worker/worker_services_screen.dart';
import '../../presentation/screens/worker/worker_service_form_screen.dart';
import '../../presentation/screens/worker/worker_shell.dart';
import '../../presentation/screens/onboarding/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/map/map_screen.dart';

/// Routes that do NOT require authentication.
const _publicRoutes = {'/', '/onboarding', '/login', '/register'};

/// Routes inside the Client shell that workers must NEVER reach.
const _clientOnlyRoutes = {'/home', '/ai-chat'};

/// Routes inside the Worker shell that clients must NEVER reach.
const _workerOnlyRoutes = {'/worker-dashboard', '/worker/services'};

// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  // ── Public ───────────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // ── Client shell tabs ─────────────────────────────────────────────────────────
  static const String home = '/home';
  static const String aiChat = '/ai-chat';

  // ── Shared tabs (both shells) ─────────────────────────────────────────────────
  static const String orders = '/orders';
  static const String profile = '/profile';

  // ── Worker shell tabs ─────────────────────────────────────────────────────────
  static const String workerDashboard = '/worker-dashboard';
  static const String workerServices = '/worker/services';
  static const String workerServiceForm = '/worker/services/form';

  // ── Full-screen routes ────────────────────────────────────────────────────────
  static const String serviceDetail = '/service/:id';
  static const String createOrder = '/order/create';
  static const String orderDetail = '/order/:id';
  static const String chat = '/chat/:chatId';
  static const String map = '/map';

  // ─────────────────────────────────────────────────────────────────────────────

  static final _authListenable = _AuthBlocListenable();

  /// Wire the AuthBloc's stream into the router so redirects re-run on every
  /// auth state change (login / logout / register).
  static void setAuthStream(Stream<dynamic> stream) {
    _authListenable.setStream(stream);
  }

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: _redirect,
    refreshListenable: _authListenable,
    routes: [
      // ── Public ───────────────────────────────────────────────────────────────
      GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: register, builder: (_, __) => const RegisterScreen()),

      // ── Client shell (Home, AI Chat; Orders & Profile shared below) ───────────
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: home, builder: (_, __) => const HomeScreen()),
          GoRoute(path: aiChat, builder: (_, __) => const AiChatScreen()),
        ],
      ),

      // ── Worker shell (Dashboard, Services; Orders & Profile shared below) ─────
      ShellRoute(
        builder: (_, __, child) => WorkerShell(child: child),
        routes: [
          GoRoute(
            path: workerDashboard,
            builder: (_, __) => const WorkerDashboardScreen(),
          ),
          GoRoute(
            path: workerServices,
            builder: (_, __) => const WorkerServicesScreen(),
          ),
        ],
      ),

      // ── Shared standalone routes — rendered WITHOUT a shell nav bar ────────────
      // Both client and worker can reach /orders and /profile.
      // They appear as regular full-screen pages pushed on top of the shell.
      GoRoute(path: orders, builder: (_, __) => const OrdersScreen()),
      GoRoute(path: profile, builder: (_, __) => const ProfileScreen()),

      // ── Full-screen / modal routes ────────────────────────────────────────────
      GoRoute(
        path: serviceDetail,
        builder: (_, state) {
          final service = state.extra as ServiceEntity?;
          if (service == null) return const HomeScreen();
          return ServiceDetailScreen(service: service);
        },
      ),
      GoRoute(
        path: createOrder,
        builder: (_, state) {
          final service = state.extra as ServiceEntity?;
          if (service == null) return const HomeScreen();
          return CreateOrderScreen(service: service);
        },
      ),
      GoRoute(
        path: orderDetail,
        builder: (_, state) {
          final order = state.extra as OrderEntity?;
          if (order == null) return const OrdersScreen();
          return OrderDetailScreen(order: order);
        },
      ),
      GoRoute(
        path: chat,
        builder: (_, state) =>
            ChatScreen(chatId: state.pathParameters['chatId']!),
      ),
      GoRoute(
        path: workerServiceForm,
        builder: (_, state) =>
            WorkerServiceFormScreen(service: state.extra as ServiceEntity?),
      ),
      GoRoute(path: map, builder: (_, __) => const MapScreen()),
    ],
  );

  // ─── Auth redirect ──────────────────────────────────────────────────────────
  //
  // Rules:
  //  1. Public routes  → always pass through.
  //  2. Not logged in  → hard-redirect to /login.
  //  3. Worker on client-exclusive route (/home, /ai-chat) → /worker-dashboard.
  //  4. Client on worker-exclusive route (/worker-dashboard, /worker/services)
  //     → /home.
  //  5. Everything else → allow.
  static String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;

    if (_publicRoutes.any((p) => location == p)) return null;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return login;

    final isWorker = authState.user.isWorker;

    if (isWorker && _clientOnlyRoutes.contains(location)) {
      return workerDashboard;
    }
    if (!isWorker && _workerOnlyRoutes.contains(location)) {
      return home;
    }
    return null;
  }
}

// ─── Reactive auth notifier ──────────────────────────────────────────────────

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

// ─── Client bottom-nav shell ─────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // home=0, orders=1, ai-chat=2, profile=3
  static const _tabs = [
    AppRouter.home,
    AppRouter.orders,
    AppRouter.aiChat,
    AppRouter.profile,
  ];

  int _locationIndex(String loc) {
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (loc.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationIndex(location),
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt_rounded),
            label: l10n.navOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome_rounded),
            label: l10n.navAiHelp,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}

/// Legacy stream wrapper — kept for compatibility.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
