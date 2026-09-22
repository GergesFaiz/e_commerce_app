# E-Commerce App (Flutter)

A fully functional e-commerce mobile application built with **Flutter**, following a **clean architecture** with feature-first modularity. It integrates with a live REST API to fetch products, categories, brands, cart and orders in real time.

> Built with the Route Misr e-commerce API (`https://ecommerce.routemisr.com`).

## Features

- 🔐 **Authentication** – login, register, forgot password (token persisted locally)
- 🏠 **Home** – categories & brands fetched from the API
- 🛍️ **Products** – product listings + product details (price, discounts, ratings, images)
- 🛒 **Cart** – add, update quantity, remove items
- ❤️ **Wishlist** – save and remove favorite products
- 📦 **Orders** – checkout and order history

## Architecture

Feature-first **Clean Architecture**, split into:

```
lib/
├── core/               # shared infrastructure
│   ├── di/             # get_it service locator
│   ├── error/          # failures & exceptions (dartz Either)
│   ├── network/        # dio + retrofit API service
│   ├── router/         # go_router configuration
│   ├── theme/          # colors & theme
│   ├── utils/          # constants, cache helper
│   └── widgets/        # loading & error widgets
└── features/           # one folder per feature
    ├── auth/           # onboarding, login, register
    ├── home/           # categories & brands
    ├── products/       # listing & details
    ├── cart/           # shopping cart
    ├── wishlist/       # favorites
    └── orders/         # checkout & history
```

Each feature follows the standard layers:

- **data** – models (`json_serializable`), remote datasource (retrofit), repository implementation
- **domain** – entities, repository contracts, use cases
- **presentation** – Bloc cubits, screens, widgets

## Tech Stack

| Concern        | Package                          |
| -------------- | -------------------------------- |
| State          | `flutter_bloc` (cubits)          |
| DI             | `get_it`                         |
| Networking     | `dio` + `retrofit`               |
| Routing        | `go_router`                      |
| JSON           | `json_serializable`              |
| Caching        | `shared_preferences`             |
| Error handling | `dartz` (Either)                 |
| UI utils       | `flutter_screenutil`, `cached_network_image`, `fluttertoast` |

## Code Generation

Models and the API service are generated:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

```bash
flutter pub get
flutter run
```

## Tests

**49 unit & widget tests** covering model JSON round-trips, entity mapping, use cases, cubits (auth flows) and key widgets (loading, error, login screen).

```bash
flutter test
```

| Area          | Files                                               |
| ------------- | --------------------------------------------------- |
| Models        | `test/models/*_test.dart`                           |
| Use cases     | `test/usecases/login_usecase_test.dart`             |
| Cubits        | `test/cubits/auth_cubit_test.dart`                  |
| Widgets       | `test/widgets/core_widgets_test.dart`, `test/widgets/login_screen_test.dart` |
| Test helpers  | `test/helpers/fake_auth_repo.dart`                  |