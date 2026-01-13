import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/add_card.dart';
import 'package:to_do/task_history.dart';
import 'package:to_do/todays_task.dart';
import 'package:to_do/services/list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// 🔥 Firestore Stream
  Stream<List<ToDoDailyTasksHistory>> taskStream() {
    return FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ToDoDailyTasksHistory.fromMap(
          doc.data(),
        );
      }).toList();
    });
  }

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
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnVvDx9Kezwg0D77WzdAUzjOEHf1WEqQ3-fA&s',
              ),
            ),
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70),
        ),
        child: const Icon(Icons.add),
        onPressed: () {
          _showCardDialog(context);
        },
      ),

      /// 🔥 REAL-TIME BODY
      body: StreamBuilder<List<ToDoDailyTasksHistory>>(
        stream: taskStream(),
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

                const Text(
                  "Today's Tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: TodaysTask(
                    list: listTodayTasks,
                    emptyText: "Not Yet",
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Assigned to Others",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: TodaysTask(
                    list: listTodayTasks,
                    emptyText: "Assign now",
                    button: true,
                    callbackAction: () {
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
                        showCardDialogTasks(context, listTodayTasks);
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
                    delnote: delnote,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔥 SHOW ADD TASK
  void _showCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddCard(),
    );
  }

  /// 🔥 SHOW COMPLETED TASKS
  void showCardDialogTasks(
      BuildContext context,
      List<ToDoDailyTasksHistory> list,
      ) {
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskHistory(
              scrollableCondition: true,
              list: list,
              delnote: delnote,
              delAble: true,
            ),
          ),
        );
      },
    );
  }

  /// 🔥 DELETE TASK
  Future<void> delnote(ToDoDailyTasksHistory task) async {
    await FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .doc(task.uid)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task Deleted")),
    );
  }
}

