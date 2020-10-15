# synthetics

An Automatic Carbon Footprint Calculator

## Organisation

The organisation structure of this application is according to Connor Aldrich's
[Flutter: Code Organization (Revised)](https://medium.com/flutter-community/flutter-code-organization-revised-b09ad5cef7f6)

The brief can be seen here:

### `main.dart`

The foundation of this Flutter app, aimed to be kept as lightweight as possible

### `routes.dart`

Extracted from `main.dart` are the routes for this application, equivalent to routing controller in
react. Contains routes to publicly accessible node pages, any pages accessible exclusively to a
node page will not feature here

*For example, see `image_taker_page/`*

### `theme/`

Contains a singular `style.dart` with the app's theme, to be accessed by `main.dart`

### `services`

Holds web APIs and native interaction code

### `components`

Custom widgets which are used by multiple different screens

### `screens`

Holds a folder for each screen subtree, pages accessible from the main routes are built here. Each
directory holds the pages relevant to a specific group.

## Some resources to help familiarise yourselves with Flutter

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
