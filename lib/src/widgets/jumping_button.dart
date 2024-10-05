import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JumpingButton extends StatefulWidget {
  const JumpingButton({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.1,
    this.haptic = false,
    this.bound = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptic;
  final bool bound;

  @override
  _JumpingButtonState createState() => _JumpingButtonState();
}

class _JumpingButtonState extends State<JumpingButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  late bool enabled;

  double radius = 0;

  @override
  void initState() {
    enabled = widget.onTap != null;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      upperBound: widget.scale,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    radius = _controller.value * 300;

    Widget child = widget.child;
    if (widget.bound) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      );
    }

    return Listener(
      onPointerDown: (_) {
        if (enabled) {
          _controller.forward();
          if (widget.haptic) HapticFeedback.lightImpact();
        }
      },
      onPointerUp: (_) {
        if (enabled) {
          _controller.reverse();
        }
      },
      child: GestureDetector(
        onTap: enabled ? widget.onTap : null,
        child: Transform.scale(
          scale: _scale,
          child: child,
        ),
      ),
    );
  }
}
