import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart' as d;
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
      _timeline = timeline;
      scaleProper();
      setState(() {});
    });
  }

  Future<void> scaleProper() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _timeline?.setViewport(start: 564, end: 590, animate: true);
    setState(() {});
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.5), //change your color here
        ),
        title: Text(
          'সিরাহ',
          style: TextStyle(color: Colors.black.withOpacity(0.87)),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.replay,
              color: Colors.black.withOpacity(0.5),
            ),
            tooltip: 'Reset',
            onPressed: () async {
              ConnectivityResult _connect =
                  await Connectivity().checkConnectivity();
              if (_connect == ConnectivityResult.none) {
                _timeline?.setViewport(start: 564, end: 590, animate: true);
              } else {
                _getTimeline();
              }
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: Colors.black.withOpacity(0.5),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.topicDetails, arguments: <String, dynamic>{
                'article': TimelineEntry()
                  ..label = 'আমাদের সম্পর্কে'
                  ..articleFilename = 'about_us.txt',
              });
            },
          ),
        ],
        elevation: 0,
      ),
      drawer: _timeline?.allEntries == null ? null : _getDrawer(),
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
            Positioned(
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 24,
                child: _getNextPrev()),
          ],
        ),
      ),
    );
  }

  Widget? _getDrawer() {
    if (_timeline?.allEntries == null ||
        (_timeline?.allEntries.isEmpty ?? true)) {
      return null;
    }
    return Drawer(
      child: ListView.builder(
        itemCount: _timeline?.allEntries.length,
        itemBuilder: (BuildContext context, int index) {
          // if (index == 0) return DrawerHeader(child: Text('ArRijal Sirah App'));
          return GestureDetector(
            onTap: () {
              if (index < 1) {
                _timeline?.selectedId = _timeline?.allEntries[index].id;
              }
              _timeline?.selectedId = _timeline?.allEntries[index - 1].id;
              Navigator.of(context).pop();
              _focusOnDesiredEntry(next: true);
            },
            child: SizedBox(
              height: 56.0,
              child: Center(
                  child: Text(
                '${_timeline?.allEntries[index].label}',
                maxLines: 2,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _getNextPrev() {
    return SizedBox(
      // height: 100.0,
      width: 56.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MaterialButton(
            height: 56,
            minWidth: 56,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
            child: Icon(
              Icons.arrow_upward,
              color: Colors.black.withOpacity(0.5),
            ),
            onPressed: () {
              _focusOnDesiredEntry(next: false);
            },
          ),
          const SizedBox(height: 8),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minWidth: 56,
            height: 56,
            color: Colors.white,
            child: Icon(
              Icons.arrow_downward,
              color: Colors.black.withOpacity(0.5),
            ),
            onPressed: () {
              _focusOnDesiredEntry(next: true);
            },
          ),
        ],
      ),
    );
  }

  void _focusOnDesiredEntry({bool next = true}) {
    // TimelineEntry? _currentEntry;
    double _year = 570.5;
    double _distance = 0.01;
    if (_timeline?.selectedId == null) {
      for (int i = 0; i < (_timeline?.allEntries.length ?? 0); i++) {
        if (_timeline?.allEntries[i].start == 530) {
          _timeline?.selectedId = _timeline?.allEntries[i].id;
        }
      }
    }
    if (_timeline?.selectedId != null) {
      for (int i = 0; i < (_timeline?.allEntries.length ?? 0); i++) {
        if (_timeline?.allEntries[i].id == _timeline?.selectedId) {
          // if (_timeline?.allEntries[i].start == 570.5) {
          //   _timeline?.selectedId = _timeline?.allEntries[i + 1].id;
          //   continue;
          // }
          if (next) {
            if (i != (_timeline?.allEntries.length ?? 0) - 1) {
              _year = _timeline?.allEntries[i + 1].start ?? 570.5;
              _timeline?.selectedId = _timeline?.allEntries[i + 1].id;
              _distance = (_timeline?.allEntries[i + 1].start ?? 0) -
                  (_timeline?.allEntries[i].start ?? 0);
              _distance = _distance - (_distance / 5);
            } else {
              _year = _timeline?.allEntries[0].start ?? 570.5;
              _timeline?.selectedId = _timeline?.allEntries[0].id;
            }
          } else {
            if (i != 0) {
              _year = _timeline?.allEntries[i - 1].start ?? 570.5;
              _timeline?.selectedId = _timeline?.allEntries[i - 1].id;
              double _temp = (_timeline?.allEntries[i].start ?? 0) -
                  (_timeline?.allEntries[i - 1].start ?? 0);
              _temp = _temp - (_temp / 5);
              _distance = _temp < _distance ? _temp : _distance;
            } else {
              _year = _timeline
                      ?.allEntries[(_timeline?.allEntries.length ?? 0) - 1]
                      .start ??
                  570.5;
              _timeline?.selectedId = _timeline
                  ?.allEntries[(_timeline?.allEntries.length ?? 0) - 1].id;
            }
          }
          break;
        }
      }
    }
    setState(() {
      _timeline?.setViewport(
          start: _year - _distance, end: _year + _distance, animate: true);
    });
  }
}
