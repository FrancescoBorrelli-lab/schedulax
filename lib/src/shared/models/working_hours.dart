/// Orari di apertura e durata degli appuntamenti.
class WorkingHours {
  const WorkingHours({
    this.openHour = 9,
    this.closeHour = 18,
    this.slotMinutes = 60,
  });

  final int openHour;
  final int closeHour;
  final int slotMinutes;

  Duration get slotDuration => Duration(minutes: slotMinutes);

  /// Tutti gli inizi possibili in un giorno.
  List<DateTime> slotsFor(DateTime day) {
    final open = DateTime(day.year, day.month, day.day, openHour);
    final close = DateTime(day.year, day.month, day.day, closeHour);
    final slots = <DateTime>[];
    for (
      var t = open;
      !t.add(slotDuration).isAfter(close);
      t = t.add(slotDuration)
    ) {
      slots.add(t);
    }
    return slots;
  }
}
