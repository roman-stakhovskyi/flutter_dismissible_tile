<p align="center">
<a href="https://pub.dev/packages/flutter_dismissible_tile"><img src="https://img.shields.io/pub/v/flutter_dismissible_tile.svg" alt="Pub"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

## Features

#### Dismissible tile and animated background on swipe. Swipe to trigger an action.

The package is fork of [Dismissible](https://api.flutter.dev/flutter/widgets/Dismissible-class.html). Without any up, down or vertical swipe.

<img src="https://raw.githubusercontent.com/roman-stakhovskyi/flutter_dismissible_tile/master/assets/demo.gif"  width="400"/>

## Getting Started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_dismissible_tile: any
```

Import it:

```dart
import 'package:flutter_dismissible_tile/flutter_dismissible_tile.dart';
```

## Usage
You can read all the information about the DismissibleTile parameters in the documentation.
```dart
DismissibleTile(
    key: UniqueKey(),
    padding: const EdgeInsets.symmetric(vertical: 8),
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    delayBeforeResize: const Duration(milliseconds: 500),
    ltrBackground: const ColoredBox(color: Colors.yellowAccent),
    rtlBackground: const ColoredBox(color: Colors.greenAccent),
    ltrDismissedColor: Colors.lightBlueAccent,
    rtlDismissedColor: Colors.redAccent,
    ltrOverlay: const Text('Add'),
    ltrOverlayDismissed: const Text('Added'),
    rtlOverlay: const Text('Delete'),
    rtlOverlayDismissed: const Text('Deleted'),
    child: // your child
);
```
