import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do/Pages/NewHomePage/elements.dart';

import '../../services/database.dart';
import '../../services/list.dart';
import '../MainPageElements/task_history.dart';
import '../MainPageElements/todays_task.dart';

class NewHomePage extends StatefulWidget {
  final Function(int) onTabChange;

  const NewHomePage({super.key, required this.onTabChange});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  late TaskStatus taskStatus = TaskStatus.all;

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final TaskService taskService = TaskService();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Greegings(),
              SizedBox(height: 30),
              InkWell(
                child: IgnorePointer(
                  child: Hero(
                    tag: 'search',
                    child: SearchField(searchController: searchController,),
                  ),
                ),
                onTap: () {
                  print("Tapped Search");
                  widget.onTabChange(1);
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  taskStatusButton(Colors.red, "All Tasks", () {
                    setState(() {
                      taskStatus = TaskStatus.all;
                    });
                  }, icon: FontAwesomeIcons.fileLines),
                  taskStatusButton(Colors.deepPurpleAccent, "New", () {
                    setState(() {
                      taskStatus = TaskStatus.pending;
                    });
                  }, icon: FontAwesomeIcons.fileLines),
                  taskStatusButton(Colors.amber, "In-Progress", () {
                    setState(() {
                      taskStatus = TaskStatus.accepted;
                    });
                  }, icon: FontAwesomeIcons.hourglass),
                  taskStatusButton(Colors.green, "Completed", () {
                    setState(() {
                      taskStatus = TaskStatus.completed;
                    });
                  }, icon: FontAwesomeIcons.check),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Today's Tasks",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  InkWell(
                    child: Text(
                      "See All",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    onTap: () {
                      showCardDialogTasks(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              StreamBuilder<List<ToDoDailyTasksHistory>>(
                stream: taskService.taskStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  final listTodayTasks = snapshot.data ?? [];
                  return Expanded(
                    child: TodayTask(
                      list: listTodayTasks,
                      emptyText: "Not Yet",
                      toMe: true,
                      fromMe: false,
                      taskStatus: taskStatus,
                      emptyButton: false,
                      editing: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCardDialogTasks(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final TaskService taskService = TaskService();
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "All Tasks",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: StreamBuilder<List<ToDoDailyTasksHistory>>(
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
                  editing: true,
                  scrollableCondition: true,
                  list: tasks,
                  onlyMe: true,
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
