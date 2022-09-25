import 'package:flutter/material.dart';
import 'package:flutter_dismissible_tile/src/dismissible_overlay.dart';
import 'package:flutter_dismissible_tile/src/dismissible_tile_direction.dart';
import 'package:flutter_dismissible_tile/src/dismissible_tile_update_details.dart';

const _resizeTimeCurve = Interval(0.4, 1.0, curve: Curves.ease);
const _minFlingVelocity = 700.0;
const _minFlingVelocityDelta = 400.0;
const _flingVelocityScale = 1.0 / 300.0;
const _threshold = 0.4;

/// Signature used by [DismissibleTile] to indicate that the dismissible tile
/// has been dragged.
///
/// Used by [DismissibleTile.onUpdate].
typedef DismissTileUpdateCallback = void Function(
  DismissibleTileUpdateDetails details,
);

class DismissibleTile extends StatefulWidget {
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
  })  : assert(ltrOverlayIndent >= 0.0),
        assert(rtlOverlayIndent >= 0.0),
        super(key: key);

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
  final Future<bool?> Function(DismissibleTileDirection direction)?
      confirmDismiss;

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
  final CustomPainter Function(
    double indent,
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

  static Widget overlayTransitionBuilder(
    Widget child,
    Animation<double> animation,
  ) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );

  @override
  State<StatefulWidget> createState() => _DismissibleTileState();
}

enum _FlingGestureKind { none, forward, reverse }

class _DismissibleTileState extends State<DismissibleTile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _updateMoveAnimation();
  }

  late final _moveController = AnimationController(
    vsync: this,
    duration: widget.movementDuration,
  )
    ..addListener(_handleDismissUpdateValueChanged)
    ..addStatusListener(_handleDismissStatusChanged);

  late Animation<Offset> _moveAnimation;

  late final _resizeController = AnimationController(
    vsync: this,
    duration: widget.resizeDuration,
  )
    ..addListener(_handleResizeProgressChanged)
    ..addStatusListener((status) => updateKeepAlive());

  Animation<double>? _resizeAnimation;

  double _dragExtent = 0.0;
  bool _confirming = false;
  bool _dragUnderway = false;
  Size? _sizePriorToCollapse;
  bool _dismissThresholdReached = false;

  @override
  bool get wantKeepAlive =>
      _moveController.isAnimating || _resizeController.isAnimating;

  @override
  void dispose() {
    _moveController.dispose();
    _resizeController.dispose();
    super.dispose();
  }

  DismissibleTileDirection _extentToDirection(double extent) {
    if (extent == 0.0) {
      return DismissibleTileDirection.none;
    } else if (extent > 0.0) {
      return DismissibleTileDirection.leftToRight;
    } else {
      return DismissibleTileDirection.rightToLeft;
    }
  }

  DismissibleTileDirection get _dismissDirection =>
      _extentToDirection(_dragExtent);

  bool get _isActive => _dragUnderway || _moveController.isAnimating;

  double get _overallDragAxisExtent => context.size!.width;

  double get _dismissThreshold =>
      widget.dismissThresholds[_dismissDirection] ?? _threshold;

  void _handleDragStart(DragStartDetails details) {
    if (_confirming) return;
    _dragUnderway = true;
    if (_moveController.isAnimating) {
      _dragExtent =
          _moveController.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(_updateMoveAnimation);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController.isAnimating) return;

    final delta = details.primaryDelta!;
    final oldDragExtent = _dragExtent;
    switch (widget.direction) {
      case DismissibleTileDirection.horizontal:
        _dragExtent += delta;
        break;
      case DismissibleTileDirection.rightToLeft:
        if (_dragExtent + delta < 0) {
          _dragExtent += delta;
        }
        break;
      case DismissibleTileDirection.leftToRight:
        if (_dragExtent + delta > 0) {
          _dragExtent += delta;
        }
        break;
      case DismissibleTileDirection.none:
        _dragExtent = 0;
        break;
    }
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(_updateMoveAnimation);
    }
    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _handleDismissUpdateValueChanged() {
    if (widget.onUpdate != null) {
      final oldDismissThresholdReached = _dismissThresholdReached;
      _dismissThresholdReached = _moveController.value > _dismissThreshold;
      final details = DismissibleTileUpdateDetails(
        direction: _dismissDirection,
        reached: _dismissThresholdReached,
        previousReached: oldDismissThresholdReached,
        progress: _moveController.value,
      );
      widget.onUpdate!(details);
    }
  }

  void _updateMoveAnimation() {
    final end = _dragExtent.sign;
    _moveAnimation = _moveController.drive(
      Tween(
        begin: Offset.zero,
        end: Offset(end, widget.crossAxisEndOffset),
      ),
    );
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _FlingGestureKind.none;
    }
    final vx = velocity.pixelsPerSecond.dx;
    final vy = velocity.pixelsPerSecond.dy;
    if (vx.abs() - vy.abs() < _minFlingVelocityDelta ||
        vx.abs() < _minFlingVelocity) {
      return _FlingGestureKind.none;
    }
    assert(vx != 0.0);
    final flingDirection = _extentToDirection(vx);
    if (flingDirection == _dismissDirection) {
      return _FlingGestureKind.forward;
    }
    return _FlingGestureKind.reverse;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController.isAnimating) return;
    _dragUnderway = false;
    if (_moveController.isCompleted) {
      _handleMoveCompleted();
      return;
    }
    final flingVelocity = details.velocity.pixelsPerSecond.dx;
    switch (_describeFlingGesture(details.velocity)) {
      case _FlingGestureKind.forward:
        assert(_dragExtent != 0.0);
        assert(!_moveController.isDismissed);
        if (_dismissThreshold >= 1.0) {
          _moveController.reverse();
          break;
        }
        _dragExtent = flingVelocity.sign;
        _moveController.fling(
          velocity: flingVelocity.abs() * _flingVelocityScale,
        );
        break;
      case _FlingGestureKind.reverse:
        assert(_dragExtent != 0.0);
        assert(!_moveController.isDismissed);
        _dragExtent = flingVelocity.sign;
        _moveController.fling(
          velocity: -flingVelocity.abs() * _flingVelocityScale,
        );
        break;
      case _FlingGestureKind.none:
        if (!_moveController.isDismissed) {
          // we already know it's not completed, we check that above
          if (_moveController.value > _dismissThreshold) {
            _moveController.forward();
          } else {
            _moveController.reverse();
          }
        }
        break;
    }
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      await _handleMoveCompleted();
    }
    if (mounted) {
      updateKeepAlive();
    }
  }

  Future<void> _handleMoveCompleted() async {
    if (_dismissThreshold >= 1.0) {
      await _moveController.reverse();
      return;
    }
    final isConfirmed = await _confirmStartResizeAnimation();
    if (!mounted) return;
    if (isConfirmed) {
      widget.onDismissConfirmed?.call();
      setState(() {});
      if (widget.delayBeforeResize != null) {
        _confirming = true;
        await Future.delayed(widget.delayBeforeResize!, () {});
        _confirming = false;
      }
      _startResizeAnimation();
    } else {
      await _moveController.reverse();
    }
  }

  Future<bool> _confirmStartResizeAnimation() async {
    if (widget.confirmDismiss != null) {
      _confirming = true;
      try {
        return await widget.confirmDismiss!(_dismissDirection) ?? false;
      } finally {
        _confirming = false;
      }
    }
    return true;
  }

  void _startResizeAnimation() {
    assert(_moveController.isCompleted);
    assert(_sizePriorToCollapse == null);
    if (widget.resizeDuration == null) {
      widget.onDismissed?.call(_dismissDirection);
    } else {
      _resizeController.forward();
      setState(() {
        _sizePriorToCollapse = context.size;
        _resizeAnimation = _resizeController
            .drive(CurveTween(curve: _resizeTimeCurve))
            .drive(Tween(begin: 1.0, end: 0.0));
      });
    }
  }

  void _handleResizeProgressChanged() {
    if (_resizeController.isCompleted) {
      widget.onDismissed?.call(_dismissDirection);
    } else {
      widget.onResize?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assert(debugCheckHasDirectionality(context));

    final direction = _dismissDirection;
    final isRtlDirection = direction == DismissibleTileDirection.rightToLeft;

    var background = widget.ltrBackground;
    if (widget.rtlBackground != null && isRtlDirection) {
      background = widget.rtlBackground;
    }
    final dismissedColor =
        isRtlDirection ? widget.rtlDismissedColor : widget.ltrDismissedColor;

    final overlay = isRtlDirection ? widget.rtlOverlay : widget.ltrOverlay;
    final overlayDismissed = isRtlDirection
        ? widget.rtlOverlayDismissed
        : widget.ltrOverlayDismissed;

    final padding = widget.padding;

    late final contentWrapperNeeded =
        padding != EdgeInsets.zero || widget.borderRadius != BorderRadius.zero;

    if (_resizeAnimation != null) {
      // we've been dragged aside, and are now resizing.
      assert(() {
        if (_resizeAnimation!.status != AnimationStatus.forward) {
          assert(_resizeAnimation!.isCompleted);
          throw FlutterError.fromParts(
            <DiagnosticsNode>[
              ErrorSummary(
                'A dismissed DismissibleTile widget is still part of the tree',
              ),
              ErrorHint(
                'Make sure to implement the onDismissed handler and to '
                'immediately remove the DismissibleTile widget from the '
                'application once that handler has fired.',
              ),
            ],
          );
        }
        return true;
      }());

      return ScaleTransition(
        scale: _resizeAnimation!,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _resizeAnimation!,
            child: _ContentWrapper(
              padding: padding,
              borderRadius: widget.borderRadius,
              child: SizedBox(
                height: _sizePriorToCollapse!.height - padding.vertical,
                width: _sizePriorToCollapse!.width - padding.horizontal,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    if (background != null)
                      Positioned.fill(
                        child: background,
                      ),
                    if (dismissedColor != null)
                      Positioned.fill(
                        child: ColoredBox(
                          color: dismissedColor,
                        ),
                      ),
                    if (overlayDismissed != null || overlay != null)
                      FadeTransition(
                        opacity: _resizeAnimation!,
                        child: overlayDismissed ?? overlay,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget content = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );

    // If the DismissibleTileDirection is none, we do not add drag gestures
    // because the content cannot be dragged.
    if (widget.direction == DismissibleTileDirection.none) {
      return contentWrapperNeeded
          ? _ContentWrapper(
              padding: padding,
              borderRadius: widget.borderRadius,
              child: content,
            )
          : content;
    }

    if (!_moveAnimation.isDismissed) {
      content = Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (background != null)
            Positioned.fill(
              child: background,
            ),
          Positioned.fill(
            child: DismissibleOverlay(
              direction: direction,
              dismissedColor: dismissedColor,
              moveController: _moveController,
              dragUnderway: _dragUnderway,
              overlay: overlay,
              overlayDismissed: overlayDismissed,
              overlayTransitionDuration: widget.overlayTransitionDuration,
              onDismissiblePainter: widget.onDismissiblePainter,
              indent: isRtlDirection
                  ? widget.rtlOverlayIndent
                  : widget.ltrOverlayIndent,
              overlayTransitionBuilder: isRtlDirection
                  ? widget.rtlOverlayTransitionBuilder
                  : widget.ltrOverlayTransitionBuilder,
            ),
          ),
          content,
        ],
      );
    }

    if (contentWrapperNeeded) {
      content = _ContentWrapper(
        padding: padding,
        borderRadius: widget.borderRadius,
        child: content,
      );
    }
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: widget.behavior,
      child: content,
    );
  }
}

/// Used if padding is non-zero or borderRadius is non-zero.
class _ContentWrapper extends StatelessWidget {
  const _ContentWrapper({
    required this.borderRadius,
    required this.padding,
    required this.child,
  });

  final BorderRadiusGeometry borderRadius;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var content = child;
    if (borderRadius != BorderRadius.zero) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: content,
      );
    }
    if (padding != EdgeInsets.zero) {
      content = Padding(
        padding: padding,
        child: content,
      );
    }
    return content;
  }
}
