import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/data/repositories/order_repository.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
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
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => context.go(AppRouter.profile),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadAnalytics(user.id),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user.name),
              const SizedBox(height: 20),
              _buildStats(context),
              const SizedBox(height: 20),
              if (!_loadingAnalytics &&
                  (_analytics['incomeByMonth'] as Map? ?? {}).isNotEmpty)
                _buildIncomeChart(context),
              const SizedBox(height: 20),
              _buildAiSuggestion(context),
              const SizedBox(height: 20),
              Text(
                'Ожидающие заказы',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildPendingOrders(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Section builders ──────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сәлем, $name! 👋',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Жұмыс нәтижелеріңіздің шолуы',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    if (_loadingAnalytics) {
      return const Center(child: CircularProgressIndicator());
    }
    return Row(
      children: [
        DashboardStatCard(
          label: 'Жалпы табыс',
          value: '\$${(_analytics['totalIncome'] ?? 0).toStringAsFixed(2)}',
          icon: Icons.attach_money_rounded,
          gradient: AppColors.successGradient,
        ),
        const SizedBox(width: 12),
        DashboardStatCard(
          label: 'Аяқталды',
          value: (_analytics['totalOrders'] ?? 0).toString(),
          icon: Icons.check_circle_rounded,
          gradient: AppColors.primaryGradient,
        ),
      ],
    );
  }

  Widget _buildIncomeChart(BuildContext context) {
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
          Text('Табыс шолуы', style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildAiSuggestion(BuildContext context) {
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
              const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI Ұсынысы',
                    style: TextStyle(
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
                  'AI-дан кеңес сұрау →',
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

  Widget _buildPendingOrders() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is! OrdersLoaded) return const SizedBox();

        final pending = state.orders
            .where((o) => o.status == OrderStatus.pending)
            .toList();

        if (pending.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Ожидающих заказов нет 🎉',
                style: TextStyle(color: AppColors.textHint),
              ),
            ),
          );
        }

        return Column(
          children: pending.map((o) => PendingOrderCard(order: o)).toList(),
        );
      },
    );
  }
}
