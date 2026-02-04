import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/Pages/NewHomePage/color_widget_for_card.dart';
import 'package:to_do/Widgets/task_countdown.dart';

import '../services/database.dart';
import '../services/list.dart';

class CardUi extends StatefulWidget {
  final dynamic value;
  final GestureTapCallback callbackAction;

  const CardUi({super.key, required this.value, required this.callbackAction});

  @override
  State<CardUi> createState() => _CardUiState();
}

class _CardUiState extends State<CardUi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
      child: InkWell(
        onTap: widget.callbackAction,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: colorCardText(
                widget.value.isCompleted,
                widget.value.isAccepted,
                widget.value.isDeclined,
              ),
            ),

            borderRadius: BorderRadius.circular(20),
          ),
          color: colorCard(
            widget.value.isCompleted,
            widget.value.isAccepted,
            widget.value.isDeclined,
          ),

          child: SizedBox(
            width: 220,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.value.to ==
                          FirebaseAuth.instance.currentUser!.displayName
                      ? Text(
                          "To: You",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: colorCardText(
                              widget.value.isCompleted,
                              widget.value.isAccepted,
                              widget.value.isDeclined,
                            ),
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          "To: ${widget.value.to}",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: colorCardText(
                              widget.value.isCompleted,
                              widget.value.isAccepted,
                              widget.value.isDeclined,
                            ),
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  SizedBox(height: 5),
                  Text(
                    "Title: ${widget.value.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorCardText(
                        widget.value.isCompleted,
                        widget.value.isAccepted,
                        widget.value.isDeclined,
                      ),
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.value.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorCardText(
                        widget.value.isCompleted,
                        widget.value.isAccepted,
                        widget.value.isDeclined,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TaskCountdown(
                    endTime: widget.value.endDateTime,
                    isAccepted: widget.value.isAccepted,
                    isCompleted: widget.value.isCompleted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class cardAlertDialog extends StatefulWidget {
  final dynamic value;
  final bool editing;
  final VoidCallback? callback;

  const cardAlertDialog({
    super.key,
    required this.value,
    required this.editing,
    required this.callback,
  });

  @override
  State<cardAlertDialog> createState() => _cardAlertDialogState();
}

class _cardAlertDialogState extends State<cardAlertDialog> {
  TaskService taskService = TaskService();

  String formatTaskDate(DateTime date) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Task details"),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            height: 40,

            child: Center(
              child: widget.value.uid == FirebaseAuth.instance.currentUser!.uid
                  ? Text("From: You")
                  : Text("From: ${widget.value.from}"),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.value.to == FirebaseAuth.instance.currentUser!.displayName
                  ? Text("To: You")
                  : Text("To: ${widget.value.to}"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.value.isCompleted == true
                      ? Text(
                          "Task completed",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        )
                      : widget.value.isAccepted == true
                      ? Text(
                          "Task accepted",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        )
                      : widget.value.isDeclined == true
                      ? Text(
                          "Task declined",
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        )
                      : widget.value.isCompleted == true
                      ? Text(
                          "Task completed",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        )
                      : Text(
                          "Task pending",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            widget.value.title,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text(widget.value.desc),
          SizedBox(height: 5),
          Text(formatTaskDate(widget.value.startDateTime)),
          SizedBox(height: 5),
          TaskCountdown(
            endTime: widget.value.endDateTime,
            isAccepted: widget.value.isAccepted,
            isCompleted: widget.value.isCompleted,
          ),
        ],
      ),
      actions:
          widget.editing &&
              widget.value.uid == FirebaseAuth.instance.currentUser!.uid &&
              widget.value.isCompleted == false
          ? [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.callback,
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
              widget.value.to == FirebaseAuth.instance.currentUser!.displayName
                  ? Column(
                      children: [
                        widget.value.isAccepted == false &&
                                widget.value.isCompleted == false
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        updateStatus(
                                          widget.value.isCompleted,
                                          true,
                                          widget.value.isDeclined,
                                        );
                                      },
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
                              )
                            : SizedBox.shrink(),
                        widget.value.isAccepted == true ||
                                widget.value.isCompleted == true
                            ? SizedBox.shrink()
                            : SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.value.isAccepted == false &&
                                    widget.value.isCompleted == false &&
                                    widget.value.isDeclined == false
                                ? Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        updateStatus(
                                          widget.value.isCompleted,
                                          widget.value.isAccepted,
                                          true,
                                        );
                                      },
                                      child: Text("Decline"),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(width: 5),
                            widget.value.isCompleted == false
                                ? Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        updateStatus(
                                          true,
                                          widget.value.isAccepted,
                                          widget.value.isDeclined,
                                        );
                                      },
                                      child: Text('Completed'),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
    );
  }

  Future<void> updateStatus(
    bool isCompleted,
    bool isAccepted,
    bool isDeclined,
  ) async {
    final updatedTask = ToDoDailyTasksHistory(
      docId: widget.value.docId,
      to: widget.value.to,
      from: widget.value.from,
      startDateTime: widget.value.startDateTime,
      endDateTime: widget.value.endDateTime,
      title: widget.value.title,
      desc: widget.value.desc,
      uid: widget.value.uid,
      isCompleted: isCompleted,
      isAccepted: isAccepted,
      isDeclined: isDeclined,
    );

    await taskService.updateTask(updatedTask, context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Status updated successfully"),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }
}
