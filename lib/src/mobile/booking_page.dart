import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/bloc/bookings_bloc.dart';

/// Flusso di prenotazione per l'utente finale: giorno, orario, nome, conferma.
class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _name = TextEditingController();
  late DateTime _day = _today();
  DateTime? _slot;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingsBloc>();
    final hours = bloc.repository.hours;
    final days = [for (var i = 0; i < 7; i++) _today().add(Duration(days: i))];

    return BlocConsumer<BookingsBloc, BookingsState>(
      listenWhen: (previous, current) =>
          current.message != null && current.message != previous.message,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message!))),
      builder: (context, state) {
        final taken = [for (final b in state.active) b];
        final now = DateTime.now();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Scegli il giorno',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final d in days)
                  ChoiceChip(
                    label: Text(DateFormat('EEE d MMM', 'it').format(d)),
                    selected: d == _day,
                    onSelected: (_) => setState(() {
                      _day = d;
                      _slot = null;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Scegli l\'orario',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final slot in hours.slotsFor(_day))
                  ChoiceChip(
                    label: Text(DateFormat.Hm().format(slot)),
                    selected: slot == _slot,
                    onSelected:
                        slot.isBefore(now) ||
                            taken.any(
                              (b) => b.overlaps(
                                slot,
                                slot.add(hours.slotDuration),
                              ),
                            )
                        ? null
                        : (_) => setState(() => _slot = slot),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Il tuo nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _slot == null || _name.text.trim().isEmpty
                  ? null
                  : () {
                      bloc.add(
                        BookingRequested(
                          customerName: _name.text.trim(),
                          start: _slot!,
                        ),
                      );
                      setState(() => _slot = null);
                    },
              child: const Text('Conferma prenotazione'),
            ),
          ],
        );
      },
    );
  }
}
