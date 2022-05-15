import 'package:flutter/material.dart';
import 'package:sirah/app/pages/timeline/widget/ticks.dart';
import 'package:sirah/app/pages/timeline/model/timeline.dart';
import 'package:sirah/app/pages/timeline/model/timeline_entry.dart';
import "dart:ui" as ui;

import 'package:sirah/app/pages/timeline/util/timeline_utlis.dart';

/// These two callbacks are used to detect if a bubble or an entry have been tapped.
/// If that's the case, [ArticlePage] will be pushed onto the [Navigator] stack.
typedef TouchBubbleCallback = Function(TapTarget? bubble);

class TimelineRenderWidget extends LeafRenderObjectWidget {
  final Timeline timeline;
  final TouchBubbleCallback touchBubble;
  const TimelineRenderWidget({
    Key? key,
    required this.timeline,
    required this.touchBubble,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimelineRenderObject()
      ..timeline = timeline
      ..touchBubble = touchBubble;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TimelineRenderObject renderObject) {
    renderObject
      ..timeline = timeline
      ..touchBubble = touchBubble;
  }
}

class TimelineRenderObject extends RenderBox {
  static const List<Color> lineColors = [
    Color.fromARGB(255, 125, 195, 184),
    Color.fromARGB(255, 190, 224, 146),
    Color.fromARGB(255, 238, 155, 75),
    Color.fromARGB(255, 202, 79, 63),
    Color.fromARGB(255, 128, 28, 15)
  ];

  final Ticks _ticks = Ticks();
  // It needs to be initialized but this is causing error.
  Timeline _timeline = Timeline(data: '');
  final List<TapTarget> _tapTargets = <TapTarget>[];
  TouchBubbleCallback? touchBubble;

  Timeline get timeline => _timeline;
  set timeline(Timeline value) {
    if (_timeline == value) {
      return;
    }
    _timeline = value;
    _timeline.onNeedPaint = () {
      markNeedsPaint();
    };
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => true;

  /// Check if the current tap on the screen has hit a bubble.
  @override
  bool hitTestSelf(Offset screenOffset) {
    for (TapTarget bubble in _tapTargets.reversed) {
      if (bubble.rect?.contains(screenOffset) ?? false) {
        if (touchBubble != null) {
          touchBubble!(bubble);
        }
        return true;
      }
    }
    touchBubble!(null);

    return true;
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    if (_timeline != null) {
      _timeline.setViewport(height: size.height, animate: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    if (_timeline == null) {
      return;
    }

    double renderStart = _timeline.renderStart;
    double renderEnd = _timeline.renderEnd;
    double scale = size.height / (renderEnd - renderStart);

    //canvas.drawRect(new Offset(0.0, 0.0) & new Size(100.0, 100.0), new Paint()..color = Colors.red);
    _ticks.paint(
        context, offset, -renderStart * scale, scale, size.height, timeline);

    if (timeline.renderAssets != null) {
      canvas.save();
      for (TimelineAsset asset in timeline.renderAssets) {
        if (asset.opacity > 0) {
          double rs = 0.2 + asset.scale * 0.8;

          double w = asset.width! * Timeline.AssetScreenScale;
          double h = asset.height! * Timeline.AssetScreenScale;

          /// Draw the correct asset.
          if (asset is TimelineImage) {
            canvas.drawImageRect(
                asset.image!,
                Rect.fromLTWH(0.0, 0.0, asset.width!, asset.height!),
                Rect.fromLTWH(
                    offset.dx + size.width - w, asset.y, w * rs, h * rs),
                Paint()
                  ..isAntiAlias = true
                  ..filterQuality = ui.FilterQuality.low
                  ..color = Colors.white.withOpacity(asset.opacity));
          }
        }
      }
      canvas.restore();
    }
    if (_timeline.entries != null) {
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(offset.dx + Timeline.GutterLeft, offset.dy,
          size.width - Timeline.GutterLeft, size.height));
      drawItems(
          context,
          offset,
          _timeline.entries,
          (Timeline.GutterLeft + Timeline.LineSpacing) -
              Timeline.DepthOffset * _timeline.renderOffsetDepth,
          scale,
          0);
      canvas.restore();
    }
  }

  void drawItems(PaintingContext context, Offset offset,
      List<TimelineEntry> entries, double x, double scale, int depth) {
    final Canvas canvas = context.canvas;
    const double BubblePadding = 20.0;

    for (TimelineEntry item in entries) {
      if (!item.isVisible ||
          item.y > size.height + _timeline.bubbleHeight(item) ||
          item.endY < -_timeline.bubbleHeight(item)) {
        continue;
      }

      double legOpacity = item.legOpacity * item.opacity;
      canvas.drawCircle(
          Offset(x + Timeline.LineWidth / 2.0, item.y),
          Timeline.EdgeRadius,
          Paint()
            ..color = lineColors[depth % lineColors.length]
                .withOpacity(item.opacity));
      if (legOpacity > 0.0) {
        Paint legPaint = Paint()
          ..color =
              lineColors[depth % lineColors.length].withOpacity(legOpacity);
        canvas.drawRect(
            Offset(x, item.y) & Size(Timeline.LineWidth, item.length),
            legPaint);
        canvas.drawCircle(
            Offset(x + Timeline.LineWidth / 2.0, item.y + item.length),
            Timeline.EdgeRadius,
            legPaint);
      }

      const double maxLabelWidth = 1200.0;
      const double bubbleHeight = 50.0;
      const double bubblePadding = 20.0;

      ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
          textAlign: TextAlign.start, fontFamily: "Arial", fontSize: 18.0))
        ..pushStyle(
            ui.TextStyle(color: const Color.fromRGBO(255, 255, 255, 1.0)));

      builder.addText(item.label);
      ui.Paragraph labelParagraph = builder.build();
      labelParagraph
          .layout(const ui.ParagraphConstraints(width: maxLabelWidth));
      //canvas.drawParagraph(labelParagraph, new Offset(offset.dx + Gutter - labelParagraph.minIntrinsicWidth-2, offset.dy + height - o - labelParagraph.height - 5));

      double textWidth =
          labelParagraph.maxIntrinsicWidth * item.opacity * item.labelOpacity;
      // ctx.globalAlpha = labelOpacity*itemOpacity;
      // ctx.save();
      // let bubbleX = labelX-DepthOffset*renderOffsetDepth;
      double bubbleX = _timeline.renderLabelX -
          Timeline.DepthOffset * _timeline.renderOffsetDepth;
      double bubbleY = item.labelY - bubbleHeight / 2.0;
      canvas.save();
      canvas.translate(bubbleX, bubbleY);
      Path bubble =
          makeBubblePath(textWidth + bubblePadding * 2.0, bubbleHeight);
      canvas.drawPath(
          bubble,
          Paint()
            ..color = lineColors[depth % lineColors.length]
                .withOpacity(item.opacity * item.labelOpacity * 0.95));
      canvas
          .clipRect(Rect.fromLTWH(bubblePadding, 0.0, textWidth, bubbleHeight));
      _tapTargets.add(TapTarget()
        ..entry = item
        ..rect = Rect.fromLTWH(
            bubbleX, bubbleY, textWidth + BubblePadding * 2.0, bubbleHeight));
      canvas.drawParagraph(
          labelParagraph,
          Offset(
              bubblePadding, bubbleHeight / 2.0 - labelParagraph.height / 2.0));
      canvas.restore();
      // if(item.asset != null)
      // {
      // 	canvas.drawImageRect(item.asset.image, Rect.fromLTWH(0.0, 0.0, item.asset.width, item.asset.height), Rect.fromLTWH(bubbleX + textWidth + BubblePadding*2.0, bubbleY, item.asset.width, item.asset.height), new Paint()..isAntiAlias=true..filterQuality=ui.FilterQuality.low);
      // }
      if (item.children != null) {
        drawItems(context, offset, item.children!, x + Timeline.DepthOffset,
            scale, depth + 1);
      }
    }
  }

  Path makeBubblePath(double width, double height) {
    const double arrowSize = 19.0;
    const double cornerRadius = 10.0;

    const double circularConstant = 0.55;
    const double icircularConstant = 1.0 - circularConstant;

    Path path = Path();

    path.moveTo(cornerRadius, 0.0);
    path.lineTo(width - cornerRadius, 0.0);
    path.cubicTo(width - cornerRadius + cornerRadius * circularConstant, 0.0,
        width, cornerRadius * icircularConstant, width, cornerRadius);
    path.lineTo(width, height - cornerRadius);
    path.cubicTo(
        width,
        height - cornerRadius + cornerRadius * circularConstant,
        width - cornerRadius * icircularConstant,
        height,
        width - cornerRadius,
        height);
    path.lineTo(cornerRadius, height);
    path.cubicTo(cornerRadius * icircularConstant, height, 0.0,
        height - cornerRadius * icircularConstant, 0.0, height - cornerRadius);

    path.lineTo(0.0, height / 2.0 + arrowSize / 2.0);
    path.lineTo(-arrowSize / 2.0, height / 2.0);
    path.lineTo(0.0, height / 2.0 - arrowSize / 2.0);

    path.lineTo(0.0, cornerRadius);

    path.cubicTo(0.0, cornerRadius * icircularConstant,
        cornerRadius * icircularConstant, 0.0, cornerRadius, 0.0);

    path.close();

    return path;
  }
}
