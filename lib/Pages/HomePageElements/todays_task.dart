import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/services/list.dart';
import 'package:to_do/Widgets/task_countdown.dart';
import 'editedOrDeleted_card.dart';

class TodayTask extends StatefulWidget {
  final List<ToDoDailyTasksHistory> list;
  final String emptyText;
  final bool emptyButton;
  final VoidCallback? callbackActionEmptyButton;
  final bool editing;

  const TodayTask({
    super.key,
    required this.list,
    required this.emptyText,
    this.emptyButton = false,
    this.callbackActionEmptyButton,
    this.editing = false,
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
                .map((value) => Listing(value: value, editing: widget.editing))
                .toList(),
          );
  }
}

class Listing extends StatefulWidget {
  final dynamic value;
  final bool editing;

  String formatTaskDate(DateTime date) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  const Listing({super.key, required this.value, required this.editing});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedAssignee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          _showCardDialog(context, widget.value);
        },
        child: Card(
          elevation: 10,
          child: SizedBox(
            width: 220,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.value.to ==
                          FirebaseAuth.instance.currentUser!.displayName
                      ? Text(
                          "To: Me",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        )
                      : Text(
                          "To: ${widget.value.to}",
                          style: TextStyle(fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  SizedBox(height: 5),
                  Text(
                    "Title: ${widget.value.title}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      widget.value.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  TaskCountdown(endTime: widget.value.endDateTime),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCardDialog(context, dynamic value) {
    showDialog(
      context: context,
      builder: (value) {
        return AlertDialog(
          title: Center(child: const Text("Task details")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.value.from ==
                      FirebaseAuth.instance.currentUser!.displayName
                  ? Text("From: Me")
                  : Text("From: ${widget.value.from}"),
              SizedBox(height: 5),
              widget.value.to == FirebaseAuth.instance.currentUser!.displayName
                  ? Text("To: Me")
                  : Text("To: ${widget.value.to}"),
              SizedBox(height: 5),
              Text("Title: ${widget.value.title}"),
              SizedBox(height: 5),
              Text(widget.value.desc),
              SizedBox(height: 5),
              Text(widget.formatTaskDate(widget.value.startDateTime)),
              SizedBox(height: 5),
              TaskCountdown(endTime: widget.value.endDateTime),
            ],
          ),
          actions:
              widget.editing &&
                  widget.value.uid == FirebaseAuth.instance.currentUser!.uid
              ? [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showEditingCardDialog(
                              context,
                              widget.value,
                              titleController,
                              descriptionController,
                              selectedAssignee,
                            );
                          },
                          child: Text('Edit it'),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('Remind'),
                        ),
                      ),
                    ],
                  ),
                ]
              : [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("Decline"),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('Complete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
