import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPageData> _getPages(AppLocalizations l10n) => [
    OnboardingPageData(
      title: l10n.onboardingTitle1,
      subtitle: l10n.onboardingSubtitle1,
      icon: Icons.search_rounded,
      gradient: AppColors.primaryGradient,
    ),
    OnboardingPageData(
      title: l10n.onboardingTitle2,
      subtitle: l10n.onboardingSubtitle2,
      icon: Icons.calendar_month_rounded,
      gradient: AppColors.heroGradient,
    ),
    OnboardingPageData(
      title: l10n.onboardingTitle3,
      subtitle: l10n.onboardingSubtitle3,
      icon: Icons.auto_awesome_rounded,
      gradient: AppColors.successGradient,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _getPages(l10n);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final page = pages[index];
              return _OnboardingPageWidget(page: page);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFooter(l10n, pages.length),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n, int pageCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 48),
      child: Column(
        children: [
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageCount,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (_currentPage < pageCount - 1)
                TextButton(
                  onPressed: () => context.go(AppRouter.login),
                  child: Text(
                    l10n.onboardingSkip,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _nextPage(pageCount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(140, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentPage == pageCount - 1
                          ? l10n.onboardingGetStarted
                          : l10n.onboardingNext,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData page;
  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: page.gradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(page.icon, size: 80, color: Colors.white),
              ),
              const Spacer(),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
