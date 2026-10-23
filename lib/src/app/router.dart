import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mobile/booking_page.dart';
import '../mobile/history_page.dart';
import '../web/admin_dashboard_page.dart';
import 'adaptive_shell.dart';

/// Le tre sezioni sono destinazioni di una barra di navigazione, non pagine
/// "in pila": il cambio è immediato. Con la transizione predefinita le pagine,
/// senza sfondo proprio, restano visibili insieme per qualche istante.
Page<void> _destination(GoRouterState state, Widget child) =>
    NoTransitionPage(key: state.pageKey, child: child);

GoRouter buildRouter() => GoRouter(
  initialLocation: '/prenota',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AdaptiveShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: '/prenota',
          pageBuilder: (context, state) =>
              _destination(state, const BookingPage()),
        ),
        GoRoute(
          path: '/storico',
          pageBuilder: (context, state) =>
              _destination(state, const HistoryPage()),
        ),
        GoRoute(
          path: '/admin',
          pageBuilder: (context, state) => _destination(
            state,
            LayoutBuilder(
              builder: (context, c) => c.maxWidth >= desktopBreakpoint
                  ? const AdminDashboardPage()
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'La dashboard amministrativa è pensata per schermi larghi.',
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    ),
  ],
);
