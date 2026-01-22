import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Widgets/card_ui.dart';
import 'package:to_do/services/list.dart';
import 'editedOrDeleted_card.dart';

class TodayTask extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final String emptyText;
  final bool emptyButton;
  final VoidCallback? callbackActionEmptyButton;
  final bool editing;
  final bool toMe;
  final bool fromMe;
  final TaskStatus taskStatus;

  const TodayTask({
    super.key,
    required this.list,
    required this.emptyText,
    this.emptyButton = false,
    this.callbackActionEmptyButton,
    this.editing = false,
    required this.toMe,
    required this.fromMe,
    required this.taskStatus,
  });

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(
            child: widget.emptyButton
                ? InkWell(
                    onTap: widget.callbackActionEmptyButton,
                    child: Text(
                      widget.emptyText,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : Text(widget.emptyText),
          )
        : ListView(
            scrollDirection: Axis.horizontal,
            children: widget.list
                .map(
                  (value) => Listing(
                    value: value,
                    editing: widget.editing,
                    toMe: widget.toMe,
                    fromMe: widget.fromMe,
                    taskStatus: widget.taskStatus,
                  ),
                )
                .toList(),
          );
  }
}


class Listing extends StatefulWidget {
  final ToDoDailyTasksHistory value;
  final bool editing;
  final bool toMe;
  final bool fromMe;
  final TaskStatus taskStatus;

  const Listing({
    super.key,
    required this.value,
    required this.editing,
    required this.toMe,
    required this.fromMe,
    required this.taskStatus,
  });

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedAssignee;

  bool shouldShowTask(ToDoDailyTasksHistory task) {
    final currentUser = FirebaseAuth.instance.currentUser!.displayName;

    final isToMe = task.to == currentUser;
    final isFromMe = task.from == currentUser;

    if (widget.toMe && !isToMe) return false;
    if (!widget.toMe && isToMe) return false;

    if (widget.fromMe && !isFromMe) return false;
    if (!widget.fromMe && isFromMe) return false;

    switch (widget.taskStatus) {
      case TaskStatus.accepted:
        return task.isAccepted && !task.isDeclined;

      case TaskStatus.declined:
        return task.isDeclined;

      case TaskStatus.pending:
        return !task.isAccepted && !task.isDeclined;

      case TaskStatus.all:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!shouldShowTask(widget.value)) {
      return const SizedBox.shrink();
    }

    return cardUi(
      value: widget.value,
      callbackAction: () {
        _showCardDialog(context, widget.value);
      },
    );
  }

  void _showCardDialog(context, ToDoDailyTasksHistory value) {
    showDialog(
      context: context,
      builder: (value) {
        return cardAlertDialog(
          value: widget.value,
          editing: widget.editing,
          callback: () {
            _showEditingCardDialog(
              context,
              widget.value,
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

enum TaskStatus { all, accepted, declined, pending }
