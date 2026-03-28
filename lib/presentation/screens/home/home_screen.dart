import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/presentation/blocs/service/service_bloc.dart';
import 'package:usta_app/presentation/widgets/service_card.dart';
import 'package:usta_app/presentation/widgets/category_chip.dart';
import 'package:usta_app/presentation/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce; // P1 fix: debounce

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(ServiceLoadAll());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// U4 fix: greeting depends on time of day
  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning;
    if (hour < 18) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, l10n),
          SliverToBoxAdapter(child: _buildSearchBar(l10n)),
          SliverToBoxAdapter(child: _buildCategories(context, l10n)),
          SliverToBoxAdapter(
            child: _buildSectionHeader(l10n.homePopularServices),
          ),
          _buildServiceGrid(l10n),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(l10n),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        l10n.homeFindService,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.map_rounded),
                        onPressed: () => context.push(AppRouter.map),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 400), () {
            context.read<ServiceBloc>().add(ServiceSearch(query));
          });
        },
        decoration: InputDecoration(
          hintText: l10n.homeSearchHint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textHint,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            onPressed: () => _showFilterSheet(context, l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, AppLocalizations l10n) {
    final categories = [
      {
        'name': l10n.catAll,
        'icon': Icons.grid_view_rounded,
        'color': AppColors.primary,
      },
      {
        'name': l10n.catCleaning,
        'icon': Icons.cleaning_services_rounded,
        'color': AppColors.categoryCleaning,
      },
      {
        'name': l10n.catRepair,
        'icon': Icons.build_rounded,
        'color': AppColors.categoryRepair,
      },
      {
        'name': l10n.catDelivery,
        'icon': Icons.delivery_dining_rounded,
        'color': AppColors.categoryDelivery,
      },
      {
        'name': l10n.catTutoring,
        'icon': Icons.school_rounded,
        'color': AppColors.categoryTutor,
      },
      {
        'name': l10n.catBeauty,
        'icon': Icons.face_retouching_natural_rounded,
        'color': AppColors.categoryBeauty,
      },
      {
        'name': l10n.catPlumbing,
        'icon': Icons.plumbing_rounded,
        'color': AppColors.categoryPlumbing,
      },
    ];

    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        String? selected;
        if (state is ServiceLoaded) selected = state.selectedCategory;

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final name = cat['name'] as String;
              final isSelected =
                  (index == 0 && selected == null) || (name == selected);
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryChip(
                  label: name,
                  icon: cat['icon'] as IconData,
                  color: cat['color'] as Color,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<ServiceBloc>().add(
                      ServiceSelectCategory(index == 0 ? null : name),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          TextButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context).homeSeeAll),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(AppLocalizations l10n) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, _) => const ShimmerCard(),
                childCount: 4,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
            ),
          );
        }

        if (state is ServiceLoaded) {
          if (state.services.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeNoServices,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final service = state.services[index];
                return ServiceCard(
                  service: service,
                  onTap: () =>
                      context.push('/service/${service.id}', extra: service),
                );
              }, childCount: state.services.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  void _showFilterSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterBottomSheet(l10n: l10n),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final AppLocalizations l10n;
  const _FilterBottomSheet({required this.l10n});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String _sortBy = 'rating';

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.homeSortBy, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Column(
            children: ['rating', 'price_asc', 'price_desc'].map((sort) {
              final labels = {
                'rating': l10n.homeSortRating,
                'price_asc': l10n.homeSortPriceLow,
                'price_desc': l10n.homeSortPriceHigh,
              };
              return RadioListTile<String>(
                title: Text(labels[sort]!),
                value: sort,
                groupValue: _sortBy,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _sortBy = v!),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<ServiceBloc>().add(ServiceToggleSort(_sortBy));
                Navigator.pop(context);
              },
              child: Text(l10n.homeApply),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
