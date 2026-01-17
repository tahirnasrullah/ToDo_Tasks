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

  const TodayTask({
    super.key,
    required this.list,
    required this.emptyText,
    this.emptyButton = false,
    this.callbackActionEmptyButton,
    this.editing = false,
    required this.toMe,
    required this.fromMe,
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
                  ),
                )
                .toList(),
          );
  }
}

class Listing extends StatefulWidget {
  final dynamic value;
  final bool editing;
  final bool toMe;
  final bool fromMe;

  const Listing({
    super.key,
    required this.value,
    required this.editing,
    required this.toMe,
    required this.fromMe,
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

    return true;
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

  void _showCardDialog(context, dynamic value) {
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
        // return EditedOrDeletedCard(
        //   task: task,
        //   titleController: titleController,
        //   descriptionController: descriptionController,
        //   selectedAssignee: selectedAssignee,
        // );
      },
    );
  }
}
