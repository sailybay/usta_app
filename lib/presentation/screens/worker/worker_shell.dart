import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/l10n/app_localizations.dart';

/// Bottom-navigation shell for worker/specialist users.
///
/// Tabs: Dashboard (0) · Services (1) · Orders (2) · Profile (3)
///
/// /orders and /profile are standalone routes (not inside this ShellRoute),
/// so they are opened as full-screen pages without the worker nav bar.
/// That's fine for a diploma-grade app — the back button returns to the shell.
class WorkerShell extends StatelessWidget {
  final Widget child;
  const WorkerShell({super.key, required this.child});

  static const _tabs = [
    AppRouter.workerDashboard,
    AppRouter.workerServices,
    AppRouter.orders,
    AppRouter.profile,
  ];

  int _locationIndex(String location) {
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationIndex(location),
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: l10n.navWorkerDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.home_repair_service_outlined),
            selectedIcon: const Icon(Icons.home_repair_service_rounded),
            label: l10n.navWorkerServices,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt_rounded),
            label: l10n.navOrders,
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
