import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/Widgets/task_countdown.dart';

class cardUi extends StatefulWidget {
  final dynamic value;
  final GestureTapCallback callbackAction;

  const cardUi({super.key, required this.value, required this.callbackAction});

  @override
  State<cardUi> createState() => _cardUiState();
}

class _cardUiState extends State<cardUi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: InkWell(
        onTap: widget.callbackAction,
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
          widget.value.from == FirebaseAuth.instance.currentUser!.displayName
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
          Text(formatTaskDate(widget.value.startDateTime)),
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
                    )
                  : Container(),
            ],
    );
  }
}
