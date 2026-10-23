import 'package:equatable/equatable.dart';

enum BookingStatus { confirmed, cancelled }

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.customerName,
    required this.start,
    required this.duration,
    this.status = BookingStatus.confirmed,
  });

  final String id;
  final String customerName;
  final DateTime start;
  final Duration duration;
  final BookingStatus status;

  DateTime get end => start.add(duration);
  bool get isActive => status == BookingStatus.confirmed;

  /// Due prenotazioni si sovrappongono se ciascuna inizia prima che l'altra finisca.
  /// Chi finisce alle 10:00 non si scontra con chi inizia alle 10:00.
  bool overlaps(DateTime otherStart, DateTime otherEnd) =>
      start.isBefore(otherEnd) && otherStart.isBefore(end);

  Booking cancelled() => Booking(
    id: id,
    customerName: customerName,
    start: start,
    duration: duration,
    status: BookingStatus.cancelled,
  );

  @override
  List<Object?> get props => [id, customerName, start, duration, status];
}
