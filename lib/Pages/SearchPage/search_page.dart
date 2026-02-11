import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';

import '../../services/database.dart';
import '../MainPageElements/task_history.dart';
import '../NewHomePage/elements.dart';
import 'filter_users.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  final TaskService taskService = TaskService();
  final UserDetailDatabase userDb = UserDetailDatabase();
  String? selectedUserFrom;
  String? selectedUserTo;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedUserFrom = null;
    selectedUserTo = null;
    searchController.addListener(() {
      setState(() {}); // rebuild when user types
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchField(
              searchController: searchController,
            ),
            SizedBox(height: 10),
            FilterUsers(
              statusText: "From: ",
              selectedUser: selectedUserFrom,
              onUserSelected: (user) {
                setState(() {
                  selectedUserFrom = user;
                });
              },
            ),
            SizedBox(height: 10),
            FilterUsers(
              statusText: "To: ",
              selectedUser: selectedUserTo,
              onUserSelected: (user) {
                setState(() {
                  selectedUserTo = user;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<ToDoDailyTasksHistory>>(
                stream: taskService.taskStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }

                  final listTodayTasks = snapshot.data ?? [];
                  final searchText = searchController.text.toLowerCase();

                  final filteredTasks = listTodayTasks.where((task) {
                    final matchTitle = task.title.toLowerCase().contains(
                      searchText,
                    );

                    final matchUser =
                        selectedUserFrom == null ||
                        task.from == selectedUserFrom;

                    final matchTo =
                        selectedUserTo == null || task.to == selectedUserTo;

                    return matchTitle && matchUser && matchTo;

                  }).toList();

                  return TaskHistory(
                    list: filteredTasks,
                    onlyMe: false,
                    editing: true,
                    scrollableCondition: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

