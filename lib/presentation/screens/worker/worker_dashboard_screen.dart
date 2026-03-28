import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/data/repositories/order_repository.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/blocs.dart';
import 'widgets/worker_widgets.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  Map<String, dynamic> _analytics = {};
  bool _loadingAnalytics = true;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrderBloc>().add(OrderLoadWorkerOrders(authState.user.id));
      _loadAnalytics(authState.user.id);
      context.read<AiBloc>().add(
        AiGetWorkerSuggestion(
          completedOrders: 0,
          rating: authState.user.rating,
          totalIncome: 0,
        ),
      );
    }
  }

  Future<void> _loadAnalytics(String workerId) async {
    final repo = OrderRepository();
    final data = await repo.getWorkerAnalytics(workerId);
    if (!mounted) return;
    setState(() {
      _analytics = data;
      _loadingAnalytics = false;
    });
    context.read<AiBloc>().add(
      AiGetWorkerSuggestion(
        completedOrders: data['totalOrders'] ?? 0,
        rating:
            (context.read<AuthBloc>().state as AuthAuthenticated).user.rating,
        totalIncome: data['totalIncome'] ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.workerDashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => context.go(AppRouter.profile),
          ),
        ],
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listenWhen: (_, current) =>
            current is OrderActionSuccess || current is OrderError,
        listener: (context, state) {
          if (state is OrderActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Refresh list after status change
            context.read<OrderBloc>().add(OrderLoadWorkerOrders(user.id));
          }
        },
        child: RefreshIndicator(
          onRefresh: () => _loadAnalytics(user.id),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user.name, l10n),
                const SizedBox(height: 20),
                _buildStats(context, l10n),
                const SizedBox(height: 20),
                if (!_loadingAnalytics &&
                    (_analytics['incomeByMonth'] as Map? ?? {}).isNotEmpty)
                  _buildIncomeChart(context, l10n),
                const SizedBox(height: 20),
                _buildAiSuggestion(context, l10n),
                const SizedBox(height: 20),
                Text(
                  l10n.workerPendingOrders,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _buildActiveOrders(l10n),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    String name,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.workerGreeting(name),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.workerOverview,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, AppLocalizations l10n) {
    if (_loadingAnalytics) {
      return const Center(child: CircularProgressIndicator());
    }
    return Row(
      children: [
        DashboardStatCard(
          label: l10n.workerTotalIncome,
          value: '${(_analytics['totalIncome'] ?? 0).toStringAsFixed(0)} ₸',
          icon: Icons.attach_money_rounded,
          gradient: AppColors.successGradient,
        ),
        const SizedBox(width: 12),
        DashboardStatCard(
          label: l10n.workerCompleted,
          value: (_analytics['totalOrders'] ?? 0).toString(),
          icon: Icons.check_circle_rounded,
          gradient: AppColors.primaryGradient,
        ),
      ],
    );
  }

  Widget _buildIncomeChart(BuildContext context, AppLocalizations l10n) {
    final incomeByMonth = _analytics['incomeByMonth'] as Map<String, double>;
    final sortedKeys = incomeByMonth.keys.toList()..sort();
    final spots = <FlSpot>[
      for (int i = 0; i < sortedKeys.length; i++)
        FlSpot(i.toDouble(), incomeByMonth[sortedKeys[i]]!),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.workerIncomeChart,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiSuggestion(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<AiBloc, AiState>(
      builder: (context, state) {
        final aiMessages = state.messages.where((m) => !m.isUser).toList();
        if (aiMessages.isEmpty) return const SizedBox();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.workerAiSuggestion,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                aiMessages.last.content,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push(AppRouter.aiChat),
                child: Text(
                  l10n.workerAskAi,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows ALL active orders (pending + accepted + inProgress) so worker can act on them
  Widget _buildActiveOrders(AppLocalizations l10n) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is! OrdersLoaded) return const SizedBox();

        final activeOrders = state.orders
            .where(
              (o) =>
                  o.status == OrderStatus.pending ||
                  o.status == OrderStatus.accepted ||
                  o.status == OrderStatus.inProgress,
            )
            .toList();

        if (activeOrders.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                l10n.workerNoPending,
                style: const TextStyle(color: AppColors.textHint),
              ),
            ),
          );
        }

        return Column(
          children: activeOrders
              .map((o) => PendingOrderCard(order: o))
              .toList(),
        );
      },
    );
  }
}
