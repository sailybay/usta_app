import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/data/repositories/order_repository.dart';
import 'package:usta_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:usta_app/presentation/blocs/order/order_bloc.dart';
import 'package:usta_app/presentation/blocs/ai/ai_bloc.dart';
import 'package:usta_app/presentation/widgets/order_status_badge.dart';
//import 'package:usta_app/presentation/widgets/gradient_button.dart';

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
      // Load AI suggestion
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
    if (mounted) {
      setState(() {
        _analytics = data;
        _loadingAnalytics = false;
      });
      // Update AI with real data
      context.read<AiBloc>().add(
        AiGetWorkerSuggestion(
          completedOrders: data['totalOrders'] ?? 0,
          rating:
              (context.read<AuthBloc>().state as AuthAuthenticated).user.rating,
          totalIncome: data['totalIncome'] ?? 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state as AuthAuthenticated;
    final user = authState.user;

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
              // Greeting
              Text(
                'Hello, ${user.name}! 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s your performance overview',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Stats row
              if (!_loadingAnalytics) _buildStatsRow(context),
              if (_loadingAnalytics)
                const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),

              // Income chart
              if (!_loadingAnalytics &&
                  (_analytics['incomeByMonth'] as Map).isNotEmpty)
                _buildIncomeChart(context),
              const SizedBox(height: 20),

              // AI Suggestion
              _buildAiSuggestion(context),
              const SizedBox(height: 20),

              // Pending orders
              Text(
                'Pending Orders',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildPendingOrders(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _DashboardStatCard(
          label: 'Total Income',
          value: '\$${(_analytics['totalIncome'] ?? 0).toStringAsFixed(2)}',
          icon: Icons.attach_money_rounded,
          gradient: AppColors.successGradient,
        ),
        const SizedBox(width: 12),
        _DashboardStatCard(
          label: 'Completed',
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
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), incomeByMonth[sortedKeys[i]]!));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
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

        final suggestion = aiMessages.last.content;
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
                    'AI Recommendation',
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
                suggestion,
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
                  'Ask AI for more tips →',
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

  Widget _buildPendingOrders(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrdersLoaded) {
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
                  'No pending orders ',
                  style: TextStyle(color: AppColors.textHint),
                ),
              ),
            );
          }

          return Column(
            children: pending
                .map((order) => _PendingOrderCard(order: order))
                .toList(),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  const _DashboardStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  final OrderEntity order;
  const _PendingOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.serviceName,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Client: ${order.clientName}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(
                      OrderUpdateStatus(order.id, OrderStatus.accepted),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text('Accept'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/order/${order.id}', extra: order),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('View'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
