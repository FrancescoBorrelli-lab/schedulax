import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/bloc/bookings_bloc.dart';
import '../shared/models/booking.dart';

/// Storico degli appuntamenti. Nella versione con autenticazione mostrerà
/// solo quelli dell'utente connesso.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.bookings.isEmpty) {
          return const Center(child: Text('Nessun appuntamento'));
        }
        final sorted = [...state.bookings]
          ..sort((a, b) => b.start.compareTo(a.start));
        return ListView(
          children: [
            for (final b in sorted)
              ListTile(
                leading: Icon(
                  b.isActive ? Icons.event_available : Icons.event_busy,
                ),
                title: Text(
                  DateFormat('EEEE d MMMM, HH:mm', 'it').format(b.start),
                ),
                subtitle: Text(
                  '${b.customerName} · ${b.status == BookingStatus.confirmed ? 'confermata' : 'annullata'}',
                ),
                trailing: b.isActive
                    ? TextButton(
                        onPressed: () => context.read<BookingsBloc>().add(
                          BookingCancelled(b.id),
                        ),
                        child: const Text('Annulla'),
                      )
                    : null,
              ),
          ],
        );
      },
    );
  }
}
