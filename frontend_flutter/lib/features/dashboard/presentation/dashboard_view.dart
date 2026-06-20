import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../shared/layouts/responsive_scaffold.dart';
import '../../auth/application/auth_session_controller.dart';
import '../domain/entities/dashboard_summary.dart';
import 'dashboard_controller.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({
    super.key,
    required this.role,
    required this.title,
  });

  final UserRole role;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSummary = ref.watch(dashboardSummaryProvider(role));

    return ResponsiveScaffold(
      title: title,
      body: asyncSummary.when(
        loading: () => const LoadingWidget(message: 'Memuat dashboard...'),
        error: (error, stackTrace) => ErrorStateWidget(
          title: 'Dashboard gagal dimuat',
          message: error.toString(),
          onRetry: () => ref.invalidate(dashboardSummaryProvider(role)),
        ),
        data: (summary) {
          if (summary.metrics.isEmpty && summary.items.isEmpty) {
            return EmptyStateWidget(
              title: 'Belum ada data',
              message: summary.emptyMessage,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _WelcomeHero(summary: summary),
                            const SizedBox(height: 32),
                            Text('Ringkasan Statistik', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            _MetricGrid(metrics: summary.metrics),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Aktivitas Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            _ItemList(items: summary.items),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WelcomeHero(summary: summary),
                    const SizedBox(height: 32),
                    Text('Ringkasan Statistik', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _MetricGrid(metrics: summary.metrics),
                    const SizedBox(height: 32),
                    Text('Aktivitas Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _ItemList(items: summary.items),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.subtitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Diperbarui pada ${summary.generatedAt.toLocal().toString().split('.')[0]}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<DashboardMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: metrics
          .map(
            (metric) => Container(
              width: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(metric.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_iconFor(metric.icon), color: Theme.of(context).colorScheme.primary, size: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(metric.value, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 8),
                          Text(metric.hint, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  IconData _iconFor(String icon) {
    switch (icon) {
      case 'school':
        return Icons.school_outlined;
      case 'title':
        return Icons.article_outlined;
      case 'event':
        return Icons.event_outlined;
      case 'supervisor_account':
        return Icons.supervisor_account_outlined;
      case 'notifications':
        return Icons.notifications_outlined;
      case 'badge':
        return Icons.badge_outlined;
      case 'groups':
        return Icons.groups_outlined;
      case 'schedule':
        return Icons.schedule_outlined;
      case 'event_note':
        return Icons.event_note_outlined;
      case 'rate_review':
        return Icons.rate_review_outlined;
      case 'assignment_ind':
        return Icons.assignment_ind_outlined;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'check_circle':
        return Icons.check_circle_outline;
      case 'hourglass_empty':
        return Icons.hourglass_empty_outlined;
      case 'person_search':
        return Icons.person_search_outlined;
      case 'domain':
        return Icons.domain_outlined;
      case 'handshake':
        return Icons.handshake_outlined;
      case 'campaign':
        return Icons.campaign_outlined;
      case 'group':
        return Icons.groups_outlined;
      case 'apartment':
        return Icons.apartment_outlined;
      case 'shield':
        return Icons.shield_outlined;
      case 'api':
        return Icons.api_outlined;
      case 'terminal':
        return Icons.terminal_outlined;
      case 'settings':
        return Icons.settings_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

class _ItemList extends StatelessWidget {
  const _ItemList({required this.items});

  final List<DashboardItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyStateWidget(
        title: 'Belum ada item terbaru',
        message: 'API belum mengembalikan aktivitas terbaru untuk dashboard ini.',
      );
    }

    return Column(
      children: items
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: _getStatusColor(context, item.status),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(context, item.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: _getStatusColor(context, item.status),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    final s = status.toLowerCase();
    if (s.contains('sukses') || s.contains('selesai') || s.contains('diterima') || s.contains('aktif')) {
      return Colors.green.shade600;
    } else if (s.contains('tunggu') || s.contains('proses') || s.contains('pending')) {
      return Colors.orange.shade600;
    } else if (s.contains('gagal') || s.contains('tolak') || s.contains('error')) {
      return Colors.red.shade600;
    }
    return Theme.of(context).colorScheme.primary;
  }
}

