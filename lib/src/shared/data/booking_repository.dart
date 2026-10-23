import '../models/booking.dart';
import '../models/working_hours.dart';

class SlotUnavailableException implements Exception {
  const SlotUnavailableException();

  @override
  String toString() => 'Lo slot scelto non è più disponibile.';
}

abstract class BookingRepository {
  WorkingHours get hours;

  Future<List<Booking>> getAll();

  /// Crea una prenotazione; lancia [SlotUnavailableException] se si sovrappone
  /// a un'altra prenotazione attiva o cade fuori dagli orari.
  Future<Booking> book({required String customerName, required DateTime start});

  Future<void> cancel(String id);
}

/// Archivio in memoria. Da sostituire con Firestore (stessa interfaccia):
/// il controllo delle sovrapposizioni andrà spostato in una transazione o
/// in una Cloud Function, per reggere prenotazioni simultanee.
class InMemoryBookingRepository implements BookingRepository {
  InMemoryBookingRepository({
    this.hours = const WorkingHours(),
    List<Booking> seed = const [],
  }) : _bookings = [...seed];

  /// Archivio con qualche prenotazione fittizia nei prossimi giorni, per le demo.
  factory InMemoryBookingRepository.withSampleData({DateTime? now}) {
    final today = now ?? DateTime.now();
    DateTime at(int dayOffset, int hour) =>
        DateTime(today.year, today.month, today.day + dayOffset, hour);
    const names = [
      'Marco R.',
      'Giulia S.',
      'Andrea P.',
      'Chiara L.',
      'Luca M.',
    ];
    final slots = [(0, 11), (0, 15), (1, 9), (1, 16), (2, 10)];
    return InMemoryBookingRepository(
      seed: [
        for (var i = 0; i < slots.length; i++)
          Booking(
            id: 'demo${i + 1}',
            customerName: names[i],
            start: at(slots[i].$1, slots[i].$2),
            duration: const WorkingHours().slotDuration,
          ),
      ],
    );
  }

  @override
  final WorkingHours hours;

  final List<Booking> _bookings;
  int _nextId = 100;

  @override
  Future<List<Booking>> getAll() async => List.unmodifiable(_bookings);

  @override
  Future<Booking> book({
    required String customerName,
    required DateTime start,
  }) async {
    final end = start.add(hours.slotDuration);
    final isOfferedSlot = hours.slotsFor(start).contains(start);
    final clash = _bookings.any((b) => b.isActive && b.overlaps(start, end));
    if (!isOfferedSlot || clash) throw const SlotUnavailableException();

    final booking = Booking(
      id: 'b${_nextId++}',
      customerName: customerName,
      start: start,
      duration: hours.slotDuration,
    );
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<void> cancel(String id) async {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index >= 0) _bookings[index] = _bookings[index].cancelled();
  }
}
