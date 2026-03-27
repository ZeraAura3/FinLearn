import 'package:finlearn/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:finlearn/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingItem> get _onboardingItems {
    final localizations = AppLocalizations.of(context);
    return [
      OnboardingItem(
        icon: Icons.school_rounded,
        title:
            localizations?.translate('onboarding_learn_basics') ??
            'Learn Finance Basics',
        description:
            localizations?.translate('onboarding_learn_basics_desc') ??
            'Master the fundamentals of personal finance, investing, and money management',
      ),
      OnboardingItem(
        icon: Icons.trending_up_rounded,
        title:
            localizations?.translate('onboarding_track_progress') ??
            'Track Your Progress',
        description:
            localizations?.translate('onboarding_track_progress_desc') ??
            'Monitor your learning journey and achieve your financial education goals',
      ),
      OnboardingItem(
        icon: Icons.emoji_events_rounded,
        title:
            localizations?.translate('onboarding_earn_cert') ??
            'Earn Certificates',
        description:
            localizations?.translate('onboarding_earn_cert_desc') ??
            'Complete courses and earn certificates to showcase your financial knowledge',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => _navigateToSignIn(),
                  child: Text(
                    AppLocalizations.of(context)!.translate('skip'),
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(context, _onboardingItems[index]);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _onboardingItems.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: colorScheme.primary,
                  dotColor: colorScheme.primary.withOpacity(0.3),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 4,
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('back'),
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingItems.length - 1) {
                          _navigateToSignIn();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _onboardingItems.length - 1
                            ? AppLocalizations.of(
                                context,
                              )!.translate('get_started')
                            : AppLocalizations.of(context)!.translate('next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, OnboardingItem item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 100, color: colorScheme.onPrimary),
          ),
          const SizedBox(height: 48),
          Text(
            item.title,
            style: textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignInScreen()));
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
