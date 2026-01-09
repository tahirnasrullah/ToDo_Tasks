import 'package:flutter/material.dart';
import 'package:to_do/services/List.dart';

class task_history extends StatefulWidget {
  final List<ToDoDailyTasks_history> list;
  final bool Scrollables;

  const task_history({super.key, required this.list, this.Scrollables = true});

  @override
  State<task_history> createState() => _task_historyState();
}

class _task_historyState extends State<task_history> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(child: Text("Not Yet"))
        : ListView(
            physics: widget.Scrollables
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: widget.list
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
