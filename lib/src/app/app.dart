import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../shared/bloc/bookings_bloc.dart';
import '../shared/data/booking_repository.dart';
import 'router.dart';

class SchedulaXApp extends StatefulWidget {
  const SchedulaXApp({required this.repository, super.key});

  final BookingRepository repository;

  @override
  State<SchedulaXApp> createState() => _SchedulaXAppState();
}

class _SchedulaXAppState extends State<SchedulaXApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BookingsBloc(widget.repository)..add(const BookingsStarted()),
      child: MaterialApp.router(
        title: 'SchedulaX',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF0D9488),
          useMaterial3: true,
        ),
        locale: const Locale('it'),
        supportedLocales: const [Locale('it')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
