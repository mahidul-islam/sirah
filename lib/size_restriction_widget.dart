import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SizeRestrictorWidget extends StatelessWidget {
  const SizeRestrictorWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    return SizedBox.expand(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width < 600
              ? MediaQuery.of(context).size.width
              : 600,
          child: child,
        ),
      ),
    );
  }
}
