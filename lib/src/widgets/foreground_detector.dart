import 'package:flutter/material.dart';

class ForegroundDetector extends StatefulWidget {
  const ForegroundDetector({
    Key? key,
     this.child,
    required this.onForegroundChanged,
  }) : super(key: key);

  final Function(bool, bool) onForegroundChanged;
  final Widget? child;

  @override
  ForegroundDetectorState createState() => ForegroundDetectorState();
}

class ForegroundDetectorState extends State<ForegroundDetector> {
  bool get isForeground => _isForeground ?? false;
  bool? _isForeground;
  bool _hasGoneToBackground = false;

  @override
  Widget build(BuildContext context) {
    final isForeground = TickerMode.of(context);
    if(!isForeground){
      _hasGoneToBackground = true;
    }
    if (_isForeground != isForeground) {
      _isForeground = isForeground;
      widget.onForegroundChanged(isForeground, _hasGoneToBackground);
    }
    return widget.child ?? SizedBox.shrink();
  }
}