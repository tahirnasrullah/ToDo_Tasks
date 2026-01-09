import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/add_card.dart';
import 'package:to_do/services/List.dart';
import 'package:to_do/task_history.dart';
import 'package:to_do/todays_task.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List<ToDoDailyTasks_history> listTodayTasks = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        iconSize: 20,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 0),
        child: FloatingActionButton(
          onPressed: () {
            _showCardDialog(context);
          },
          child: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(70),
          ),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Todo DailyTasks',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnVvDx9Kezwg0D77WzdAUzjOEHf1WEqQ3-fA&s',
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Tasks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: todays_task(
                        list: listTodayTasks,
                        EmptyText: "Not Yet",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Assigned to Others",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: todays_task(
                        list: listTodayTasks,
                        EmptyText: "Assign now",
                        button: true,
                        CallbackAction: () {
                          _showCardDialog(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Completed Tasks",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showCardDialog_Tasks(context);
                        },
                        child: Text(
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

                  SizedBox(height: 10),

                  Expanded(
                    child: task_history(
                      Scrollables: false,
                      list: listTodayTasks,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showCardDialog_Tasks(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Completed Tasks",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: task_history(Scrollables: true, list: listTodayTasks),
          ),
        );
      },
    );
  }

  void _showCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Add_card(
          onTaskAdded:getTasks
        );
      },
    );
  }

  Future<void> getTasks() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .get();

    List<ToDoDailyTasks_history> tasks = [];
    for (var docSnapshot in querySnapshot.docs) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      tasks.add(ToDoDailyTasks_history.fromMap(data));
    }
    setState(() {
      listTodayTasks = tasks;
      _isLoading = false;
    });
  }
}
