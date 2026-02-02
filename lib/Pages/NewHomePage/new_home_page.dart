import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do/Pages/HomePageElements/todays_task.dart';
import 'package:to_do/Pages/NewHomePage/Elements.dart';

import '../../services/database.dart';
import '../../services/list.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Greegings(),
            SizedBox(height: 30),
            InkWell(
              child: IgnorePointer(
                child: Hero(tag: 'search',
                child: SearchField(searchController: searchController)),
              ),
              onTap: () {
                  print("Tapped Search");
                  widget.onTabChange(1);
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TaskStatusButton(Colors.red, "To-Do", () {
                  setState(() {
                    taskStatus = TaskStatus.all;
                  });
                }, icon: FontAwesomeIcons.fileLines),
                TaskStatusButton(Colors.amber, "In-Progress", () {
                  setState(() {
                    taskStatus = TaskStatus.accepted;
                  });
                }, icon: FontAwesomeIcons.hourglass),
                TaskStatusButton(Colors.green, "Completed", () {
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
    );
  }
}
