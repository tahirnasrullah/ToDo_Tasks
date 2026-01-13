import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:to_do/services/list.dart';

class TaskHistory extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final bool scrollableCondition;
  final Function(ToDoDailyTasksHistory) delnote;
  final bool delAble;

  const TaskHistory({
    super.key,
    required this.list,
    this.scrollableCondition = true,
    required this.delnote,
    this.delAble = false,
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
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading:
                          task.from ==
                              FirebaseAuth.instance.currentUser!.displayName
                          ?  Text("Me")
                          :Text(task.from),
                      title: Row(
                        children: [
                          Text("To: ${task.to}"),
                          SizedBox(width: 10),
                          Text("For: ${task.title}"),
                        ],
                      ),
                      trailing: widget.delAble && task.uid == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              onPressed: () {
                                widget.delnote(task);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete),
                            )
                          : null,
                      subtitle: Text(
                        task.desc,
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
