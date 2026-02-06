
import 'package:flutter/material.dart';
import 'package:to_do/Widgets/color_widget_for_card.dart';

Widget task_status(widget){
  return widget.value.isCompleted == true
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
  );
}


Widget acceptedButton(widget, updateStatus) {
  return Column(
    children: [
      widget.value.isAccepted == false && widget.value.isCompleted == false
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
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      )
          : SizedBox.shrink(),
      widget.value.isAccepted == true || widget.value.isCompleted == true
          ? SizedBox.shrink()
          : SizedBox(height: 5),
    ],
  );
}

Widget declinedButton(widget, updateStatus) {
  return widget.value.isCompleted == false && widget.value.isDeclined == false
      ? Expanded(
    child: ElevatedButton(
      onPressed: () {
        updateStatus(
          widget.value.isCompleted,
          widget.value.isAccepted,
          true,
        );
      },
      child: Text("Decline", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
    ),
  )
      : SizedBox.shrink();
}

Widget completedButton(widget, updateStatus) {
  return widget.value.isCompleted == false
      ? Expanded(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorCardText(widget.value.isCompleted, widget.value.isAccepted, widget.value.isDeclined),
      ),
      onPressed: () {
        updateStatus(
          true,
          widget.value.isAccepted,
          widget.value.isDeclined,
        );
      },
      child: Text('Completed', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    ),
  )
      : SizedBox.shrink();
}
