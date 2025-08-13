import 'package:flutter/material.dart';
import 'dart:async';

class SafeElevatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync; // Optional async handler
  final Duration debounceDuration;
  final ButtonStyle? style;

  const SafeElevatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onPressedAsync,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.style,
  }) : super(key: key);

  @override
  _SafeElevatedButtonState createState() => _SafeElevatedButtonState();
}

class _SafeElevatedButtonState extends State<SafeElevatedButton> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  Future<void> _handlePress() async {
    if (_isProcessing) return;

    // Prefer async handler
    if (widget.onPressedAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
      return;
    }

    if (widget.onPressed != null) {
      _debounceTimer?.cancel();
      setState(() => _isProcessing = true);
      widget.onPressed!();
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
    return ElevatedButton(
      onPressed: _handlePress,
      style: widget.style?.copyWith(
        overlayColor: WidgetStateProperty.all(
          _isProcessing ? Colors.grey.withOpacity(0.1) : null,
        ),
      ) ?? ButtonStyle(
        overlayColor: WidgetStateProperty.all(
          _isProcessing ? Colors.grey.withOpacity(0.1) : null,
        ),
      ),
      child: Opacity(
        opacity: _isProcessing ? 0.7 : 1.0,
        child: widget.child,
      ),
    );
  }
}
