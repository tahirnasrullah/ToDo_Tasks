import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

class TaskHistory extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final bool scrollableCondition;

  const TaskHistory({
    super.key,
    required this.list,
    this.scrollableCondition = true,
  });

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(child: Text("Not Yet"))
        : ListView(
            physics: widget.scrollableCondition
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: widget.list
                .map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading: Text(value.from),
                      title: Text(value.title),
                      subtitle: Text(
                        value.desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tileColor: Colors.grey,
                    ),
                  ),
                )
                .toList(),
          );
  }
}
