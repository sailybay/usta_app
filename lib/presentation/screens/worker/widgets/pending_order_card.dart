// Pending order card for the worker dashboard
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/presentation/blocs/order/order_bloc.dart';
import 'package:usta_app/presentation/widgets/order_status_badge.dart';

/// Карточка ожидающего заказа на дашборде мастера
class PendingOrderCard extends StatelessWidget {
  final OrderEntity order;
  const PendingOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
                  child: const Text('Қабылдау'),
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
                  child: const Text('Қарау'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
