import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sopra questa larghezza l'interfaccia passa dal layout mobile a quello desktop.
const desktopBreakpoint = 900.0;

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  static const _items = [
    (
      path: '/prenota',
      label: 'Prenota',
      icon: Icons.add_circle_outline,
      adminOnly: false,
    ),
    (path: '/storico', label: 'Storico', icon: Icons.history, adminOnly: false),
    (
      path: '/admin',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      adminOnly: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= desktopBreakpoint;
        // La dashboard compare nella navigazione solo su desktop.
        final items = [
          for (final i in _items)
            if (wide || !i.adminOnly) i,
        ];
        final selected = items
            .indexWhere((i) => location.startsWith(i.path))
            .clamp(0, items.length - 1);

        void go(int index) => context.go(items[index].path);

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: true,
                  selectedIndex: selected,
                  onDestinationSelected: go,
                  leading: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'SchedulaX',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  destinations: [
                    for (final i in items)
                      NavigationRailDestination(
                        icon: Icon(i.icon),
                        label: Text(i.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('SchedulaX')),
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected,
            onDestinationSelected: go,
            destinations: [
              for (final i in items)
                NavigationDestination(icon: Icon(i.icon), label: i.label),
            ],
          ),
        );
      },
    );
  }
}
