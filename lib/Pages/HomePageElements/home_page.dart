import 'package:flutter/material.dart';
import 'package:to_do/Pages/HomePageElements/add_card.dart';
import 'package:to_do/Pages/HomePageElements/task_history.dart';
import 'package:to_do/Pages/HomePageElements/todays_task.dart';
import 'package:to_do/services/list.dart';

import '../../services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskService taskService = TaskService();
  late bool _assigningToYou = false;
  late bool _accepted = false;
  late String showAssignTo = 'to only you';
  late String showAccepted = 'only accepted task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Todo DailyTasks',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10, bottom: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnVvDx9Kezwg0D77WzdAUzjOEHf1WEqQ3-fA&s",
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        child: const Icon(Icons.add),
        onPressed: () {
          _showCardDialog(context);
        },
      ),

      body: StreamBuilder<List<ToDoDailyTasksHistory>>(
        stream: taskService.taskStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          final listTodayTasks = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        showAssignTo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _assigningToYou = !_assigningToYou;
                          showAssignTo == 'to only you'
                              ? showAssignTo = 'to others'
                              : showAssignTo = 'to only you';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: _assigningToYou
                      ? TodayTask(
                          list: listTodayTasks,
                          emptyText: "Not Yet",
                          emptyButton: false,
                          editing: false,
                          toMe: true,
                          fromMe: false,
                          taskStatus: TaskStatus.all,
                        )
                      : TodayTask(
                          list: listTodayTasks,
                          emptyText: "No tasks today",
                          emptyButton: false,
                          editing: false,
                          toMe: false,
                          fromMe: true,
                          taskStatus: TaskStatus.all,
                        ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Assigned to Others",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        showAccepted,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _accepted = !_accepted;
                          showAccepted == 'only accepted tasks'
                              ? showAccepted = 'all tasks'
                              : showAccepted = 'only accepted tasks';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: _accepted
                      ? TodayTask(
                          list: listTodayTasks,
                          emptyText: "Assign now",
                          emptyButton: true,
                          editing: true,
                          toMe: false,
                          fromMe: true,
                          taskStatus: TaskStatus.all,
                          callbackActionEmptyButton: () {
                            _showCardDialog(context);
                          },
                        )
                      : TodayTask(
                          list: listTodayTasks,
                          emptyText: "Assign now",
                          emptyButton: true,
                          editing: true,
                          toMe: false,
                          fromMe: true,
                          taskStatus: TaskStatus.accepted,
                          callbackActionEmptyButton: () {
                            _showCardDialog(context);
                          },
                        ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Completed Tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCardDialogTasks(context);
                      },
                      child: const Text(
                        'Show all...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: TaskHistory(
                    scrollableCondition: false,
                    list: listTodayTasks,
                    delAble: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCardDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AddCard());
  }

  void showCardDialogTasks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Completed Tasks",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: StreamBuilder<List<ToDoDailyTasksHistory>>(
            stream: taskService.taskStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }

              final tasks = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TaskHistory(
                  scrollableCondition: true,
                  list: tasks,
                  delAble: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
