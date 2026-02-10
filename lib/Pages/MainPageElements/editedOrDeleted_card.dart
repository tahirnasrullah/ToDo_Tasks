// import 'dart:ui';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do/services/list.dart';
// import 'package:to_do/authorization_elements/Text_Field_Form.dart';
//
// import '../../services/database.dart';
//
// class EditedOrDeletedCard extends StatefulWidget {
//   final TextEditingController titleController;
//   final TextEditingController descriptionController;
//   final String? selectedAssignee;
//   final ToDoDailyTasksHistory task;
//
//   EditedOrDeletedCard({
//     super.key,
//     required this.titleController,
//     required this.descriptionController,
//     required this.selectedAssignee,
//     required this.task,
//   });
//
//   @override
//   State<EditedOrDeletedCard> createState() => _EditedOrDeletedCardState();
// }
//
// class _EditedOrDeletedCardState extends State<EditedOrDeletedCard> {
//   final TaskService taskService = TaskService();
//
//   final formKey = GlobalKey<FormState>();
//
//   final UserDetailDatabase userDb = UserDetailDatabase();
//
//   bool _isSaving = false;
//   String? _selectedAssignee;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedAssignee = widget.selectedAssignee;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//       child: SingleChildScrollView(
//         child: AlertDialog(
//           title: const Text("Update Task"),
//           content: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 StreamBuilder<List<String>>(
//                   stream: userDb.getDropdownValues('username'),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Text('Loading...');
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Text("No users available");
//                     }
//
//                     final users = snapshot.data!;
//
//                     return DropdownButtonFormField<String>(
//                       initialValue: _selectedAssignee,
//                       decoration: InputDecoration(
//                         labelText: "To:",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       items: users.map((user) {
//                         return DropdownMenuItem<String>(
//                           value: user,
//                           child: Text(user),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedAssignee = value;
//                         });
//                       },
//                       validator: (value) => value == null ? "Required" : null,
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//                 Text_Field_Form(
//                   controller: widget.titleController,
//                   labelText: "Title:",
//                   errorText: "Required",
//                 ),
//                 const SizedBox(height: 10),
//                 Text_Field_Form(
//                   controller: widget.descriptionController,
//                   labelText: "Description:",
//                   errorText: "Required",
//                   maxLines: 4,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     _showCardDialog(
//                       context,
//                       widget.task,
//                       "Are you sure you want to delete this task?",
//                       "Delete",
//                       () async {
//                         await taskService.delnote(widget.task, context);
//                         Navigator.pop(context);
//                       },
//                       "Deleting...",
//                     );
//                   },
//                   child: const Text("Delete"),
//                 ),
//
//                 SizedBox(width: 5),
//                 ElevatedButton(
//                   onPressed: () {
//                     _showCardDialog(
//                       context,
//                       widget.task,
//                       "Are you sure you want to update this task?",
//                       "Update",
//                       _updateTask,
//                       "Updating...",
//                     );
//                   },
//                   child: const Text("Update"),
//                 ),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Cancel"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCardDialog(
//     BuildContext context,
//     ToDoDailyTasksHistory task,
//     String warningText,
//     String buttonText,
//     VoidCallback buttonAction,
//     String loadText,
//   ) {
//     showDialog(
//       context: context,
//       builder: (value) {
//         return SizedBox(
//           height: 100,
//           child: AlertDialog(
//             title: const Text("Warning"),
//             content: Text(warningText),
//             actions: [
//               ElevatedButton(
//                 onPressed: buttonAction,
//                 child: _isSaving ? Text(loadText) : Text(buttonText),
//               ),
//               Expanded(
//                 child: TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _updateTask() async {
//     if (formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isSaving = true;
//       });
//
//       // Prepare data
//       ToDoDailyTasksHistory task = ToDoDailyTasksHistory(
//         docId: widget.task.docId,
//         to: _selectedAssignee!,
//         from: FirebaseAuth.instance.currentUser!.displayName!,
//         title: widget.titleController.text,
//         desc: widget.descriptionController.text,
//         uid: FirebaseAuth.instance.currentUser!.uid,
//         startDateTime: widget.task.startDateTime,
//         endDateTime: widget.task.endDateTime,
//       );
//
//       taskService.updateTask(task, context);
//       Navigator.pop(context);
//       Navigator.pop(context);
//
//     }
//   }
// }

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

import '../../Widgets/multi_user_selector_sheet.dart';
import '../../services/database.dart';

class EditTaskCard extends StatefulWidget {
  final ToDoDailyTasksHistory task;

  const EditTaskCard({super.key, required this.task});

  @override
  State<EditTaskCard> createState() => _EditTaskCardState();
}

class _EditTaskCardState extends State<EditTaskCard> {
  final TaskService taskService = TaskService();
  final UserDetailDatabase userDb = UserDetailDatabase();

  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  List<String> selectedAssignees = [];
  DateTime? startDateTime;
  DateTime? endDateTime;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.desc);

    startDateTime = widget.task.startDateTime;
    endDateTime = widget.task.endDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Edit Task"),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(child: Text(widget.task.to)),
                        ),

                        const SizedBox(height: 12),

                        /// DATE & TIME
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: pickStartDateTime,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Start Date & Time",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(formatDate(startDateTime!)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: pickEndDateTime,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "End Date & Time",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(formatDate(endDateTime!)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// TITLE
                        Text_Field_Form(
                          controller: titleController,
                          labelText: "Title",
                          errorText: "Required",
                        ),

                        const SizedBox(height: 10),

                        /// DESCRIPTION
                        Text_Field_Form(
                          controller: descriptionController,
                          labelText: "Description",
                          errorText: "Required",
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: confirmDelete,
                          child: const Text("Delete",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),),
                        ),
                      ),

                      SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent.shade700,
                          ),
                          onPressed: _isSaving ? null : updateTask,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Update",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// DATE PICKERS
  Future<void> pickStartDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: startDateTime!,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDateTime!),
    );
    if (time == null) return;

    setState(() {
      startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> pickEndDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: startDateTime!,
      lastDate: DateTime(2100),
      initialDate: endDateTime!,
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endDateTime!),
    );
    if (time == null) return;

    setState(() {
      endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  /// UPDATE TASK
  Future<void> updateTask() async {
    if (!formKey.currentState!.validate()) return;

    if (endDateTime!.isBefore(startDateTime!)) {
      showError("End time must be after start time");
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedTask = ToDoDailyTasksHistory(
        docId: widget.task.docId,
        to: widget.task.to,
        from: FirebaseAuth.instance.currentUser!.displayName!,
        startDateTime: startDateTime!,
        endDateTime: endDateTime!,
        title: titleController.text,
        desc: descriptionController.text,
        uid: widget.task.uid,
        isCompleted: widget.task.isCompleted,
        isAccepted: false,
        isDeclined: widget.task.isDeclined,
      );

      await taskService.updateTask(updatedTask, context);
      if (mounted) Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      showError("Update failed");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// DELETE
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Delete Task",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.grey),),
          ),
          OutlinedButton(
            style: ElevatedButton.styleFrom(
            ),
            onPressed: () async {
              await taskService.delnote(widget.task, context);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text("Delete",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red),),
          ),
        ],
      ),
    );
  }

  /// USER SELECTOR
  void openUserSelector(List<String> users) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return MultiUserSelectorSheet(
          users: users,
          selectedUsers: selectedAssignees,
          onDone: (result) {
            setState(() => selectedAssignees = result);
          },
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
