# Flutter Preference Engine

A production-style Flutter application built for an engineering assessment. The app consumes product data from Fake Store API, lets users record like/dislike preferences, opens product pages inside an in-app browser, and persists both preferences and browsing history across launches.

## Features

- Product feed backed by `https://fakestoreapi.com/products`.
- Robust loading, empty, and error states.
- Pull-to-refresh support.
- Like/dislike toggling with immediate visual feedback.
- Preference persistence using `SharedPreferences` keyed by product id.
- In-app browser using `webview_flutter`.
- URL tracking through `NavigationDelegate`.
- Persistent browsing history with duplicate prevention.
- Dedicated history screen with clear-history action.
- Search and category filtering.
- In-memory repository cache for feed reuse.
- Unit test example for `ProductFeedViewModel`.

## Architecture (MVVM)

The project follows a strict MVVM layering:

- **models/**
  - Pure data models (`Product`) with serialization and Equatable support.
- **services/**
  - API boundary (`ProductService`) for HTTP requests and transport errors.
- **repositories/**
  - Data composition/caching (`ProductRepository`), abstracts service details from ViewModels.
- **viewmodels/**
  - App state + UI behavior (`ProductFeedViewModel`, `PreferenceViewModel`, `BrowserHistoryViewModel`).
  - Handles loading lifecycle, filters, persistence orchestration, and user actions.
- **views/**
  - Thin reactive screens bound to ViewModels through Provider.
- **widgets/**
  - Reusable presentation components (`ProductCard`, `PreferenceButton`).
- **utils/**
  - Small stateless helpers/enums (`PreferenceType`, URL builder).

### Why Provider + ChangeNotifier

Provider is lightweight, battle-tested, and easy to reason about in interview settings. It gives:

- Simple DI setup at app root with `MultiProvider`.
- Clear ownership of mutable state in dedicated ViewModels.
- Low boilerplate while still enforcing architectural boundaries.

### Persistence design

- Preferences are serialized as `{ "productId": "liked|disliked" }` JSON and stored as a single SharedPreferences string.
- Browser history is persisted as `List<String>` in SharedPreferences.
- Both ViewModels load persisted state during app startup before rendering, ensuring continuity.

### WebView tracking design

- Product pages are opened in `ProductWebViewPage`.
- `NavigationDelegate.onPageFinished` forwards the resolved URL to `BrowserHistoryViewModel.trackUrl(...)`.
- History model ignores empty/non-http URLs and deduplicates entries.

## Folder structure

```text
lib/
  main.dart
  models/
  services/
  repositories/
  viewmodels/
  views/
  widgets/
  utils/
test/
  product_feed_viewmodel_test.dart
```

## Tradeoffs

- Fake Store API does not provide canonical PDP URLs, so product web links use `https://fakestoreapi.com/products/{id}`.
- SharedPreferences is sufficient for this scope; if history or metadata grows, a local DB (Drift/SQLite) would be preferred.
- Current caching is in-memory only and intentionally simple.

## With more time

- Add integration tests for persistence + WebView tracking.
- Add offline-first cache with stale-while-revalidate strategy.
- Introduce typed failure objects and richer error analytics.
- Add pagination support and skeleton loading placeholders.

## Approximate time spent

~4.5 to 5.5 hours including architecture planning, implementation, and documentation.

## How to run

1. Install Flutter stable SDK.
2. Run:
   ```bash
   flutter pub get
   flutter run
   ```
3. Run tests:
   ```bash
   flutter test
   ```

