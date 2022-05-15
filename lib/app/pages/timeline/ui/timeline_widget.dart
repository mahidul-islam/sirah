import 'package:dartz/dartz.dart' as d;
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sirah/app/pages/timeline/model/timeline.dart';
import 'package:sirah/app/pages/timeline/model/timeline_entry.dart';
import 'package:sirah/app/pages/timeline/repo/timeline_repo.dart';
import 'package:sirah/app/pages/timeline/widget/timeline_render_widget.dart';
import 'package:sirah/app/pages/timeline/util/timeline_utlis.dart';
import 'package:sirah/app/routes/routes.dart';
import 'package:sirah/shared/util/loader.dart';

typedef ShowMenuCallback = Function();

class TimelineWidget extends StatefulWidget {
  // final ShowMenuCallback showMenu;
  const TimelineWidget({
    Key? key,
    // required this.showMenu,
  }) : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  Timeline? _timeline;

  Offset? _lastFocalPoint;
  double _scaleStartYearStart = -100.0;
  double _scaleStartYearEnd = 100.0;
  bool zooming = false;

  TapTarget? _touchedBubble;

  @override
  void initState() {
    _getTimeline();
    super.initState();
  }

  Future<void> _zoom({required bool zoomIn}) async {
    Offset _f = Offset(MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2);

    while (zooming) {
      _scaleStart(ScaleStartDetails(
        focalPoint: _f,
      ));
      _scaleUpdate(ScaleUpdateDetails(
        scale: zoomIn ? 1.1 : 0.9,
        horizontalScale: 1.0,
        verticalScale: 1.0,
        focalPoint: _f,
      ));
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _getTimeline() async {
    setState(() {
      _timeline = null;
    });
    TimelineApi _api = HttpTimelineApi();
    d.Either<String, Timeline> _result =
        await _api.getTopicList(forceRefresh: true);
    _result.fold((String error) {
      if (kDebugMode) {
        print('show error');
      }
    }, (Timeline timeline) {
      setState(() {
        _timeline = timeline;
        scaleProper();
      });
    });
  }

  Future<void> scaleProper() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _timeline?.setViewport(start: 564, end: 590, animate: true);
  }

  void _scaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _scaleStartYearStart = _timeline!.start;
    _scaleStartYearEnd = _timeline!.end;
    _timeline!.isInteracting = true;
    _timeline!.setViewport(velocity: 0.0, animate: true);
  }

  void _tapUp(TapUpDetails details) {
    if (_touchedBubble != null) {
      Navigator.of(context)
          .pushNamed(Routes.topicDetails, arguments: <String, dynamic>{
        'article': _touchedBubble!.entry!,
      });
    }
  }

  onTouchBubble(TapTarget? bubble) {
    _touchedBubble = bubble;
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    double changeScale = details.scale;
    double scale =
        (_scaleStartYearEnd - _scaleStartYearStart) / context.size!.height;

    double focus = _scaleStartYearStart + details.focalPoint.dy * scale;
    double focalDiff =
        (_scaleStartYearStart + _lastFocalPoint!.dy * scale) - focus;

    _timeline!.setViewport(
        start: focus + (_scaleStartYearStart - focus) / changeScale + focalDiff,
        end: focus + (_scaleStartYearEnd - focus) / changeScale + focalDiff,
        height: context.size!.height,
        animate: true);
  }

  void _scaleEnd(ScaleEndDetails details) {
    double scale = (_timeline!.end - _timeline!.start) / context.size!.height;
    _timeline!.isInteracting = false;
    _timeline!.setViewport(
        velocity: details.velocity.pixelsPerSecond.dy * scale, animate: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_timeline == null) {
      return Loader.circular();
    }

    return Scaffold(
      floatingActionButton: FabCircularMenu(
        ringColor: const Color.fromARGB(255, 125, 195, 184).withOpacity(0.8),
        fabCloseIcon: const Icon(Icons.clear_rounded, color: Colors.white),
        fabOpenIcon: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
        fabCloseColor: const Color.fromARGB(255, 125, 195, 184),
        fabOpenColor: const Color.fromARGB(255, 238, 155, 75),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline_rounded,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.topicDetails,
                      arguments: <String, dynamic>{
                        'article': TimelineEntry()
                          ..label = 'আমাদের সম্পর্কে'
                          ..articleFilename = 'about_us.txt',
                      });
                },
              ),
              const Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      zooming = true;
                      _zoom(zoomIn: true);
                    },
                    onTapUp: (_) {
                      zooming = false;
                    },
                    child: const Icon(
                      Icons.add_circle_outline,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) {
                      zooming = true;
                      _zoom(zoomIn: false);
                    },
                    onTapUp: (_) {
                      zooming = false;
                    },
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Text(
                'Zoom InOut',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.cached_rounded,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _getTimeline();
                  });
                },
              ),
              const Text(
                'Reload',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _timeline?.setViewport(start: 564, end: 590, animate: true);
                  });
                },
              ),
              const Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: _scaleStart,
        onScaleUpdate: _scaleUpdate,
        onScaleEnd: _scaleEnd,
        onTapUp: _tapUp,
        child: Stack(
          children: <Widget>[
            TimelineRenderWidget(
              timeline: _timeline!,
              touchBubble: onTouchBubble,
            ),
            Container(
              color: const Color.fromRGBO(238, 240, 242, 0.81),
              height: 56.0,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
