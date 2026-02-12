import 'dart:async';
import 'package:flutter/material.dart';

class TaskCountdown extends StatefulWidget {
  final DateTime endTime;
  final bool isAccepted;
  final bool isCompleted;

  const TaskCountdown({
    super.key,
    required this.endTime,
    required this.isAccepted,
    required this.isCompleted,
  });

  @override
  State<TaskCountdown> createState() => _TaskCountdownState();
}

class _TaskCountdownState extends State<TaskCountdown> {
  late Timer _timer;
  late Duration _remaining;
  late Duration _totalDuration;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _totalDuration = widget.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    setState(() {
      _remaining = widget.endTime.difference(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final days = d.inDays.abs();
    final hours = d.inHours.abs() % 24;
    final minutes = d.inMinutes.abs() % 60;
    final seconds = d.inSeconds.abs() % 60;

    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = _remaining.isNegative;
    final isNearlyOverdue = _remaining.inMinutes <= 30;

    double progress = 0;

    if (!_remaining.isNegative && _totalDuration.inSeconds > 0) {
      progress = 1 - (_remaining.inSeconds / _totalDuration.inSeconds);
      progress = progress.clamp(0.0, 1.0);
    }

    return widget.isCompleted
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOverdue ? Icons.warning : Icons.timer,
                    size: 10,
                    color: isOverdue
                        ? Colors.red
                        : isNearlyOverdue
                        ? Colors.orange
                        : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOverdue
                        ? "Overdue by ${_formatDuration(_remaining)}"
                        : _formatDuration(_remaining),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: isOverdue
                          ? Colors.red
                          : isNearlyOverdue
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              widget.isAccepted
                  ? LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: isOverdue
                          ? Colors.transparent
                          : Colors.grey.withAlpha(128),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOverdue
                            ? Colors.red
                            : isNearlyOverdue
                            ? Colors.orange
                            : Colors.green,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          );
  }
}
