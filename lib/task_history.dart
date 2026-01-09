import 'package:flutter/material.dart';

class task_history extends StatefulWidget {
  final List<Map<String, String>> listTodayTasks;
  final bool Scrollables;

  const task_history({
    super.key,
    required this.listTodayTasks,
    this.Scrollables = true,
  });

  @override
  State<task_history> createState() => _task_historyState();
}

class _task_historyState extends State<task_history> {
  @override
  Widget build(BuildContext context) {
    return widget.listTodayTasks.isEmpty
        ? Center(child: Text("Not Tasks Yet"))
        : ListView(
            physics: widget.Scrollables
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: widget.listTodayTasks
                .map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(tileColor: Colors.grey),
                  ),
                )
                .toList(),
          );
  }
}
