import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../widgets/order_status_badge.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<OrderBloc>().add(OrderLoadClientOrders(authState.user.id));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ordersMyOrders),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: l10n.ordersActive),
            Tab(text: l10n.ordersCompleted),
            Tab(text: l10n.ordersCancelled),
          ],
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listenWhen: (previous, current) =>
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
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is OrderLoading || current is OrdersLoaded,
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersLoaded) {
            final active = state.orders
                .where(
                  (o) =>
                      o.status == OrderStatus.pending ||
                      o.status == OrderStatus.accepted ||
                      o.status == OrderStatus.inProgress,
                )
                .toList();
            final completed = state.orders
                .where((o) => o.status == OrderStatus.completed)
                .toList();
            final cancelled = state.orders
                .where((o) => o.status == OrderStatus.cancelled)
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _OrderList(orders: active, l10n: l10n),
                _OrderList(orders: completed, l10n: l10n),
                _OrderList(orders: cancelled, l10n: l10n),
              ],
            );
          }
          return Center(child: Text(l10n.ordersNoOrders));
        },
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderEntity> orders;
  final AppLocalizations l10n;
  const _OrderList({required this.orders, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 72,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.ordersNoOrders,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _OrderCard(order: orders[index], l10n: l10n),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final AppLocalizations l10n;
  const _OrderCard({required this.order, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/order/${order.id}', extra: order),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
            const SizedBox(height: 8),
            Text(
              '${l10n.ordersMadeBy} ${order.workerName}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd.MM.yyyy – HH:mm').format(order.scheduledAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${order.amount.toStringAsFixed(0)} ₸',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
