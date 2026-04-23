import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/domain/entities/service_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:usta_app/presentation/blocs/service/worker_service_bloc.dart';

/// Create or edit a service.
/// Pass [service] in route `extra` to enter edit mode; leave null for create.
class WorkerServiceFormScreen extends StatefulWidget {
  final ServiceEntity? service; // null → create mode
  const WorkerServiceFormScreen({super.key, this.service});

  @override
  State<WorkerServiceFormScreen> createState() =>
      _WorkerServiceFormScreenState();
}

class _WorkerServiceFormScreenState extends State<WorkerServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _tagCtrl;

  String _selectedCategory = 'Repair';
  String _priceType = 'fixed';
  bool _isActive = true;
  List<String> _tags = [];

  bool get _isEdit => widget.service != null;

  // Available categories (matches ServiceEntity)
  static const _categories = [
    'Cleaning',
    'Repair',
    'Delivery',
    'Tutoring',
    'Beauty',
    'Plumbing',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');
    _priceCtrl = TextEditingController(
      text: s != null ? s.price.toStringAsFixed(0) : '',
    );
    _tagCtrl = TextEditingController();
    _selectedCategory = s?.category ?? _categories.first;
    _priceType = s?.priceType ?? 'fixed';
    _isActive = s?.isActive ?? true;
    _tags = List<String>.from(s?.tags ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final t = tag.trim();
    if (t.isNotEmpty && !_tags.contains(t)) {
      setState(() => _tags.add(t));
    }
    _tagCtrl.clear();
  }

  void _removeTag(String tag) => setState(() => _tags.remove(tag));

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;
    final user = authState.user;

    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;

    if (_isEdit) {
      context.read<WorkerServiceBloc>().add(
        WorkerServiceUpdate(widget.service!.id, {
          'name': _nameCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          'category': _selectedCategory,
          'price': price,
          'priceType': _priceType,
          'isActive': _isActive,
          'tags': _tags,
        }),
      );
    } else {
      final now = DateTime.now();
      final service = ServiceEntity(
        id: '',
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _selectedCategory,
        price: price,
        priceType: _priceType,
        isActive: _isActive,
        tags: _tags,
        workerId: user.id,
        workerName: user.name,
        workerAvatarUrl: user.avatarUrl,
        rating: 0.0,
        reviewCount: 0,
        createdAt: now,
      );
      context.read<WorkerServiceBloc>().add(WorkerServiceCreate(service));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocListener<WorkerServiceBloc, WorkerServiceState>(
      listenWhen: (_, s) =>
          s is WorkerServiceActionSuccess || s is WorkerServiceError,
      listener: (context, state) {
        if (state is WorkerServiceActionSuccess) {
          context.pop();
        } else if (state is WorkerServiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? l10n.workerServiceFormEdit : l10n.workerServiceFormCreate,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              // ── Name ──────────────────────────────────────────────────────
              _SectionLabel(l10n.workerServiceName),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: _inputDecoration(
                  l10n.workerServiceNameHint,
                  Icons.edit_rounded,
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.workerServiceNameRequired
                    : null,
              ),
              const SizedBox(height: 20),

              // ── Description ───────────────────────────────────────────────
              _SectionLabel(l10n.workerServiceDesc),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: _inputDecoration(
                  l10n.workerServiceDescHint,
                  Icons.description_rounded,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.workerServiceDescRequired
                    : null,
              ),
              const SizedBox(height: 20),

              // ── Category ──────────────────────────────────────────────────
              _SectionLabel(l10n.workerServiceCategory),
              const SizedBox(height: 8),
              _CategorySelector(
                selected: _selectedCategory,
                categories: _categories,
                onSelect: (c) => setState(() => _selectedCategory = c),
                l10n: l10n,
              ),
              const SizedBox(height: 20),

              // ── Price Type ────────────────────────────────────────────────
              _SectionLabel(l10n.workerServicePriceType),
              const SizedBox(height: 8),
              _PriceTypeSelector(
                selected: _priceType,
                onSelect: (t) => setState(() => _priceType = t),
                l10n: l10n,
              ),
              const SizedBox(height: 16),

              // ── Price ─────────────────────────────────────────────────────
              _SectionLabel(l10n.workerServicePrice),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                decoration: _inputDecoration(
                  '5000',
                  Icons.attach_money_rounded,
                ).copyWith(suffixText: '₸'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.workerServicePriceRequired;
                  }

                  if (double.tryParse(v.trim()) == null) {
                    return l10n.workerServicePriceInvalid;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Tags ──────────────────────────────────────────────────────
              _SectionLabel(l10n.workerServiceTags),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagCtrl,
                      decoration: _inputDecoration(
                        l10n.workerServiceTagsHint,
                        Icons.tag_rounded,
                      ),
                      onFieldSubmitted: _addTag,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _addTag(_tagCtrl.text),
                    icon: const Icon(Icons.add_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tags
                      .map(
                        (tag) => InputChip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          backgroundColor: AppColors.primarySurface,
                          labelStyle: const TextStyle(color: AppColors.primary),
                          deleteIconColor: AppColors.primary,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),

              // ── isActive toggle ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.workerServiceActive,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    l10n.workerServiceActiveSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                  thumbColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.primary
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: BlocBuilder<WorkerServiceBloc, WorkerServiceState>(
              builder: (context, state) {
                final loading = state is WorkerServiceLoading;
                return ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.workerServiceSave,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 0.3,
    ),
  );
}

// ─── Category selector ────────────────────────────────────────────────────────
class _CategorySelector extends StatelessWidget {
  final String selected;
  final List<String> categories;
  final ValueChanged<String> onSelect;
  final AppLocalizations l10n;

  const _CategorySelector({
    required this.selected,
    required this.categories,
    required this.onSelect,
    required this.l10n,
  });

  String _label(String cat, AppLocalizations l10n) {
    switch (cat) {
      case 'Cleaning':
        return l10n.catCleaning;
      case 'Repair':
        return l10n.catRepair;
      case 'Delivery':
        return l10n.catDelivery;
      case 'Tutoring':
        return l10n.catTutoring;
      case 'Beauty':
        return l10n.catBeauty;
      case 'Plumbing':
        return l10n.catPlumbing;
      default:
        return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = cat == selected;
        return ChoiceChip(
          label: Text(_label(cat, l10n)),
          selected: isSelected,
          onSelected: (_) => onSelect(cat),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          backgroundColor: AppColors.surfaceVariant,
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}

// ─── Price type selector ──────────────────────────────────────────────────────
class _PriceTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final AppLocalizations l10n;

  const _PriceTypeSelector({
    required this.selected,
    required this.onSelect,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final types = {
      'fixed': l10n.workerServicePriceFixed,
      'hourly': l10n.workerServicePriceHourly,
      'from': l10n.workerServicePriceFrom,
    };

    return Row(
      children: types.entries.map((entry) {
        final isSelected = entry.key == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onSelect(entry.key),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
