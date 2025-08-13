import 'package:flutter/material.dart';
import 'dart:async';

class SafeInkWell extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Future<void> Function()? onTapAsync; // Optional async handler
  final Duration debounceDuration;
  final bool enabled;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? hoverColor;

  const SafeInkWell({
    Key? key,
    required this.child,
    this.onTap,
  this.onTapAsync,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
  }) : super(key: key);

  @override
  _SafeInkWellState createState() => _SafeInkWellState();
}

class _SafeInkWellState extends State<SafeInkWell> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (!widget.enabled || _isProcessing) return;

    // Prefer async handler if provided
    if (widget.onTapAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onTapAsync!();
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
      return;
    }

    if (widget.onTap != null) {
      _debounceTimer?.cancel();
      setState(() => _isProcessing = true);
      widget.onTap!();
      _debounceTimer = Timer(widget.debounceDuration, () {
        if (mounted) setState(() => _isProcessing = false);
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      borderRadius: widget.borderRadius,
      splashColor: widget.splashColor,
      highlightColor: widget.highlightColor,
      hoverColor: widget.hoverColor,
      child: Opacity(
        opacity: _isProcessing ? 0.7 : 1.0,
        child: widget.child,
      ),
    );
  }
}
