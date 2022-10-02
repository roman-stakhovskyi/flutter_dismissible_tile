<p align="center">
<a href="https://pub.dev/packages/flutter_dismissible_tile"><img src="https://img.shields.io/pub/v/flutter_dismissible_tile.svg" alt="Pub"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

## Features

Dismissible tile and animated background on swipe. Swipe to trigger an action.

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
    child: // add your widget here
);
```
## Parameters

You can read all the information about DismissibleTile properties below.

```dart
const DismissibleTile({
    required Key key,
    required this.child,
    this.ltrBackground,
    this.rtlBackground,
    this.ltrDismissedColor,
    this.rtlDismissedColor,
    this.ltrOverlay,
    this.rtlOverlay,
    this.ltrOverlayDismissed,
    this.rtlOverlayDismissed,
    this.ltrOverlayTransitionBuilder = overlayTransitionBuilder,
    this.rtlOverlayTransitionBuilder = overlayTransitionBuilder,
    this.ltrOverlayIndent = 24.0,
    this.rtlOverlayIndent = 24.0,
    this.onResize,
    this.onUpdate,
    this.onDismissed,
    this.confirmDismiss,
    this.onDismissConfirmed,
    this.delayBeforeResize,
    this.onDismissiblePainter,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.direction = DismissibleTileDirection.horizontal,
    this.resizeDuration = const Duration(seconds: 1),
    this.movementDuration = const Duration(milliseconds: 300),
    this.overlayTransitionDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const <DismissibleTileDirection, double>{},
    this.crossAxisEndOffset = 0.0,
    this.behavior = HitTestBehavior.opaque,
});

/// The widget below this widget in the tree.
///
/// {@macro flutter.widgets.ProxyWidget.child}
final Widget child;

/// The amount of space by which to inset the child.
final EdgeInsets padding;

/// The border radius of the rounded corners.
///
/// Values are clamped so that horizontal and vertical radii sums do not
/// exceed width/height.
final BorderRadiusGeometry borderRadius;

/// A widget that is stacked behind the child. If [rtlBackground] is
/// also specified then this widget only appears when the child has been
/// dragged to the right.
final Widget? ltrBackground;

/// A widget that is stacked behind the child and is exposed when the child
/// has been dragged to the left. It may only be specified when
/// [ltrBackground] has also been specified.
final Widget? rtlBackground;

/// A Color that is stacked behind the child and over [ltrBackground]
/// and is exposed when the child has been dragged to the right.
final Color? ltrDismissedColor;

/// A Color that is stacked behind the child and over [rtlBackground]
/// and is exposed when the child has been dragged to the left.
final Color? rtlDismissedColor;

/// A Widget that is stacked behind the child and over [ltrDismissedColor]
/// and is exposed when the child has been dragged to the right.
final Widget? ltrOverlay;

/// A Widget that is stacked behind the child and over [rtlDismissedColor]
/// and is exposed when the child has been dragged to the left.
final Widget? rtlOverlay;

/// The widget that is displayed instead of [ltrOverlay] when [confirmDismiss]
/// returns true.
///
/// If [confirmDismiss] returned false or null then the widget is not displayed.
final Widget? ltrOverlayDismissed;

/// The widget that is displayed instead of [rtlOverlay] when [confirmDismiss]
/// returns true.
///
/// If [confirmDismiss] returned false or null then the widget is not displayed.
final Widget? rtlOverlayDismissed;

/// Signature for builders used to generate custom transitions for [ltrOverlay].
///
/// The `child` should be transitioning in when the `animation` is running in
/// the forward direction.
///
/// The function should return a widget which wraps the given `child`. It may
/// also use the `animation` to inform its transition. It must not return null.
final AnimatedSwitcherTransitionBuilder ltrOverlayTransitionBuilder;

/// Signature for builders used to generate custom transitions for [rtlOverlay].
///
/// The `child` should be transitioning in when the `animation` is running in
/// the forward direction.
///
/// The function should return a widget which wraps the given `child`. It may
/// also use the `animation` to inform its transition. It must not return null.
final AnimatedSwitcherTransitionBuilder rtlOverlayTransitionBuilder;

/// Indent for [ltrOverlay] on the right. Used for case, when [ltrOverlay] is
/// shown earlier than [ltrDismissedColor] is appeared.
final double ltrOverlayIndent;

/// Indent for [rtlOverlay] on the left. Used for case, when [rtlOverlay] is
/// shown earlier than [rtlDismissedColor] is appeared.
final double rtlOverlayIndent;

/// Gives the app an opportunity to confirm or veto a pending dismissal.
///
/// The widget cannot be dragged again until the returned future resolves.
///
/// If the returned Future<bool> completes true, then this widget will be
/// dismissed, otherwise it will be moved back to its original location.
///
/// If the returned Future<bool?> completes to false or null the [onResize]
/// and [onDismissed] callbacks will not run.
final Future<bool?> Function(DismissibleTileDirection direction)? confirmDismiss;

/// Called when the widget can be dismissed before resizing begins.
///
/// It will be called before the start of the [delayBeforeResize] delay.
final void Function()? onDismissConfirmed;

/// Called when the widget changes size (i.e., when contracting before being dismissed).
final VoidCallback? onResize;

/// Called when the widget has been dismissed, after finishing resizing.
final void Function(DismissibleTileDirection direction)? onDismissed;

/// The direction in which the widget can be dismissed.
final DismissibleTileDirection direction;

/// Defines a delay before the resize animation starts.
///
/// if null, then the resize animation starts immediately.
final Duration? delayBeforeResize;

/// The painter that is stacked behind the child and over the background
/// and behind the overlay widget.
final CustomPainter Function(double indent,
    Animation<double> animation,
    DismissibleTileDirection direction,
    )? onDismissiblePainter;

/// The amount of time the widget will spend contracting before [onDismissed]
/// is called.
/// If null, the widget will not contract and [onDismissed] will be called
/// immediately after the widget is dismissed.
final Duration? resizeDuration;

/// Defines the duration for card to dismiss or to come back to original
/// position if not dismissed.
final Duration movementDuration;

/// Defines the duration of the animation switching between the overlay and
/// the dismissedOverlay
///
/// if the dismissedOverlay == null, then the animation is not used
final Duration overlayTransitionDuration;

/// The offset threshold the item has to be dragged in order to be considered
/// dismissed.
///
/// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
/// has to be dragged at least 40% towards one direction to be considered
/// dismissed. Clients can define different thresholds for each dismiss
/// direction.
///
/// Flinging is treated as being equivalent to dragging almost to 1.0, so
/// flinging can dismiss an item past any threshold less than 1.0.
///
/// Setting a threshold of 1.0 (or greater) prevents a drag in the given
/// [DismissibleTileDirection] even if it would be allowed by the [direction]
/// property.
final Map<DismissibleTileDirection, double> dismissThresholds;

/// Defines the end offset across the main axis after the card is dismissed.
///
/// If non-zero value is given then widget moves in cross direction depending
/// on whether it is positive or negative.
final double crossAxisEndOffset;

/// How to behave during hit tests.
///
/// This defaults to [HitTestBehavior.opaque].
final HitTestBehavior behavior;

/// Called when the dismissible widget has been dragged.
///
/// If [onUpdate] is not null, then it will be invoked for every pointer event
/// to dispatch the latest state of the drag. For example, this callback
/// can be used to for example change the color of the background widget
/// depending on whether the dismiss threshold is currently reached.
final DismissTileUpdateCallback? onUpdate;
```
