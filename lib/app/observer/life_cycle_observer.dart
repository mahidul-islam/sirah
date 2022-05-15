import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLifeCycleObserver extends StatefulWidget {
  const AppLifeCycleObserver({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  _AppLifeCycleObserverState createState() => _AppLifeCycleObserverState();
}

class _AppLifeCycleObserverState extends State<AppLifeCycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('state = $state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
