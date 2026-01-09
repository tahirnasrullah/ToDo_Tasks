import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/services/List.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

class Add_card extends StatefulWidget {
  // 1. Define the callback parameter to accept the function.
  final VoidCallback? onTaskAdded;

  const Add_card({super.key, this.onTaskAdded});

  @override
  State<Add_card> createState() => _Add_cardState();
}

class _Add_cardState extends State<Add_card> {
  final formKey = GlobalKey<FormState>();

  // Define your TextEditingControllers here
  final TextEditingController to_assing_controller = TextEditingController();
  final TextEditingController title_controller = TextEditingController();
  final TextEditingController description_controller = TextEditingController();

  // A flag to prevent multiple submissions
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text("Add New Task"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your Text_Field_Form widgets go here...
              Text_Field_Form(
                controller: to_assing_controller,
                labelText: "To:",
                errorText: "Required",
              ),
              const SizedBox(height: 10),
              Text_Field_Form(
                controller: title_controller,
                labelText: "Title:",
                errorText: "Required",
              ),
              const SizedBox(height: 10),
              Text_Field_Form(
                controller: description_controller,
                labelText: "Description:",
                errorText: "Required",
                maxLines: 3,
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
            // Show a loading indicator on the button while saving
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
    );
  }

  Future<void> _saveTask() async {
    // Check if the form is valid
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      // Prepare data
      ToDoDailyTasks_history task = ToDoDailyTasks_history(
        to: to_assing_controller.text,
        from: "",
        title: title_controller.text,
        desc: description_controller.text,
      );

      try {
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection("ToDoDailyTasks")
            .doc(DateTime.now().toString()) // Consider a more robust ID
            .set(task.toMap());

        // 2. Call the callback function after a successful save.
        // The ?.call() safely invokes it only if it's not null.
        widget.onTaskAdded?.call();

        // Close the dialog only after everything is done
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        // Handle any errors
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to save task: $e")));
        }
      } finally {
        // Ensure the saving flag is reset even if an error occurs
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
    // Clean up controllers
    to_assing_controller.dispose();
    title_controller.dispose();
    description_controller.dispose();
    super.dispose();
  }
}
