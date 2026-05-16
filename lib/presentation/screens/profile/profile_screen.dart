import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/core/router/app_router.dart';
import 'package:usta_app/presentation/blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      return Center(child: Text(l10n.errorGeneric));
    }
    final user = authState.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: context.canPop()
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            backgroundImage: user.avatarUrl != null
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 15,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.isWorker
                                  ? l10n.profileRoleWorker
                                  : l10n.profileRoleClient,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _StatCard(
                    label: l10n.profileRating,
                    value: user.rating.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                    color: AppColors.star,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: l10n.profileReviews,
                    value: user.reviewCount.toString(),
                    icon: Icons.reviews_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: l10n.profileRole,
                    value: user.isWorker
                        ? l10n.profileRoleWorker
                        : l10n.profileRoleClient,
                    icon: Icons.person_rounded,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSection(l10n.profileSectionAccount, [
                _MenuItem(
                  icon: Icons.edit_rounded,
                  label: l10n.profileEditProfile,
                  onTap: () => _showComingSoon(context, l10n),
                ),
              ]),
              if (user.isWorker)
                _buildSection(l10n.profileSectionWorker, [
                  _MenuItem(
                    icon: Icons.dashboard_rounded,
                    label: l10n.profileDashboard,
                    onTap: () => context.push(AppRouter.workerDashboard),
                    trailingColor: AppColors.primary,
                  ),
                ]),
              _buildSection(l10n.profileSectionSupport, [
                _MenuItem(
                  icon: Icons.auto_awesome_rounded,
                  label: l10n.profileAiAssistant,
                  onTap: () => context.go(AppRouter.aiChat),
                  trailingColor: AppColors.primary,
                ),
              ]),
              _buildSection('', [
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: l10n.profileSignOut,
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                ),
              ]),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: items),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color textColor;
  final Color iconColor;
  final Color? trailingColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor = AppColors.textPrimary,
    this.iconColor = AppColors.textSecondary,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: trailingColor ?? AppColors.textHint,
      ),
      onTap: onTap,
    );
  }
}
