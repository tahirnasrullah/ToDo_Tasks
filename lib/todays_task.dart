import 'package:flutter/material.dart';
import 'package:to_do/services/List.dart';

class todays_task extends StatefulWidget {
  final List<ToDoDailyTasks_history> list;
  final String EmptyText;
  final bool button;
  final CallbackAction;
  final String text_key_to ;
  final String text_key_title ;
  final String text_key_desc ;



  const todays_task({
    super.key,
    required this.list,
    required this.EmptyText,
    this.button = false,
    this.CallbackAction,
    this.text_key_to= "to",
    this.text_key_title= "title",
    this.text_key_desc= "desc",
  });

  @override
  State<todays_task> createState() => _todays_taskState();
}

class _todays_taskState extends State<todays_task> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(
            child: widget.button
                ? TextButton(
                    onPressed: widget.CallbackAction,
                    child: Text(widget.EmptyText),
                  )
                : Text(widget.EmptyText),
          )
        : Container(
          height: 120,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.list
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Card(
                        elevation: 10,
                        child: SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "To: ${value.to}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "For: ${value.title}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  value.desc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        );
  }
}
