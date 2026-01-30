import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

import '../../services/database.dart';

class TaskHistory extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final bool scrollableCondition;
  final bool delAble;


  const TaskHistory({
    super.key,
    required this.list,
    this.scrollableCondition = true,
    this.delAble=false,
  });

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  @override
  Widget build(BuildContext context) {
    final TaskService taskService = TaskService();


    return widget.list.isEmpty
        ? Center(child: Text("Not Yet"))
        : ListView(
            physics: widget.scrollableCondition
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: widget.list
                .map(
                  (task) =>
                  task.isCompleted == true && task.isAccepted==true
                  ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black),
                      ),
                      leading:
                          task.uid ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? Text("You", style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15))
                          : Text(task.from, style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15)),
                      title: Row(
                        children: [
                          task.to==FirebaseAuth.instance.currentUser!.displayName
                              ? Text("To: You")
                              : Text("To: ${task.to}"),
                          SizedBox(width: 10),
                          Text("For: ${task.title}"),
                        ],
                      ),
                      trailing:
                          widget.delAble &&
                              task.uid == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              onPressed: () async {
                                await taskService.delnote(task, context);
                              },
                              icon: Icon(Icons.delete),
                            )
                          : null,
                      subtitle: Text(
                        task.desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tileColor: Colors.grey.shade300,
                    ),
                  ):SizedBox.shrink(),
                )
                .toList(),
          );
  }
}
