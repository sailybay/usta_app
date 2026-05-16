import 'package:flutter/material.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final bool isDark;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.2)
            : config['color'].withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : config['color'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _getStatusLabel(status, l10n),
            style: TextStyle(
              color: isDark ? Colors.white : config['color'],
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(OrderStatus status, AppLocalizations l10n) {
    switch (status) {
      case OrderStatus.pending:
        return l10n.orderStatusPending;
      case OrderStatus.accepted:
        return l10n.orderStatusAccepted;
      case OrderStatus.inProgress:
        return l10n.orderStatusInProgress;
      case OrderStatus.completed:
        return l10n.orderStatusCompleted;
      case OrderStatus.cancelled:
        return l10n.orderStatusCancelled;
    }
  }

  Map<String, dynamic> _getConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return {'color': AppColors.warning};
      case OrderStatus.accepted:
        return {'color': AppColors.info};
      case OrderStatus.inProgress:
        return {'color': AppColors.primary};
      case OrderStatus.completed:
        return {'color': AppColors.success};
      case OrderStatus.cancelled:
        return {'color': AppColors.error};
    }
  }
}
