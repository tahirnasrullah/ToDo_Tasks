import 'package:flutter/material.dart';
import 'package:to_do/authorization_elements/Text_Field_Form.dart';

class add_card extends StatelessWidget {
  add_card({super.key});

  TextEditingController to_assing_controller = TextEditingController();
  TextEditingController start_controller = TextEditingController();
  TextEditingController end_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: SizedBox(
        width: 600,
        child: Card(
          elevation: 0, // No shadow needed as it's in a dialog
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.add_task),
                  title: Text('New Task'),
                ),
                Text_Field_Form(
                  controller: to_assing_controller,
                  labelText: "To:",
                  errorText: "Whom to assign the task?",
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text_Field_Form(
                          controller: start_controller,
                          labelText: "Start:",
                          errorText: "",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text_Field_Form(
                          controller: end_controller,
                          labelText: "End:",
                          errorText: "",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: Text_Field_Form(
                    controller: description_controller,
                    labelText: "Description...",
                    errorText: "",
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancel")),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: Text("Save"))
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
