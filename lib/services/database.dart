import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'list.dart';




class UserDetailDatabase {

  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .set(userInfoMap);
  }

  Stream<List<String>> getDropdownValues(String field) {
    return FirebaseFirestore.instance
        .collection("User")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()[field] as String?)
          .whereType<String>()
          .toList();
    });
  }
}










class TaskService{

  Future<void> delnote(ToDoDailyTasksHistory task, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .doc(task.docId)
        .delete();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task Deleted")));
  }


  Stream<List<ToDoDailyTasksHistory>> taskStream() {
    return FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ToDoDailyTasksHistory.fromSnapshot(doc))
          .toList();
    });
  }

}