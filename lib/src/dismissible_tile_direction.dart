enum DismissibleTileDirection {
  /// The DismissibleTile can be dismissed by dragging either left or right.
  horizontal,

  /// The DismissibleTile can be dismissed by dragging to the left.
  rightToLeft,

  /// The DismissibleTile can be dismissed by dragging to the right.
  leftToRight,

  /// The DismissibleTile cannot be dismissed by dragging.
  none
}
