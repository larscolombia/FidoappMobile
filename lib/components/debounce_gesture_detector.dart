import 'package:flutter/material.dart';
import 'dart:async';

class DebounceGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Future<void> Function()? onTapAsync; // Optional async handler; when provided, blocks until it finishes
  final Duration debounceDuration;
  final bool enabled;
  final HitTestBehavior? behavior;

  const DebounceGestureDetector({
    Key? key,
    required this.child,
    this.onTap,
    this.onTapAsync,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.enabled = true,
    this.behavior,
  }) : super(key: key);

  @override
  _DebounceGestureDetectorState createState() => _DebounceGestureDetectorState();
}

class _DebounceGestureDetectorState extends State<DebounceGestureDetector> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (!widget.enabled || _isProcessing) return;

    // Si hay onTapAsync, esperar a que termine antes de desbloquear
    if (widget.onTapAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onTapAsync!();
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
      return;
    }

    // Fallback a comportamiento con debounce si solo hay onTap sincrónico
    if (widget.onTap != null) {
      // Cancelar timer anterior si existe
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
    return GestureDetector(
      behavior: widget.behavior,
      onTap: _handleTap,
      child: Opacity(
        opacity: _isProcessing ? 0.6 : 1.0,
        child: widget.child,
      ),
    );
  }
}
