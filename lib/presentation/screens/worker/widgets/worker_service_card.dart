import 'package:flutter/material.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/domain/entities/service_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';

/// Compact card showing a worker's service with status toggle and actions.
class WorkerServiceCard extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onDelete;

  const WorkerServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: service.isActive
              ? AppColors.border
              : AppColors.border.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon badge
                  _CategoryBadge(category: service.category),
                  const SizedBox(width: 12),
                  // Name + category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: service.isActive
                                ? theme.colorScheme.onSurface
                                : AppColors.textHint,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Active toggle
                  Switch(
                    value: service.isActive,
                    onChanged: onToggleActive,
                    thumbColor: WidgetStateProperty.resolveWith<Color?>(
                      (s) => s.contains(WidgetState.selected)
                          ? AppColors.primary
                          : null,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price + rating row
              Row(
                children: [
                  _PriceChip(service: service),
                  const SizedBox(width: 8),
                  if (service.reviewCount > 0) ...[
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.star,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${service.rating.toStringAsFixed(1)} (${service.reviewCount})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Edit + Delete action buttons
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: AppColors.primary,
                    tooltip: 'Өзгерту',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: AppColors.error,
                    tooltip: l10n.workerServiceDeleteTooltip,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                    onPressed: () => _confirmDelete(context, l10n),
                  ),
                ],
              ),
              // Tags
              if (service.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: service.tags
                      .take(4)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.workerServiceDeleteTitle),
        content: Text(l10n.workerServiceDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.workerServiceDeleteCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.workerServiceDeleteConfirmBtn),
          ),
        ],
      ),
    );
  }
}

// ─── Supporting widgets ───────────────────────────────────────────────────────

class _PriceChip extends StatelessWidget {
  final ServiceEntity service;
  const _PriceChip({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        service.formattedPrice,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  static const _icons = <String, IconData>{
    'Cleaning': Icons.cleaning_services_rounded,
    'Тазалық': Icons.cleaning_services_rounded,
    'Repair': Icons.construction_rounded,
    'Жөндеу': Icons.construction_rounded,
    'Delivery': Icons.delivery_dining_rounded,
    'Жеткізу': Icons.delivery_dining_rounded,
    'Tutoring': Icons.menu_book_rounded,
    'Репетитор': Icons.menu_book_rounded,
    'Beauty': Icons.face_retouching_natural_rounded,
    'Сұлулық': Icons.face_retouching_natural_rounded,
    'Plumbing': Icons.plumbing_rounded,
    'Сантехника': Icons.plumbing_rounded,
  };

  static const _colors = <String, Color>{
    'Cleaning': AppColors.categoryCleaning,
    'Тазалық': AppColors.categoryCleaning,
    'Repair': AppColors.categoryRepair,
    'Жөндеу': AppColors.categoryRepair,
    'Delivery': AppColors.categoryDelivery,
    'Жеткізу': AppColors.categoryDelivery,
    'Tutoring': AppColors.categoryTutor,
    'Репетитор': AppColors.categoryTutor,
    'Beauty': AppColors.categoryBeauty,
    'Сұлулық': AppColors.categoryBeauty,
    'Plumbing': AppColors.categoryPlumbing,
    'Сантехника': AppColors.categoryPlumbing,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[category] ?? Icons.home_repair_service_rounded;
    final color = _colors[category] ?? AppColors.primary;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
