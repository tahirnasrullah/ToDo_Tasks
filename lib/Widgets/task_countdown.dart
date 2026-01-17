import 'dart:async';
import 'package:flutter/material.dart';

class TaskCountdown extends StatefulWidget {
  final DateTime endTime;

  const TaskCountdown({super.key, required this.endTime});

  @override
  State<TaskCountdown> createState() => _TaskCountdownState();
}

class _TaskCountdownState extends State<TaskCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOverdue ? Icons.warning : Icons.timer,
          size: 16,
          color: isOverdue ? Colors.red : Colors.green,
        ),
        const SizedBox(width: 4),
        Text(
          isOverdue
              ? "Overdue by ${_formatDuration(_remaining)}"
              : _formatDuration(_remaining),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isOverdue ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
