# Places

A SwiftUI iOS app that lists locations fetched from a remote JSON endpoint and opens each one in a companion "Wikipedia" app via a custom URL scheme. Users can also enter a custom latitude/longitude, which is added to the same list.

## Requirements

- Xcode 26 or newer
- iOS 26.5 simulator or device (deployment target set in the project)

## Running

1. Open `Places.xcodeproj` in Xcode.
2. Select the `Places` scheme and an iOS Simulator.
3. Run (`Cmd+R`).

The app fetches locations from `https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json` on launch. No API keys or configuration needed.

Because the "Wikipedia" companion app referenced by the assignment isn't a public App Store app, tapping a location on a Simulator/device without it installed shows a "Wikipedia app isn't installed" alert instead of navigating away — this is the intended fallback behavior, not a bug.

## Architecture

The codebase follows Clean Architecture, split into independent layers under `Places/`:

- **Domain** — pure Swift, no dependency on networking or UI frameworks.
  - `Entities`: `Location` (name is optional — not every source location has one), `Coordinate` (raw lat/lon only; formatting it for display is a presentation concern).
  - `Repositories`: `LocationsRepository` protocol — the seam the rest of the app depends on. It owns the current list of locations: `fetchLocations()` refreshes it, `addLocation(_:)` appends to it, so callers always see one consistent list.
  - `UseCases`: `FetchLocationsUseCase`, `AddLocationUseCase`, `ValidateCoordinateUseCase` (pure, synchronous coordinate validation).
  - `Services`: `WikipediaLinkBuilder` (builds `wikipedia://places?lat=&lon=` URLs), `ExternalAppOpener` (abstraction over `UIApplication`, so opening external URLs is mockable), `WikipediaOpener` (the shared "open this coordinate" flow used by every screen that needs it).
- **Data** — implements the domain protocols, in three tiers.
  - `DTOs`: `LocationsResponseDTO`/`LocationDTO` (Codable, matching the `{ "locations": [{ "name"?, "lat", "long" }] }` shape) and a mapping extension to the domain `Location` — a missing/blank name maps to `nil`.
  - `NetworkService`: a thin, domain-agnostic `URLSession` wrapper.
  - `LocationsService`: fetches and decodes the remote locations payload via `NetworkService`, owning the endpoint URL.
  - `LocationRepositoryImpl`: an `actor` implementing `LocationsRepository`. Uses `LocationsService` to fetch and keeps the result in memory, so locations added by the user live alongside the fetched ones in one concurrency-safe list.
- **Presentation** — one feature folder per screen (`PlacesList`, `AddLocation`), each with the same shape:
  - A `LocalizationProvider` owning every user-facing string for that screen (including how domain errors are worded), consumed only by the view model — views never reference it directly.
  - A `ViewProps` value type: the single entity the view renders from, instead of many individual observable properties.
  - A `ViewModel`, `@Observable`, with one `performAction(_:)` entry point the view calls instead of individual methods. Text field edits are plain two-way bindings into `props`, since they're continuous input rather than discrete commands. Built on Swift Concurrency (`async`/`await`) throughout.
  - `AppDependencies` is the composition root: wires `NetworkService` → `LocationsService` → `LocationRepositoryImpl` and both use cases behind it (same repository instance, so fetched and added locations share state), plus `WikipediaOpener`. No DI framework — the object graph is small enough to wire by hand.
- **DesignSystem** — a small reusable component library and token set (`DSColor`, `DSSpacing`) modeled on the Claude Design mockup handed off for this project. Only genuinely screen-agnostic components live here (`PrimaryButton`, `DSTextField`, `ErrorStateView`, `EmptyStateView`, `LoadingSkeletonList`, `CircularIconButton`); anything that knows about a domain type, like the location row, lives with its feature instead (`Presentation/PlacesList/PlaceRow.swift`).

### Design fidelity notes

The mockup specifies "Cormorant Garamond" (headings) and "Lora" (body) — Google Fonts not available on iOS without bundling font files, which weren't included in the design handoff. Screens use native Apple text styles (`.title`, `.body`, `.footnote`, etc.) directly, with `.fontDesign(.serif)` applied where the mockup calls for the serif look — fully Dynamic Type-native without any custom font-scaling code. Colors and spacing are transcribed from the mockup's design tokens (spacing rounded to a multiple-of-4 scale).

## Wikipedia deep link

Tapping a location **in the list** calls:

```
wikipedia://places?lat=<latitude>&lon=<longitude>
```

via `UIApplication.shared.open`. The scheme is declared in `LSApplicationQueriesSchemes` (`Info.plist`) so `canOpenURL` can check for it; if it's not installed, the app shows an alert rather than failing silently.

The "Add a location" sheet only validates and appends the custom coordinate to the list — it does not open Wikipedia itself. The new row behaves exactly like any fetched location: tap it to open Wikipedia.

## Testing

Unit tests use the [Swift Testing](https://developer.apple.com/documentation/testing) framework (`PlacesTests/`), covering:

- Coordinate formatting (N/S/E/W sign handling, zero) and coordinate validation (range boundaries, non-numeric input).
- DTO → domain mapping, including the missing-name-becomes-`nil` case.
- `LocationsService` against a fake network service (success, network failure, malformed JSON) and `LocationRepositoryImpl` (fetch stores/returns the list, add appends and returns the growing list, including adding before any fetch).
- View model behavior for both screens via their single `performAction(_:)` entry point — state transitions (`loading`/`loaded`/`empty`/`error`), the Wikipedia-opening flow (URL correctness and the "app not installed" path), and form validation — using fake `ExternalAppOpener`/`LocationsRepository` implementations so nothing touches a real `UIApplication` or network call.

Run tests via Xcode's Test navigator or:

```
xcodebuild test -project Places.xcodeproj -scheme Places -destination 'platform=iOS Simulator,name=<a simulator name>'
```

## Accessibility

- All interactive elements (rows, buttons, form fields) have explicit accessibility labels/values/traits, and decorative elements are hidden from VoiceOver.
- Typography uses native Apple text styles, so it scales with Dynamic Type automatically.
- The loading skeleton respects Reduce Motion.
- The app only targets iOS (`TARGETED_DEVICE_FAMILY`/`SUPPORTED_PLATFORMS` were narrowed from the initial multiplatform scaffold), since the core feature — opening a companion iOS app via `UIApplication` — doesn't apply to macOS/visionOS.
