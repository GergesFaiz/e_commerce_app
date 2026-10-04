# E-Commerce App (Flutter)

A fully functional e-commerce mobile application built with **Flutter**, following a **clean architecture** with feature-first modularity. UI implements the **Route E-Commerce App Figma design** (Poppins, `#004182` / `#06004F`, Splash, Sign in/up, Home, Categories, Product list/details, Cart, Wishlist, Account).

> Built with the Route Misr e-commerce API (`https://ecommerce.routemisr.com`).

## Features

- 🔐 **Authentication** – login, register, forgot/reset password, token verification on launch, 401 session clear
- 🏠 **Home** – header (logo, search, cart badge), promo slider, 2-row categories, brands and best sellers
- 🗂️ **Categories** – side rail, category banner and subcategory grid (opens filtered products)
- 🛍️ **Products** – server search, price sort, category/subcategory/brand filters, infinite pagination, pull-to-refresh, offline cache
- 📄 **Product details** – image gallery, sold count, rating, quantity, description, reviews
- 🛒 **Cart** – add with quantity, update/remove by product id, clear, cash checkout with saved addresses
- ❤️ **Wishlist** – hearts stay in sync on every screen (one app-wide cubit)
- 👤 **Account** – profile edit, change password, saved addresses, orders, logout

## Design

Screens follow the [Route E-Commerce Figma](https://www.figma.com/file/ZvbLqA2q9GudEss5hq0llH/Route-E-Commerce-App):
Poppins, primary `#004182`, text `#06004F` (60% for secondary text), outlines at 30% primary,
rounded 15px cards and a blue bottom bar where the active tab sits in a white circle.
The four tabs (Home, Categories, Wishlist, Account) are a `StatefulShellRoute`, so each keeps its state;
product lists, details, cart and orders open full-screen above it.

Deliberate differences, driven by the API:

- Subcategories have no images in the API, so their tiles reuse the parent category image.
- Products have no size/colour variants; the size and colour pickers on the details screen are visual only.
- The cart row shows the brand where the design shows colour/size.

## API

Models are parsed leniently to match the real [Route API](https://documenter.getpostman.com/view/5709532/2s93JqTRWN) payloads:
documents use `_id`, references come either populated or as bare ids (e.g. `POST /cart`, `POST /orders`),
`GET /orders/user/{id}` returns a bare array with a numeric `id` order number, and clearing the cart returns only `{message}`.
Cart updates and removals use the **product id**, and a user without a cart (404) sees an empty cart.

## Screenshots

> Add screenshots under `screenshots/` (e.g. `home.png`, `products.png`, `cart.png`) and reference them here.
> Recruiters screen repos in ~30 seconds — 4-5 real screenshots + a 30s demo video link doubles callbacks.

```
screenshots/
├── home.png
├── products.png
├── product_details.png
├── cart.png
└── orders.png
```

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

**88 unit & widget tests** covering model parsing against real API payload shapes, entity mapping, use cases, cubits (auth, products, cart, wishlist, reviews, addresses), price formatting, API error messages and widgets (product card, bottom bar, stepper, login screen).

```bash
flutter test
```

| Area          | Files                                               |
| ------------- | --------------------------------------------------- |
| Models        | `test/models/*_test.dart`                           |
| Use cases     | `test/usecases/login_usecase_test.dart`             |
| Cubits        | `test/cubits/*_cubit_test.dart`                     |
| Utils         | `test/utils/*_test.dart`                            |
| Widgets       | `test/widgets/*_test.dart`                          |
| Test helpers  | `test/helpers/fake_auth_repo.dart`                  |

## CI

GitHub Actions runs `dart analyze` + `flutter test` on every push/PR (`.github/workflows/flutter_ci.yml`).