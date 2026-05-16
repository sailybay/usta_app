import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/blocs.dart';
import 'package:usta_app/presentation/widgets/order_status_badge.dart';

class OrderFinderScreen extends StatefulWidget {
  const OrderFinderScreen({super.key});

  @override
  State<OrderFinderScreen> createState() => _OrderFinderScreenState();
}

class _OrderFinderScreenState extends State<OrderFinderScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(OrderLoadPublicOrders());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderFinderTitle)),
      body: Column(
        children: [
          _buildCategoryFilter(l10n),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is! OrdersLoaded) return const SizedBox();

                final orders = state.orders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.textHint.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.orderFinderEmpty,
                          style: const TextStyle(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<OrderBloc>().add(
                      OrderLoadPublicOrders(category: _selectedCategory),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _PublicOrderCard(
                        order: order,
                        onAccept: () {
                          context.read<OrderBloc>().add(
                            OrderAccept(
                              orderId: order.id,
                              workerId: user.id,
                              workerName: user.name,
                              workerAvatarUrl: user.avatarUrl,
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l10n) {
    final categories = [
      {'id': null, 'name': 'All'},
      {'id': 'Cleaning', 'name': l10n.catCleaning},
      {'id': 'Repair', 'name': l10n.catRepair},
      {'id': 'Delivery', 'name': l10n.catDelivery},
      {'id': 'Tutoring', 'name': l10n.catTutoring},
      {'id': 'Beauty', 'name': l10n.catBeauty},
      {'id': 'Plumbing', 'name': l10n.catPlumbing},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat['name'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = cat['id']);
                context.read<OrderBloc>().add(
                  OrderLoadPublicOrders(category: _selectedCategory),
                );
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PublicOrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onAccept;

  const _PublicOrderCard({required this.order, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              Text(
                order.serviceName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                order.clientName,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.address ?? 'No address',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.amount.toStringAsFixed(0)} ₸',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.workerAccept),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
