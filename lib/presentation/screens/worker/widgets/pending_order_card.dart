// Pending order card for the worker dashboard – fully localized + status flow
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/order/order_bloc.dart';
import 'package:usta_app/presentation/widgets/order_status_badge.dart';

/// Worker card showing order with actionable buttons based on current status.
///
/// Order flow: pending → accepted → inProgress → completed
class PendingOrderCard extends StatelessWidget {
  final OrderEntity order;
  const PendingOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            'Клиент: ${order.clientName}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.amount.toStringAsFixed(0)} ₸',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(children: _buildActions(context, l10n)),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, AppLocalizations l10n) {
    final orderBloc = context.read<OrderBloc>();

    if (order.status == OrderStatus.pending) {
      // Worker can accept or reject
      return [
        Expanded(
          child: OutlinedButton(
            onPressed: () => orderBloc.add(
              OrderUpdateStatus(order.id, OrderStatus.accepted),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 40),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: Text(l10n.workerAccept),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => orderBloc.add(
              OrderUpdateStatus(order.id, OrderStatus.cancelled),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 40),
              side: const BorderSide(color: AppColors.error),
              foregroundColor: AppColors.error,
            ),
            child: Text(l10n.workerRejectOrder),
          ),
        ),
      ];
    }

    if (order.status == OrderStatus.accepted) {
      // Worker can start work
      return [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => orderBloc.add(
              OrderUpdateStatus(order.id, OrderStatus.inProgress),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: Text(l10n.workerStartWork),
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(width: 8),
        _viewButton(context, l10n),
      ];
    }

    if (order.status == OrderStatus.inProgress) {
      // Worker can complete order
      return [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => orderBloc.add(
              OrderUpdateStatus(order.id, OrderStatus.completed),
            ),
            icon: const Icon(Icons.check_circle_rounded, size: 18),
            label: Text(l10n.workerCompleteOrder),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 40),
              backgroundColor: AppColors.success,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _viewButton(context, l10n),
      ];
    }

    // Default: just show View button
    return [Expanded(child: _viewButton(context, l10n))];
  }

  Widget _viewButton(BuildContext context, AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: () => context.push('/order/${order.id}', extra: order),
      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
      child: Text(l10n.workerView),
    );
  }
}
