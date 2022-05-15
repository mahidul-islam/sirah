import 'package:flutter/material.dart';

class Loader {
  static Widget circular({double size = 32}) {
    return Center(child: CircularProgressIndicator());
  }
}
