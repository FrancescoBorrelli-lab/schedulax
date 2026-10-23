import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/app/app.dart';
import 'src/shared/data/booking_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('it');
  runApp(SchedulaXApp(repository: InMemoryBookingRepository()));
}
