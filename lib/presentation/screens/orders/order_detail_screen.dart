import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/ai/ai_bloc.dart';
import '../../widgets/order_status_badge.dart';
import '../../widgets/gradient_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              context.read<AiBloc>().add(
                AiGetOrderGuidance(
                  status: order.status.label,
                  serviceName: order.serviceName,
                ),
              );
              context.push(AppRouter.aiChat);
            },
            tooltip: l10n.orderAskAi,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBanner(context, l10n),
            const SizedBox(height: 20),
            _buildInfoSection(context, l10n),
            const SizedBox(height: 20),
            _buildScheduleSection(context, l10n),
            const SizedBox(height: 20),
            _buildTimeline(context, l10n),
            const SizedBox(height: 24),
            _buildActions(context, l10n),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.orderStatusLabel,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _localizedStatus(order.status, l10n),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          OrderStatusBadge(status: order.status, isDark: true),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, AppLocalizations l10n) {
    return _SectionCard(
      title: l10n.orderServiceDetails,
      child: Column(
        children: [
          _InfoRow(label: l10n.orderService, value: order.serviceName),
          _InfoRow(label: l10n.orderCategory, value: order.serviceCategory),
          _InfoRow(label: l10n.orderProvider, value: order.workerName),
          _InfoRow(
            label: l10n.orderAmount,
            value: '${order.amount.toStringAsFixed(0)} ₸',
            isHighlighted: true,
          ),
          if (order.address != null && order.address!.isNotEmpty)
            _InfoRow(label: l10n.orderAddress, value: order.address!),
          if (order.notes != null && order.notes!.isNotEmpty)
            _InfoRow(label: l10n.orderNotes, value: order.notes!),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context, AppLocalizations l10n) {
    return _SectionCard(
      title: l10n.orderScheduleTitle,
      child: Row(
        children: [
          _DateTimeChip(
            icon: Icons.calendar_month_rounded,
            label: 'Date',
            value: DateFormat('dd.MM.yyyy').format(order.scheduledAt),
          ),
          const SizedBox(width: 12),
          _DateTimeChip(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: DateFormat('HH:mm').format(order.scheduledAt),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, AppLocalizations l10n) {
    final steps = [
      _TimelineStep(l10n.orderPlaced, order.createdAt, true),
      _TimelineStep(
        l10n.orderAccepted,
        order.acceptedAt,
        order.acceptedAt != null,
      ),
      _TimelineStep(
        l10n.orderInProgress,
        order.startedAt,
        order.startedAt != null,
      ),
      _TimelineStep(
        l10n.orderCompleted,
        order.completedAt,
        order.completedAt != null,
      ),
    ];

    return _SectionCard(
      title: l10n.orderTimelineTitle,
      child: Column(
        children: steps.map((step) {
          final isLast = step == steps.last;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: step.isDone ? AppColors.primary : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: step.isDone
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 36,
                      color: step.isDone ? AppColors.primary : AppColors.border,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: step.isDone
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                      if (step.time != null)
                        Text(
                          DateFormat('dd.MM HH:mm').format(step.time!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    final canChat = order.status != OrderStatus.cancelled;
    final canCancel = order.status == OrderStatus.pending;
    final canReview = order.status == OrderStatus.completed;

    return Column(
      children: [
        if (canChat)
          GradientButton(
            onPressed: () => context.push('/chat/${order.chatId}'),
            label: l10n.orderChatWithProvider,
            icon: Icons.chat_bubble_outline_rounded,
          ),
        if (canReview) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showReviewSheet(context, l10n),
            icon: const Icon(Icons.star_rounded),
            label: Text(l10n.orderLeaveReviewBtn),
          ),
        ],
        if (canCancel) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showCancelDialog(context, l10n),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            label: Text(
              l10n.orderCancelBtn,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(BuildContext context, AppLocalizations l10n) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.orderCancelTitle),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(hintText: l10n.orderCancelReasonHint),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.orderBack),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<OrderBloc>().add(
                OrderCancel(order.id, reasonController.text),
              );
              Navigator.pop(ctx);
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.orderCancelBtn),
          ),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context, AppLocalizations l10n) {
    double rating = 5.0;
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 40,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.orderRateTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.star,
                      size: 36,
                    ),
                    onPressed: () =>
                        setState(() => rating = (i + 1).toDouble()),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(hintText: l10n.orderWriteReview),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: l10n.orderSubmitReviewBtn,
                onPressed: () {
                  final review = ReviewEntity(
                    id: '',
                    orderId: order.id,
                    clientId: order.clientId,
                    clientName: order.clientName,
                    workerId: order.workerId,
                    rating: rating,
                    comment: commentController.text,
                    createdAt: DateTime.now(),
                  );
                  context.read<OrderBloc>().add(
                    OrderSubmitReview(review: review, workerId: order.workerId),
                  );
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizedStatus(OrderStatus status, AppLocalizations l10n) {
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
}

class _TimelineStep {
  final String label;
  final DateTime? time;
  final bool isDone;
  const _TimelineStep(this.label, this.time, this.isDone);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;
  const _InfoRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                color: isHighlighted
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontSize: isHighlighted ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DateTimeChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
