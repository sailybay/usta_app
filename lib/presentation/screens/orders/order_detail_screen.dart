import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/review_entity.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/ai/ai_bloc.dart';
import '../../widgets/order_status_badge.dart';
import '../../widgets/gradient_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
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
            tooltip: 'Ask AI about this order',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            _buildStatusBanner(context),
            const SizedBox(height: 20),

            // Order info
            _buildInfoSection(context),
            const SizedBox(height: 20),

            // Schedule
            _buildScheduleSection(context),
            const SizedBox(height: 20),

            // Timeline
            _buildTimeline(context),
            const SizedBox(height: 24),

            // Actions
            _buildActions(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
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
                const Text(
                  'Order Status',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  order.status.label,
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

  Widget _buildInfoSection(BuildContext context) {
    return _SectionCard(
      title: 'Service Details',
      child: Column(
        children: [
          _InfoRow(label: 'Service', value: order.serviceName),
          _InfoRow(label: 'Category', value: order.serviceCategory),
          _InfoRow(label: 'Provider', value: order.workerName),
          _InfoRow(
            label: 'Amount',
            value: '\$${order.amount.toStringAsFixed(2)}',
            isHighlighted: true,
          ),
          if (order.address != null && order.address!.isNotEmpty)
            _InfoRow(label: 'Address', value: order.address!),
          if (order.notes != null && order.notes!.isNotEmpty)
            _InfoRow(label: 'Notes', value: order.notes!),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return _SectionCard(
      title: 'Schedule',
      child: Row(
        children: [
          _DateTimeChip(
            icon: Icons.calendar_month_rounded,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy').format(order.scheduledAt),
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

  Widget _buildTimeline(BuildContext context) {
    final steps = [
      _TimelineStep('Order Placed', order.createdAt, true),
      _TimelineStep('Accepted', order.acceptedAt, order.acceptedAt != null),
      _TimelineStep('In Progress', order.startedAt, order.startedAt != null),
      _TimelineStep('Completed', order.completedAt, order.completedAt != null),
    ];

    return _SectionCard(
      title: 'Order Timeline',
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
                          DateFormat('MMM dd, HH:mm').format(step.time!),
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

  Widget _buildActions(BuildContext context) {
    final canChat = order.status != OrderStatus.cancelled;
    final canCancel = order.status == OrderStatus.pending;
    final canReview = order.status == OrderStatus.completed;

    return Column(
      children: [
        if (canChat)
          GradientButton(
            onPressed: () => context.push('/chat/${order.chatId}'),
            label: 'Chat with Provider',
            icon: Icons.chat_bubble_outline_rounded,
          ),
        if (canReview) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showReviewSheet(context),
            icon: const Icon(Icons.star_rounded),
            label: const Text('Leave a Review'),
          ),
        ],
        if (canCancel) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _showCancelDialog(context),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            label: const Text(
              'Cancel Order',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Reason for cancellation',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Back'),
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
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context) {
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
                'Rate your experience',
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
                decoration: const InputDecoration(
                  hintText: 'Write your review...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Submit Review',
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
