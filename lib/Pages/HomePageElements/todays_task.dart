import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

import 'editedOrDeleted_card.dart';

class TodayTask extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final String emptyText;
  final bool emptyButton;
  final VoidCallback? callbackActionEmptyButton;
  final bool cardButton;

  const TodayTask({
    super.key,
    required this.list,
    required this.emptyText,
    this.emptyButton = false,
    this.callbackActionEmptyButton,
    this.cardButton = false,
  });

  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedAssignee;

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
                  (value) => widget.cardButton && value.uid == FirebaseAuth.instance.currentUser!.uid
                      ? InkWell(
                          child: Listing(value: value),
                          onLongPressUp: () {
                            _showCardDialog(context, value);
                          },
                        )
                      : Listing(value: value),
                )
                .toList(),
          );
  }

  void _showCardDialog(BuildContext context, ToDoDailyTasksHistory task) {
    showDialog(
      context: context,
      builder: (value) {
        titleController.text = task.title;
        descriptionController.text = task.desc;
        selectedAssignee = task.to;
        return EditedOrDeletedCard(
          task: task,
          titleController: titleController,
          descriptionController: descriptionController,
          selectedAssignee: selectedAssignee,
        );
      },
    );
  }
}

class Listing extends StatefulWidget {
  final dynamic value;

  const Listing({super.key, required this.value});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: Card(
        elevation: 10,
        child: SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To: ${widget.value.to}",
                  style: TextStyle(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  "For: ${widget.value.title}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  widget.value.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
