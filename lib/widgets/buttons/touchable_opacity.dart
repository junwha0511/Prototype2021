import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function? onTap;
  final Duration duration = const Duration(milliseconds: 50);
  final double opacity = 0.5;

  TouchableOpacity({required this.child, this.onTap});

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.onTap == null
          ? () {}
          : () {
              widget.onTap!();
            },
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
      ),
    );
  }
}
