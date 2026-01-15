import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

import '../../services/database.dart';

class EditedOrDeletedCard extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String? selectedAssignee;
  final ToDoDailyTasksHistory task;

  EditedOrDeletedCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedAssignee,
    required this.task,
  });

  @override
  State<EditedOrDeletedCard> createState() => _EditedOrDeletedCardState();
}

class _EditedOrDeletedCardState extends State<EditedOrDeletedCard> {
  final TaskService taskService = TaskService();

  final formKey = GlobalKey<FormState>();

  final UserDetailDatabase userDb = UserDetailDatabase();

  bool _isSaving = false;
  String? _selectedAssignee;

  @override
  void initState() {
    super.initState();
    _selectedAssignee = widget.selectedAssignee;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text("Update Task"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<List<String>>(
                  stream: userDb.getDropdownValues('username'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No users available");
                    }

                    final users = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedAssignee,
                      decoration: InputDecoration(
                        labelText: "To:",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: users.map((user) {
                        return DropdownMenuItem<String>(
                          value: user,
                          child: Text(user),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAssignee = value;
                        });
                      },
                      validator: (value) => value == null ? "Required" : null,
                    );
                  },
                ),

                const SizedBox(height: 10),
                Text_Field_Form(
                  controller: widget.titleController,
                  labelText: "Title:",
                  errorText: "Required",
                ),
                const SizedBox(height: 10),
                Text_Field_Form(
                  controller: widget.descriptionController,
                  labelText: "Description:",
                  errorText: "Required",
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _showCardDialog(
                      context,
                      widget.task,
                      "Are you sure you want to delete this task?",
                      "Delete",
                      () async {
                        await taskService.delnote(widget.task, context);
                        Navigator.pop(context);
                      },
                      "Deleting...",
                    );
                  },
                  child: const Text("Delete"),
                ),

                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    _showCardDialog(
                      context,
                      widget.task,
                      "Are you sure you want to update this task?",
                      "Update",
                      _updateTask,
                      "Updating...",
                    );
                  },
                  child: const Text("Update"),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDialog(
    BuildContext context,
    ToDoDailyTasksHistory task,
    String warningText,
    String buttonText,
    VoidCallback buttonAction,
    String loadText,
  ) {
    showDialog(
      context: context,
      builder: (value) {
        return SizedBox(
          height: 100,
          child: AlertDialog(
            title: const Text("Warning"),
            content: Text(warningText),
            actions: [
              ElevatedButton(
                onPressed: buttonAction,
                child: _isSaving ? Text(loadText) : Text(buttonText),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateTask() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      // Prepare data
      ToDoDailyTasksHistory task = ToDoDailyTasksHistory(
        docId: widget.task.docId,
        to: _selectedAssignee!,
        from: FirebaseAuth.instance.currentUser!.displayName!,
        title: widget.titleController.text,
        desc: widget.descriptionController.text,
        uid: FirebaseAuth.instance.currentUser!.uid,
      );

      taskService.updateTask(task, context);
      Navigator.pop(context);
      Navigator.pop(context);

    }
  }
}
