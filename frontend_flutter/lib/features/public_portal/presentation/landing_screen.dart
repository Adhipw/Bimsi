import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/widgets/app_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const _portalActions = <_PortalAction>[
    _PortalAction(
      title: 'Mahasiswa',
      subtitle: 'Login atau daftar akun skripsi.',
      route: RoutePaths.studentLogin,
      icon: Icons.person_outline,
    ),
    _PortalAction(
      title: 'Dosen',
      subtitle: 'Masuk untuk bimbingan dan revisi.',
      route: RoutePaths.lecturerLogin,
      icon: Icons.badge_outlined,
    ),
    _PortalAction(
      title: 'Kaprodi',
      subtitle: 'Pantau laporan dan monitoring.',
      route: RoutePaths.adminLogin, // Adjust if Kaprodi has its own route
      icon: Icons.monitor_outlined,
    ),
    _PortalAction(
      title: 'Admin',
      subtitle: 'Kelola data kampus dan akun.',
      route: RoutePaths.adminLogin,
      icon: Icons.admin_panel_settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HERO SECTION
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    const Color(0xFF003875),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Icon(Icons.school, size: 80, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(height: 24),
                      Text(
                        'Bimbingan Skripsi Online',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppConstants.appTagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: -40), // Overlap effect

            // PORTAL CARDS
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: _portalActions
                        .map(
                          (action) => SizedBox(
                            width: 280,
                            child: _PortalAccessCard(action: action),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _PortalAccessCard extends StatelessWidget {
  const _PortalAccessCard({required this.action});

  final _PortalAction action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      onTap: () => context.go(action.route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(action.icon, color: Theme.of(context).colorScheme.primary, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            action.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            action.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ),
    );
  }
}

class _PortalAction {
  const _PortalAction({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
}
