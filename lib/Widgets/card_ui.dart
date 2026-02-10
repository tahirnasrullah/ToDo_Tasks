import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/Widgets/color_widget_for_card.dart';
import 'package:to_do/Widgets/task_countdown.dart';
import 'package:to_do/Pages/MainPageElements/task_status.dart';

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
                    maxLines: 1,
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: colorCardText(
            widget.value.isCompleted,
            widget.value.isAccepted,
            widget.value.isDeclined,
          ),
          width: 4,
        ),
      ),
      color: colorCard(
        widget.value.isCompleted,
        widget.value.isAccepted,
        widget.value.isDeclined,
      ),
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 200, top: 50),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Task details",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: colorCardText(
                              widget.value.isCompleted,
                              widget.value.isAccepted,
                              widget.value.isDeclined,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorCardText(
                          widget.value.isCompleted,
                          widget.value.isAccepted,
                          widget.value.isDeclined,
                        ),
                      ),
                      height: 40,
                      child: Center(
                        child:
                            widget.value.uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Text(
                                "From: You",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                "From: ${widget.value.from}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.value.to ==
                                        FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .displayName
                                    ? Text(
                                        "To: You",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: colorCardText(
                                            widget.value.isCompleted,
                                            widget.value.isAccepted,
                                            widget.value.isDeclined,
                                          ),
                                          decorationThickness: 2,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: colorCardText(
                                            widget.value.isCompleted,
                                            widget.value.isAccepted,
                                            widget.value.isDeclined,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "To: ${widget.value.to}",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: colorCardText(
                                            widget.value.isCompleted,
                                            widget.value.isAccepted,
                                            widget.value.isDeclined,
                                          ),
                                          decorationThickness: 2,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: colorCardText(
                                            widget.value.isCompleted,
                                            widget.value.isAccepted,
                                            widget.value.isDeclined,
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 5),
                                Text(
                                  widget.value.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: colorCardText(
                                      widget.value.isCompleted,
                                      widget.value.isAccepted,
                                      widget.value.isDeclined,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Expanded(
                                  child: SizedBox(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        widget.value.desc,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorCardText(
                                            widget.value.isCompleted,
                                            widget.value.isAccepted,
                                            widget.value.isDeclined,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(formatTaskDate(widget.value.startDateTime)),
                        SizedBox(height: 5),
                        TaskCountdown(
                          endTime: widget.value.endDateTime,
                          isAccepted: widget.value.isAccepted,
                          isCompleted: widget.value.isCompleted,
                        ),
                      ],
                    ),
                  ),
                  widget.value.uid !=
                          FirebaseAuth.instance.currentUser!.uid
                      ? SizedBox.shrink()
                      : SizedBox(height: 10),

                  taskStatusButtons(widget, updateStatus),
                ],
              ),
            ),
          ],
        ),
      ),
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

Widget taskStatusButtons(widget, updateStatus) {
  return widget.editing &&
          widget.value.uid == FirebaseAuth.instance.currentUser!.uid &&
          widget.value.isCompleted == false
      ? Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colorCardText(
                    widget.value.isCompleted,
                    widget.value.isAccepted,
                    widget.value.isDeclined,
                  ),
                ),
                onPressed: widget.callback,
                child: Text('Edit it'),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colorCardText(
                      widget.value.isCompleted,
                      widget.value.isAccepted,
                      widget.value.isDeclined,
                    ),
                  ),
                  foregroundColor: colorCardText(
                    widget.value.isCompleted,
                    widget.value.isAccepted,
                    widget.value.isDeclined,
                  ),
                ),
                onPressed: () {},
                child: Text('Remind'),
              ),
            ),
          ],
        )
      : SizedBox(
          child:
              widget.value.to == FirebaseAuth.instance.currentUser!.displayName
              ? Column(
                  children: [
                    acceptedButton(widget, updateStatus),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        declinedButton(widget, updateStatus),
                        widget.value.isDeclined == true
                            ? SizedBox.shrink()
                            : SizedBox(width: 5),
                        completedButton(widget, updateStatus),
                      ],
                    ),
                  ],
                )
              : SizedBox.shrink(),
        );
}
