# Flutter Store App

Starter Flutter storefront for the Laravel ecommerce backend in the parent project.

## Stack

- `flutter_bloc` with Cubit
- `dio` + `retrofit`
- shared `StoreRepository`
- Laravel store API at `/api/v1/store`

## Run

Install packages:

```bash
flutter pub get
```

Run against local XAMPP on Android emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2/iposLaravel/public
```

Run against local XAMPP on iOS simulator or desktop:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1/iposLaravel/public
```

## Current App Areas

- Home
- Shop
- Cart
- Account

The Account tab currently accepts a Sanctum token manually so protected cart endpoints can be tested before the full login flow is added.
