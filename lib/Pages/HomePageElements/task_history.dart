import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Pages/NewHomePage/color_widget_for_card.dart';
import 'package:to_do/services/list.dart';

import '../../services/database.dart';

class TaskHistory extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final bool scrollableCondition;
  final bool delAble;
  final bool onlyMe;

  const TaskHistory({
    super.key,
    required this.list,
    this.scrollableCondition = true,
    this.delAble = false,
    required this.onlyMe,
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
                  (task) => widget.onlyMe == false
                      ? HistoryUi(task: task, delAble: widget.delAble)
                      : task.to ==
                            FirebaseAuth.instance.currentUser!.displayName
                      ? HistoryUi(task: task, delAble: widget.delAble)
                      : SizedBox.shrink(),
                )
                .toList(),
          );
  }
}

class HistoryUi extends StatefulWidget {
  final ToDoDailyTasksHistory task;
  final bool delAble;
  final TaskService taskService = TaskService();

  HistoryUi({super.key, required this.task, required this.delAble});

  @override
  State<HistoryUi> createState() => _HistoryUiState();
}

class _HistoryUiState extends State<HistoryUi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2,
              color: ColorCardText(
                widget.task.isCompleted,
                widget.task.isAccepted,
                widget.task.isDeclined,
              ),
            ),
          ),
        ),
        child: ListTile(
          leading: widget.task.uid == FirebaseAuth.instance.currentUser!.uid
              ? Text(
                  "You",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                )
              : Text(
                  widget.task.from,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
          title: Row(
            children: [
              widget.task.to == FirebaseAuth.instance.currentUser!.displayName
                  ? Text("To: You")
                  : Text("To: ${widget.task.to}"),
              SizedBox(width: 10),
              Text("For: ${widget.task.title}"),
            ],
          ),
          trailing:
              widget.delAble &&
                  widget.task.uid == FirebaseAuth.instance.currentUser!.uid
              ? IconButton(
                  onPressed: () async {
                    await widget.taskService.delnote(widget.task, context);
                  },
                  icon: Icon(Icons.delete),
                )
              : null,
          subtitle: Text(
            widget.task.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          tileColor: ColorCard(
            widget.task.isCompleted,
            widget.task.isAccepted,
            widget.task.isDeclined,
          ),
        ),
      ),
    );
  }
}
