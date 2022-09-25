import 'package:flutter_dismissible_tile/src/dismissible_tile_direction.dart';

/// Details for DismissTileUpdateCallback.
///
/// See also:
///
///   * DismissibleTile.onUpdate, which receives this information.
class DismissibleTileUpdateDetails {
  DismissibleTileUpdateDetails({
    this.direction = DismissibleTileDirection.horizontal,
    this.reached = false,
    this.previousReached = false,
    this.progress = 0.0,
  });

  /// The direction that the dismissible is being dragged.
  final DismissibleTileDirection direction;

  /// Whether the dismiss threshold is currently reached.
  final bool reached;

  /// Whether the dismiss threshold was reached the last time this callback was
  /// invoked.
  /// This can be used in conjunction with [DismissibleTileUpdateDetails.reached] to
  /// catch the moment that the DismissibleTile is dragged across the threshold.
  final bool previousReached;

  /// The offset ratio of the dismissible in its parent container.
  ///
  /// A value of 0.0 represents the normal position and 1.0 means the child is
  /// completely outside its parent.
  ///
  /// This can be used to synchronize other elements to what the dismissible is
  /// doing on screen, e.g. using this value to set the opacity thereby fading
  /// dismissible as it's dragged offscreen.
  final double progress;

  @override
  String toString() {
    return 'DismissibleTileUpdateDetails{direction: $direction, '
        'reached: $reached, previousReached: $previousReached, '
        'progress: $progress}';
  }
}
