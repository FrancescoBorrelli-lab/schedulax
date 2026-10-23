import 'package:flutter_test/flutter_test.dart';
import 'package:schedulax/src/shared/data/booking_repository.dart';
import 'package:schedulax/src/shared/models/working_hours.dart';

void main() {
  final day = DateTime(2030, 1, 7);
  DateTime at(int hour) => DateTime(day.year, day.month, day.day, hour);

  test('gli slot coprono l\'orario di apertura', () {
    final slots = const WorkingHours().slotsFor(day);
    expect(slots.first, at(9));
    expect(slots.last, at(17));
    expect(slots.length, 9);
  });

  test('non si può prenotare due volte lo stesso slot', () async {
    final repo = InMemoryBookingRepository();
    await repo.book(customerName: 'Anna', start: at(10));
    expect(
      () => repo.book(customerName: 'Luca', start: at(10)),
      throwsA(isA<SlotUnavailableException>()),
    );
  });

  test('slot adiacenti non si sovrappongono', () async {
    final repo = InMemoryBookingRepository();
    await repo.book(customerName: 'Anna', start: at(10));
    final next = await repo.book(customerName: 'Luca', start: at(11));
    expect(next.start, at(11));
  });

  test('uno slot annullato torna disponibile', () async {
    final repo = InMemoryBookingRepository();
    final first = await repo.book(customerName: 'Anna', start: at(10));
    await repo.cancel(first.id);
    final again = await repo.book(customerName: 'Luca', start: at(10));
    expect(again.customerName, 'Luca');
  });

  test('fuori dagli orari di apertura non si prenota', () async {
    final repo = InMemoryBookingRepository();
    expect(
      () => repo.book(customerName: 'Anna', start: at(20)),
      throwsA(isA<SlotUnavailableException>()),
    );
    expect(
      () => repo.book(customerName: 'Anna', start: DateTime(2030, 1, 7, 9, 30)),
      throwsA(isA<SlotUnavailableException>()),
    );
  });
}
