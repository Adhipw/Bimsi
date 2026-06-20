import 'package:flutter/material.dart';
import 'app_sidebar.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  title: Text(title),
                  actions: actions,
                ),
          drawer: isDesktop ? null : const AppSidebar(),
          floatingActionButton: floatingActionButton,
          body: Row(
            children: [
              if (isDesktop)
                const SizedBox(
                  width: 280,
                  child: AppSidebar(),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isDesktop)
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                            Row(children: actions ?? []),
                          ],
                        ),
                      ),
                    Expanded(
                      child: isDesktop
                          ? Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 1120),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: body,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: body,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

