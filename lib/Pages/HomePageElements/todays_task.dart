import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

class TodayTask extends StatefulWidget {

  final List<ToDoDailyTasksHistory> list;
  final String emptyText;
  final bool button;
  final VoidCallback? callbackAction;


  const TodayTask({
    super.key,
    required this.list,
    required this.emptyText,
    this.button = false,
    this.callbackAction,
  });


  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  @override
  Widget build(BuildContext context) {
    return widget.list.isEmpty
        ? Center(
            child: widget.button
                ? InkWell(
                    onTap: widget.callbackAction,
                    child: Text(widget.emptyText,style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue),),
                  )
                : Text(widget.emptyText),
          )
        : SizedBox(
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
                            padding: const EdgeInsets.all(8.0),
                            child: Expanded(
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
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],),
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
