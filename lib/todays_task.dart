import 'package:flutter/material.dart';

class todays_task extends StatefulWidget {
  final List<Map<String, String>> listTodayTasks;
  final String Empty;
  final bool button;
  final CallbackAction;

  const todays_task({
    super.key,
    required this.listTodayTasks,
    required this.Empty,
    this.button = false,
    this.CallbackAction,
  });

  @override
  State<todays_task> createState() => _todays_taskState();
}

class _todays_taskState extends State<todays_task> {
  @override
  Widget build(BuildContext context) {
    return widget.listTodayTasks.isEmpty
        ? Center(
            child: widget.button
                ? TextButton(
                    onPressed: widget.CallbackAction,
                    child: Text(widget.Empty),
                  )
                : Text(widget.Empty),
          )
        : Container(
            color: Colors.grey,
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.listTodayTasks
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 10,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        width: 100,
                        child: Container(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
