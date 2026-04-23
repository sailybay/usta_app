import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:usta_app/presentation/blocs/service/worker_service_bloc.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'widgets/worker_service_card.dart';

/// Screen listing all services belonging to the current worker.
/// Accessed via the Worker Shell's "Services" tab.
class WorkerServicesScreen extends StatefulWidget {
  const WorkerServicesScreen({super.key});

  @override
  State<WorkerServicesScreen> createState() => _WorkerServicesScreenState();
}

class _WorkerServicesScreenState extends State<WorkerServicesScreen> {
  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<WorkerServiceBloc>().add(
        WorkerServiceLoad(authState.user.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<WorkerServiceBloc, WorkerServiceState>(
      listenWhen: (_, s) =>
          s is WorkerServiceActionSuccess || s is WorkerServiceError,
      listener: (context, state) {
        if (state is WorkerServiceActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is WorkerServiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.workerServicesTitle),
          centerTitle: false,
          actions: [
            TextButton.icon(
              onPressed: () => context
                  .push(AppRouter.workerServiceForm)
                  .then((_) => _loadServices()),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(l10n.workerServicesAdd),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<WorkerServiceBloc, WorkerServiceState>(
          builder: (context, state) {
            if (state is WorkerServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WorkerServiceError) {
              return _ErrorView(message: state.message, onRetry: _loadServices);
            }

            final services = switch (state) {
              WorkerServiceLoaded s => s.services,
              WorkerServiceActionSuccess s => s.services,
              _ => const <dynamic>[],
            };

            if (services.isEmpty) {
              return _EmptyServicesView(
                l10n: l10n,
                onAdd: () => context
                    .push(AppRouter.workerServiceForm)
                    .then((_) => _loadServices()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadServices(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                itemCount: services.length,
                itemBuilder: (context, i) {
                  final service = services[i];
                  return WorkerServiceCard(
                    service: service,
                    onEdit: () => context
                        .push(AppRouter.workerServiceForm, extra: service)
                        .then((_) => _loadServices()),
                    onToggleActive: (val) =>
                        context.read<WorkerServiceBloc>().add(
                          WorkerServiceToggleActive(service.id, isActive: val),
                        ),
                    onDelete: () => context.read<WorkerServiceBloc>().add(
                      WorkerServiceDelete(service.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context
              .push(AppRouter.workerServiceForm)
              .then((_) => _loadServices()),
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.workerServicesAdd),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _EmptyServicesView extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onAdd;
  const _EmptyServicesView({required this.l10n, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.home_repair_service_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.workerServicesEmpty,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.workerServicesEmptySubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.workerServicesAdd),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context).errorRetry),
            ),
          ],
        ),
      ),
    );
  }
}
