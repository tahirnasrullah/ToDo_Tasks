import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return FirebaseFirestore.instance.collection("User").snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => doc.data()[field] as String?)
          .whereType<String>()
          .toList();
    });
  }

  Future<bool> doesEmailExist(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(10)
        .get();
    log('result: $result');
    return result.docs.isNotEmpty;
  }
}

class TaskService {
  Future<void> addTask(ToDoDailyTasksHistory task, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .add(task.toMap());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task Saved")));
  }

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

  Future<void> updateTask(
    ToDoDailyTasksHistory task,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection("ToDoDailyTasks")
        .doc(task.docId)
        .update(task.toMap());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Save Successfully")));
  }

  Stream<int> assignedTaskCount() {

    return FirebaseFirestore.instance
        .collection('ToDoDailyTasks')
        .where('to', isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

}
