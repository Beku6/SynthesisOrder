import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'base_layout.dart';

class AnimatedClockIcon extends StatefulWidget {
  const AnimatedClockIcon({
    super.key,
    required this.isActive,
    this.size = 18,
    this.color,
  });

  final bool isActive;
  final double size;
  final Color? color;

  @override
  State<AnimatedClockIcon> createState() => _AnimatedClockIconState();
}

class _AnimatedClockIconState extends State<AnimatedClockIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedClockIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? synorSecondaryText(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final rotation = widget.isActive
            ? (_controller.value * 0.15) - 0.075
            : 0.0;
        final opacity = widget.isActive
            ? 0.92 + (_controller.value * 0.08)
            : 1.0;
        return Opacity(
          opacity: opacity,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _ClockPainter(color: color, rotation: rotation),
          ),
        );
      },
    );
  }
}

class _ClockPainter extends CustomPainter {
  const _ClockPainter({required this.color, required this.rotation});

  final Color color;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawLine(Offset.zero, Offset(0, -radius * 0.55), paint);
    canvas.drawLine(Offset.zero, Offset(radius * 0.4, radius * 0.18), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.rotation != rotation;
  }
}

class AnimatedHourglassIcon extends StatefulWidget {
  const AnimatedHourglassIcon({
    super.key,
    required this.timeLeft,
    this.isActive = true,
    this.size = 18,
    this.color,
  });

  final String timeLeft;
  final bool isActive;
  final double size;
  final Color? color;

  @override
  State<AnimatedHourglassIcon> createState() => _AnimatedHourglassIconState();
}

class _AnimatedHourglassIconState extends State<AnimatedHourglassIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationForTime(widget.timeLeft)),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedHourglassIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeLeft != oldWidget.timeLeft ||
        widget.isActive != oldWidget.isActive) {
      _controller.duration = Duration(
        milliseconds: _durationForTime(widget.timeLeft),
      );
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.isActive && _hasRemainingTime(widget.timeLeft)) {
      _controller.repeat();
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  bool _hasRemainingTime(String value) {
    if (value == '00:00:00' || value.startsWith('-')) {
      return false;
    }
    return value.split(':').map(int.tryParse).whereType<int>().isNotEmpty;
  }

  int _durationForTime(String value) {
    final parts = value.split(':').map(int.tryParse).whereType<int>().toList();
    if (parts.isEmpty) {
      return 2500;
    }
    final totalMinutes = parts.length == 3
        ? (parts[0] * 60) + parts[1]
        : parts[0];
    if (totalMinutes <= 5) {
      return 1200;
    }
    if (totalMinutes <= 15) {
      return 1800;
    }
    return 2500;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? synorSecondaryText(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _HourglassPainter(
            color: color,
            progress: _controller.value,
            isActive: widget.isActive && _hasRemainingTime(widget.timeLeft),
          ),
        );
      },
    );
  }
}

class _HourglassPainter extends CustomPainter {
  const _HourglassPainter({
    required this.color,
    required this.progress,
    required this.isActive,
  });

  final Color color;
  final double progress;
  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    const viewBox = 24.0;
    final scale = size.width / viewBox;

    canvas.save();
    canvas.scale(scale, scale);

    final outline = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final eased = Curves.easeInOut.transform(progress);
    final topClipY = lerpDouble(4, 6, eased)!;
    final bottomClipY = lerpDouble(18, 16, eased)!;
    final fillOpacity = isActive
        ? 0.42 + (0.06 * math.sin(progress * math.pi * 2))
        : 0.4;
    final fill = Paint()
      ..color = color.withValues(alpha: fillOpacity.clamp(0.3, 0.5))
      ..style = PaintingStyle.fill;

    canvas.drawLine(const Offset(5, 2), const Offset(19, 2), outline);
    canvas.drawLine(const Offset(5, 22), const Offset(19, 22), outline);
    canvas.drawPath(_upperFramePath(), outline);
    canvas.drawPath(_lowerFramePath(), outline);

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, topClipY, 24, 12));
    canvas.drawPath(_topSandPath(), fill);
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, bottomClipY, 24, 12));
    canvas.drawPath(_bottomSandPath(), fill);
    canvas.restore();

    if (isActive) {
      final stream = _streamMetrics(progress);
      final streamPaint = Paint()
        ..color = color.withValues(alpha: stream.opacity)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(12, stream.startY),
        Offset(12, stream.endY),
        streamPaint,
      );
    }

    canvas.restore();
  }

  Path _upperFramePath() {
    return Path()
      ..moveTo(7, 2)
      ..lineTo(7, 6.172)
      ..quadraticBezierTo(7, 6.94, 7.586, 7.586)
      ..lineTo(12, 12)
      ..lineTo(16.414, 7.586)
      ..quadraticBezierTo(17, 6.94, 17, 6.172)
      ..lineTo(17, 2);
  }

  Path _lowerFramePath() {
    return Path()
      ..moveTo(17, 22)
      ..lineTo(17, 17.828)
      ..quadraticBezierTo(17, 17.06, 16.414, 16.414)
      ..lineTo(12, 12)
      ..lineTo(7.586, 16.414)
      ..quadraticBezierTo(7, 17.06, 7, 17.828)
      ..lineTo(7, 22);
  }

  Path _topSandPath() {
    return Path()
      ..moveTo(8, 4)
      ..lineTo(16, 4)
      ..lineTo(16, 6.172)
      ..quadraticBezierTo(16, 6.586, 15.707, 6.879)
      ..lineTo(12, 10.586)
      ..lineTo(8.293, 6.879)
      ..quadraticBezierTo(8, 6.586, 8, 6.172)
      ..close();
  }

  Path _bottomSandPath() {
    return Path()
      ..moveTo(8, 20)
      ..lineTo(16, 20)
      ..lineTo(16, 17.828)
      ..quadraticBezierTo(16, 17.414, 15.707, 17.121)
      ..lineTo(12, 13.414)
      ..lineTo(8.293, 17.121)
      ..quadraticBezierTo(8, 17.414, 8, 17.828)
      ..close();
  }

  _StreamMetrics _streamMetrics(double t) {
    if (t <= 0.5) {
      final local = Curves.easeInOut.transform(t / 0.5);
      return _StreamMetrics(
        startY: 10,
        endY: lerpDouble(10, 16, local)!,
        opacity: lerpDouble(0.0, 0.5, local)!,
      );
    }
    final local = Curves.easeInOut.transform((t - 0.5) / 0.5);
    return _StreamMetrics(
      startY: lerpDouble(10, 16, local)!,
      endY: 16,
      opacity: lerpDouble(0.5, 0.0, local)!,
    );
  }

  @override
  bool shouldRepaint(covariant _HourglassPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive;
  }
}

class _StreamMetrics {
  const _StreamMetrics({
    required this.startY,
    required this.endY,
    required this.opacity,
  });

  final double startY;
  final double endY;
  final double opacity;
}
