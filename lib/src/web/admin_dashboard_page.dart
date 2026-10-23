import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/bloc/bookings_bloc.dart';

/// Dashboard dell'amministratore: numeri chiave e agenda. Pensata per desktop.
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        final active = state.active;
        final now = DateTime.now();
        final today = active.where(
          (b) =>
              b.start.year == now.year &&
              b.start.month == now.month &&
              b.start.day == now.day,
        );
        final customers = active
            .map((b) => b.customerName.toLowerCase())
            .toSet();

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                _Stat(label: 'Oggi', value: '${today.length}'),
                _Stat(label: 'Prenotazioni attive', value: '${active.length}'),
                _Stat(label: 'Clienti', value: '${customers.length}'),
              ],
            ),
            const SizedBox(height: 24),
            Text('Agenda', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (active.isEmpty) const Text('Nessuna prenotazione in agenda.'),
            for (final b in active)
              Card(
                child: ListTile(
                  title: Text(b.customerName),
                  subtitle: Text(
                    DateFormat('EEEE d MMMM, HH:mm', 'it').format(b.start),
                  ),
                  trailing: IconButton(
                    tooltip: 'Annulla',
                    icon: const Icon(Icons.close),
                    onPressed: () => context.read<BookingsBloc>().add(
                      BookingCancelled(b.id),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.displaySmall),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
