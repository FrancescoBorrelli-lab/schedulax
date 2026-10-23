# SchedulaX

Piattaforma di prenotazione integrata: Dashboard amministrativa Web e App Mobile per utenti finali.

> 🚧 **Stato: in progettazione.** Questa repo contiene per ora solo la documentazione del progetto (problema, soluzione e stack previsto): il codice non è ancora stato scritto. Le sezioni qui sotto descrivono ciò che l'app farà, non ciò che è già implementato.

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

## Struttura prevista
- `/lib/src/web`: UI specifica per desktop/browser.
- `/lib/src/mobile`: UI specifica per dispositivi mobile.
- `/lib/src/shared`: Modelli, repository e logica di business condivisa.

## Obiettivo
L'obiettivo è dimostrare la capacità di creare applicazioni responsive che si adattano dinamicamente al form factor (Desktop vs Mobile) e la gestione di flussi di prenotazione in tempo reale.

## Licenza

[MIT](LICENSE)

## Autore

**Francesco Borrelli**, sviluppatore mobile, [borrellifrancesco.dev](https://borrellifrancesco.dev).
