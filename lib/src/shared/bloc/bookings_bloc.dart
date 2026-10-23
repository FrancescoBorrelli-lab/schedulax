import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/booking_repository.dart';
import '../models/booking.dart';

sealed class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

class BookingsStarted extends BookingsEvent {
  const BookingsStarted();
}

class BookingRequested extends BookingsEvent {
  const BookingRequested({required this.customerName, required this.start});

  final String customerName;
  final DateTime start;

  @override
  List<Object?> get props => [customerName, start];
}

class BookingCancelled extends BookingsEvent {
  const BookingCancelled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class BookingsState extends Equatable {
  const BookingsState({
    this.bookings = const [],
    this.loading = true,
    this.message,
  });

  final List<Booking> bookings;
  final bool loading;

  /// Esito dell'ultima azione (conferma o errore), mostrato una volta all'utente.
  final String? message;

  List<Booking> get active =>
      bookings.where((b) => b.isActive).toList()
        ..sort((a, b) => a.start.compareTo(b.start));

  BookingsState copyWith({
    List<Booking>? bookings,
    bool? loading,
    String? message,
  }) => BookingsState(
    bookings: bookings ?? this.bookings,
    loading: loading ?? this.loading,
    message: message,
  );

  @override
  List<Object?> get props => [bookings, loading, message];
}

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc(this._repository) : super(const BookingsState()) {
    on<BookingsStarted>((event, emit) async {
      emit(BookingsState(bookings: await _repository.getAll(), loading: false));
    });

    on<BookingRequested>((event, emit) async {
      try {
        await _repository.book(
          customerName: event.customerName,
          start: event.start,
        );
        emit(
          BookingsState(
            bookings: await _repository.getAll(),
            loading: false,
            message: 'Prenotazione confermata',
          ),
        );
      } on SlotUnavailableException catch (e) {
        emit(state.copyWith(message: e.toString()));
      }
    });

    on<BookingCancelled>((event, emit) async {
      await _repository.cancel(event.id);
      emit(
        BookingsState(
          bookings: await _repository.getAll(),
          loading: false,
          message: 'Prenotazione annullata',
        ),
      );
    });
  }

  final BookingRepository _repository;

  BookingRepository get repository => _repository;
}
