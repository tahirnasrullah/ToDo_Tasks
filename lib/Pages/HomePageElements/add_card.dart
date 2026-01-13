import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

import '../../services/database.dart';


class AddCard extends StatefulWidget {

  final VoidCallback? onTaskAdded;




  AddCard({super.key, this.onTaskAdded});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {

  final TaskService taskService = TaskService();

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedAssignee;
  final UserDetailDatabase userDb = UserDetailDatabase();



  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {


    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Add New Task"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<List<String>>(
                  stream: userDb.getDropdownValues('username'),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No users available");
                    }

                    final users = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      initialValue: selectedAssignee,
                      decoration: InputDecoration(
                        labelText: "To:",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      items: users.map((user) {
                        return DropdownMenuItem<String>(
                          value: user,
                          child: Text(user),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAssignee = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? "Required" : null,
                    );
                  },
                ),




                const SizedBox(height: 10),
                Text_Field_Form(
                  controller: titleController,
                  labelText: "Title:",
                  errorText: "Required",
                ),
                const SizedBox(height: 10),
                Text_Field_Form(
                  controller: descriptionController,
                  labelText: "Description:",
                  errorText: "Required",
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(

              onPressed: _isSaving ? null : _saveTask,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTask() async {

    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      // Prepare data
      ToDoDailyTasksHistory task = ToDoDailyTasksHistory(
        docId: '',
        to: selectedAssignee! ,
        from: FirebaseAuth.instance.currentUser!.displayName! ,
        title: titleController.text,
        desc: descriptionController.text,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );

      try {
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection("ToDoDailyTasks")
            .add(task.toMap());

        widget.onTaskAdded?.call();

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to save task: $e")));
        }
      } finally {

        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {

    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
