import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

import '../../services/database.dart';
import '../../services/notification_services.dart';
import '../MainPageElements/add_card.dart';
import '../MainPageElements/task_history.dart';
import '../MainPageElements/todays_task.dart';

class OtherUsersPage extends StatefulWidget {
  const OtherUsersPage({super.key});

  @override
  State<OtherUsersPage> createState() => _OtherUsersPageState();
}

class _OtherUsersPageState extends State<OtherUsersPage> {
  final TaskService taskService = TaskService();
  late bool _assigningToYou = false;
  late bool _accepted = false;
  late String showAssignTo = 'to only you';
  late String showAccepted = 'all tasks';
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getToken().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        showAssignTo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
                  flex: 2,
                  child: _assigningToYou == true
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
                          fromMe: false,
                          taskStatus: TaskStatus.all,
                        ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "From You to Others",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        showAccepted,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _accepted = !_accepted;
                          showAccepted == 'all tasks'
                              ? showAccepted = 'only accepted tasks'
                              : showAccepted = 'all tasks';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  flex: 2,
                  child: _accepted == true
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
                    Text(
                      "Tasks History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
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
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  flex: 1,
                  child: TaskHistory(
                    scrollableCondition: false,
                    list: listTodayTasks,
                    onlyMe: false,
                    editing: false,
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
        return Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                "Tasks History",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
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
                    onlyMe: false,
                    editing: true,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
