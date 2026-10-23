import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedulax/src/app/app.dart';
import 'package:schedulax/src/mobile/booking_page.dart';
import 'package:schedulax/src/mobile/history_page.dart';
import 'package:schedulax/src/shared/data/booking_repository.dart';

void main() {
  setUpAll(() => initializeDateFormatting('it'));

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      SchedulaXApp(repository: InMemoryBookingRepository()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'su schermo stretto usa la barra in basso e nasconde la dashboard',
    (tester) async {
      await pumpAt(tester, const Size(400, 800));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('Dashboard'), findsNothing);
    },
  );

  testWidgets('su schermo largo usa la barra laterale con la dashboard', (
    tester,
  ) async {
    await pumpAt(tester, const Size(1200, 800));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('prenotando, la prenotazione compare nello storico', (
    tester,
  ) async {
    await pumpAt(tester, const Size(400, 900));
    await tester.enterText(find.byType(TextField), 'Anna');
    // Primo slot libero e non passato: ultimo del giorno più lontano disponibile.
    final chips = find.byType(ChoiceChip);
    final enabled = chips
        .evaluate()
        .map((e) => e.widget as ChoiceChip)
        .toList();
    final index = enabled.lastIndexWhere((c) => c.onSelected != null);
    await tester.tap(chips.at(index));
    await tester.pump();
    await tester.tap(find.text('Conferma prenotazione'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Storico'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Anna'), findsOneWidget);
  });

  testWidgets('cambiando pagina non restano visibili due pagine insieme', (
    tester,
  ) async {
    await pumpAt(tester, const Size(400, 900));
    expect(find.byType(BookingPage), findsOneWidget);

    await tester.tap(find.text('Storico'));
    // Un solo frame dopo il tocco, a metà dell'eventuale transizione.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(HistoryPage), findsOneWidget);
    expect(find.byType(BookingPage), findsNothing);
  });
}
