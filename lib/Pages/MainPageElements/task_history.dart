import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Widgets/color_widget_for_card.dart';
import 'package:to_do/services/list.dart';
import '../../Widgets/card_ui.dart';
import '../../services/database.dart';
import 'edited_or_deleted_card.dart';

class TaskHistory extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final bool scrollableCondition;
  final bool delAble;
  final bool onlyMe;
  final bool editing;


  const TaskHistory({
    super.key,
    required this.list,
    this.scrollableCondition = true,
    this.delAble = false,
    required this.onlyMe, required this.editing,
  });

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(child: Text("Not Found"))
        : ListView(
            physics: widget.scrollableCondition
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: widget.list
                .map(
                  (task) => widget.onlyMe == false
                      ? HistoryUi(task: task, delAble: widget.delAble, editing: widget.editing)
                      : task.to ==
                            FirebaseAuth.instance.currentUser!.displayName
                      ? HistoryUi(task: task, delAble: widget.delAble, editing: widget.editing)
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
  final bool editing;


  HistoryUi({super.key, required this.task, required this.delAble, required this.editing});

  @override
  State<HistoryUi> createState() => _HistoryUiState();
}

class _HistoryUiState extends State<HistoryUi> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedAssignee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: colorCardText(
                widget.task.isCompleted,
                widget.task.isAccepted,
                widget.task.isDeclined,
              ),
            ),
          ),
        ),
        child: ListTile(
          onTap: () {_showCardDialog(context, widget.task);},
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.task.uid == FirebaseAuth.instance.currentUser!.uid
                  ? Text(
                      "You",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,color: Theme.of(context).textTheme.titleLarge?.color),
                    )
                  : Text(
                      widget.task.from,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,color: Theme.of(context).textTheme.titleLarge?.color),
                    ),
              widget.task.to == FirebaseAuth.instance.currentUser!.displayName
                  ? Text("To: You", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,color: Theme.of(context).textTheme.titleLarge?.color))
                  : Text("To: ${widget.task.to}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,color: Theme.of(context).textTheme.titleLarge?.color)),
            ],
          ),
          title: Text("Title: ${widget.task.title}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).textTheme.titleLarge?.color),),
          trailing:
              widget.delAble &&
                  widget.task.uid == FirebaseAuth.instance.currentUser!.uid
                  && widget.task.isCompleted == true
              ? IconButton(
                  onPressed: () async {
                    await widget.taskService.delnote(widget.task, context);
                  },
                  icon: Icon(Icons.delete),
                )
              : null,
          subtitle: Text(
            widget.task.desc,
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color,),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }


  void _showCardDialog(context, ToDoDailyTasksHistory value) {
    showDialog(
      context: context,
      builder: (value) {
        return CardAlertDialog(
          value: widget.task,
          editing: widget.editing,
          callback: () {
            _showEditingCardDialog(
              context,
              widget.task,
              titleController,
              descriptionController,
              selectedAssignee,
            );
          },
        );
      },
    );
  }

  void _showEditingCardDialog(
      BuildContext context,
      ToDoDailyTasksHistory task,
      TextEditingController titleController,
      TextEditingController descriptionController,
      String? selectedAssignee,
      ) {
    showDialog(
      context: context,
      builder: (value) {
        titleController.text = task.title;
        descriptionController.text = task.desc;
        selectedAssignee = task.to;
        return EditTaskCard(task: task);
      },
    );
  }
}

