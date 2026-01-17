// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do/services/list.dart';
// import 'package:to_do/authorization_elements/Text_Field_Form.dart';
//
// import '../../services/database.dart';
//
// class AddCard extends StatefulWidget {
//   AddCard({super.key});
//
//   @override
//   State<AddCard> createState() => _AddCardState();
// }
//
// class _AddCardState extends State<AddCard> {
//   final TaskService taskService = TaskService();
//
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String? selectedAssignee;
//
//   final UserDetailDatabase userDb = UserDetailDatabase();
//
//   bool _isSaving = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//       child: SingleChildScrollView(
//         child: AlertDialog(
//           title: const Text("Add New Task"),
//           content: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 StreamBuilder<List<String>>(
//                   stream: userDb.getDropdownValues('username'),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Text('Loading...');
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Text("No users available");
//                     }
//
//                     final users = snapshot.data!;
//
//                     return DropdownButtonFormField<String>(
//                       initialValue: selectedAssignee,
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
//                           selectedAssignee = value;
//                         });
//                       },
//                       validator: (value) => value == null ? "Required" : null,
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//                 Text_Field_Form(
//                   controller: titleController,
//                   labelText: "Title:",
//                   errorText: "Required",
//                 ),
//                 const SizedBox(height: 10),
//                 Text_Field_Form(
//                   controller: descriptionController,
//                   labelText: "Description:",
//                   errorText: "Required",
//                   maxLines: 4,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: _isSaving ? null : _saveTask,
//               child: _isSaving
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _saveTask() async {
//     if (formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isSaving = true;
//       });
//
//       // Prepare data
//       ToDoDailyTasksHistory task = ToDoDailyTasksHistory(
//         docId: '',
//         to: selectedAssignee!,
//         from: FirebaseAuth.instance.currentUser!.displayName!,
//         title: titleController.text,
//         desc: descriptionController.text,
//         uid: FirebaseAuth.instance.currentUser!.uid,
//       );
//
//       try {
//         // Save to Firestore
//         taskService.addTask(task, context);
//         if (mounted) {
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text("Failed to save task: $e")));
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSaving = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
// }

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/list.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

import '../../Widgets/multi_user_selector_sheet.dart';
import '../../services/database.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final TaskService taskService = TaskService();
  final UserDetailDatabase userDb = UserDetailDatabase();

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> selectedAssignees = [];
  DateTime? startDateTime;
  DateTime? endDateTime;

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add New Task"),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ASSIGN USERS
                StreamBuilder<List<String>>(
                  stream: userDb.getDropdownValues('username'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final users = snapshot.data!;

                    return InkWell(
                      onTap: () => openUserSelector(users),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Assign To",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorText: selectedAssignees.isEmpty
                              ? "Select at least one user"
                              : null,
                        ),
                        child: Text(
                          selectedAssignees.isEmpty
                              ? "Tap to select users"
                              : selectedAssignees.join(", "),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                /// DATE & TIME PICKERS
                SizedBox(
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
                            child: Text(
                              startDateTime == null
                                  ? "Select"
                                  : formatDate(startDateTime!),
                            ),
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
                            child: Text(
                              endDateTime == null
                                  ? "Select"
                                  : formatDate(endDateTime!),
                            ),
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
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : saveTask,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
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
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
      firstDate: startDateTime ?? DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: startDateTime ?? DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  /// SAVE TASK
  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedAssignees.isEmpty) {
      showError("Please select at least one user");
      return;
    }

    if (startDateTime == null || endDateTime == null) {
      showError("Please select start & end time");
      return;
    }

    if (endDateTime!.isBefore(startDateTime!)) {
      showError("End time must be after start time");
      return;
    }

    setState(() => _isSaving = true);

    try {
      for (final assignee in selectedAssignees) {
        final task = ToDoDailyTasksHistory(
          to: assignee,
          from: FirebaseAuth.instance.currentUser!.displayName!,
          startDateTime: startDateTime!,
          endDateTime: endDateTime!,
          title: titleController.text,
          desc: descriptionController.text,
          uid: FirebaseAuth.instance.currentUser!.uid,
        );

        await taskService.addTask(task, context);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      showError("Failed to save task");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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

  /// HELPERS
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
