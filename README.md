# SchedulaX

Piattaforma di prenotazione integrata: Dashboard amministrativa Web e App Mobile per utenti finali.

> 🚧 **Stato: base funzionante, in sviluppo.** L'app si avvia e permette di prenotare, annullare e consultare lo storico, con layout diverso su telefono e desktop. I dati sono **in memoria**: Firebase (Firestore e Cloud Functions), l'autenticazione e le notifiche push **non sono ancora collegati**.

## Il Problema
I professionisti e i centri sportivi hanno bisogno di gestire appuntamenti in modo flessibile, evitando sovrapposizioni e offrendo ai clienti un'esperienza di prenotazione fluida, tutto con un unico strumento.

## La Soluzione
Un ecosistema completo basato su un'unica codebase Flutter:
- **Web Dashboard:** Per l'amministratore (gestione slot, calendario, statistiche clienti).
- **Mobile App:** Per l'utente finale (prenotazione in tempo reale, notifiche push, storico appuntamenti).
- **Single Codebase:** Manutenzione semplificata e coerenza UI tra web e mobile.

## Tech Stack
- **Framework:** Flutter (Web/Mobile)
- **State Management:** BLoC
- **Backend:** Firebase (Firestore + Cloud Functions)
- **Routing:** GoRouter (Gestione URL per il web)

## Struttura
- `lib/src/shared`: modelli, repository (in memoria) e `BookingsBloc`, condivisi tra web e mobile.
- `lib/src/mobile`: flusso di prenotazione e storico.
- `lib/src/web`: dashboard dell'amministratore.
- `lib/src/app`: router (GoRouter) e shell che passa da barra in basso a barra laterale sopra 900 px.

## Come provarla

```sh
flutter pub get
flutter run -d chrome   # oppure un emulatore: la dashboard compare sopra 900 px di larghezza
flutter test
```

Cosa funziona oggi: scelta di giorno e orario tra gli slot liberi, controllo delle sovrapposizioni (con test), annullamento, storico, e dashboard con numeri e agenda visibile solo su schermi larghi.

## Obiettivo
L'obiettivo è dimostrare la capacità di creare applicazioni responsive che si adattano dinamicamente al form factor (Desktop vs Mobile) e la gestione di flussi di prenotazione in tempo reale.

## Licenza

[MIT](LICENSE)

## Autore

**Francesco Borrelli**, sviluppatore mobile, [borrellifrancesco.dev](https://borrellifrancesco.dev).
