import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mobile/booking_page.dart';
import '../mobile/history_page.dart';
import '../web/admin_dashboard_page.dart';
import 'adaptive_shell.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: '/prenota',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AdaptiveShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: '/prenota',
          builder: (context, state) => const BookingPage(),
        ),
        GoRoute(
          path: '/storico',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => LayoutBuilder(
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
      ],
    ),
  ],
);
