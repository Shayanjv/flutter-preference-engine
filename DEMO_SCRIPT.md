# 3–5 Minute Demo Script

## 0:00–0:30 — Intro
“Hi, I’m walking through my Flutter Preference Engine app. The core goal was to prioritize engineering quality over visual complexity, so I built this with a strict MVVM structure, Provider-based dependency injection, and persistent state for both product preferences and browser history.”

## 0:30–1:30 — Architecture Decisions
“I split responsibilities into `models`, `services`, `repositories`, `viewmodels`, and `views/widgets`.

- `ProductService` handles raw HTTP calls to Fake Store API.
- `ProductRepository` abstracts service usage and adds a lightweight in-memory cache.
- ViewModels own app behavior:
  - `ProductFeedViewModel` handles loading, refreshing, search/category filters, and feed states.
  - `PreferenceViewModel` manages like/dislike state and persistence.
  - `BrowserHistoryViewModel` tracks visited URLs and persistence.

UI widgets stay intentionally thin and reactive.”

## 1:30–2:20 — State Management and UX
“At app root I use `MultiProvider` for clean DI and lifecycle management. Feed screen uses `Consumer2` to react to both product and preference updates. Pull-to-refresh triggers forced repository refresh.

I explicitly handle three data states: loading spinner, error message, and empty-state messaging. Like/dislike has immediate visual feedback and subtle animation using `AnimatedScale`.”

## 2:20–3:20 — Persistence + WebView Tracking
“Preferences are keyed by product ID and stored in SharedPreferences as serialized JSON. Browser history is stored as a persistent string list and loaded on startup.

When a product page opens in WebView, the `NavigationDelegate` captures the final URL in `onPageFinished`, then forwards it to `BrowserHistoryViewModel`. The ViewModel deduplicates URLs and ignores invalid ones. There’s also a dedicated history screen and clear-history action.”

## 3:20–4:10 — Bonus Enhancements + Quality
“I included multiple bonus items:

- Search functionality.
- Category filtering.
- Simple in-memory caching.
- Fade-in image loading animation.
- Unit test example for `ProductFeedViewModel`.
- Equatable model usage.

This keeps complexity practical while showing production-minded structure.”

## 4:10–5:00 — Tradeoffs and Next Steps
“The main tradeoff is that Fake Store API doesn’t expose direct storefront links, so I route WebView to product API endpoints by ID. With more time, I’d add integration tests, richer typed failures, and an offline-first storage layer with stale-while-revalidate behavior.”

