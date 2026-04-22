import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/viewport_offset.dart';
import 'dart:math';

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(physics: ClampingScrollPhysics()),
    super.horizontalDetails = const ScrollableDetails.horizontal(physics: ClampingScrollPhysics()),
    super.cacheExtent,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.dragStartBehavior = DragStartBehavior.start,
    super.diagonalDragBehavior = DiagonalDragBehavior.free,
    super.clipBehavior = Clip.hardEdge,
    required TwoDimensionalChildBuilderDelegate delegate,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      verticalOffset: verticalOffset,
      horizontalOffset: horizontalOffset,
      verticalAxisDirection: verticalDetails.direction,
      horizontalAxisDirection: horizontalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.horizontalOffset,
    required super.verticalAxisDirection,
    required super.horizontalAxisDirection,
    required super.mainAxis,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalGridViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalAxisDirection: horizontalAxisDirection,
      horizontalOffset: horizontalOffset,
      verticalAxisDirection: verticalAxisDirection,
      verticalOffset: verticalOffset,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      childManager: context as TwoDimensionalChildManager,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderTwoDimensionalViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.mainAxis,
    required super.childManager,
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final double viewportWidth = viewportDimension.width + cacheExtent;

    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = max((horizontalPixels / 200).floor(), 0);
    final int leadingRow = max((verticalPixels / 200).floor(), 0);
    final int trailingColumn = min(
      ((horizontalPixels + viewportWidth) / 200).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = min(
      ((verticalPixels + viewportHeight) / 200).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset = (leadingColumn * 200) - horizontalOffset.pixels;
    for (var i = leadingColumn; i < trailingColumn; i++) {
      double yLayoutOffset = (leadingRow * 200) - verticalOffset.pixels;
      for (var j = leadingRow; j <= trailingRow; j++) {
        final ChildVicinity vicinity = ChildVicinity(xIndex: i, yIndex: j);

        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);

        yLayoutOffset += 200;
      }
      xLayoutOffset += 200;
    }

    final double verticalExtent = 200 * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      (verticalExtent - viewportDimension.height).clamp(0.0, double.infinity),
    );
    final double horizontalExtent = 200 * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      (horizontalExtent - viewportDimension.width).clamp(0, double.infinity),
    );
  }
}
