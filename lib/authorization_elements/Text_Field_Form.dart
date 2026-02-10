import 'package:flutter/material.dart';

// Widget Text_Field_Form({
//   required TextEditingController controller,
//   required String labelText,
//   required String errorText,
//   Color labelColor = Colors.black,
//   obscureText = false,
// }) {
//   return TextFormField(
//     style: TextStyle(color: labelColor),
//     obscureText: obscureText,
//     enableSuggestions: !obscureText,
//     autocorrect: !obscureText,
//     controller: controller,
//     keyboardType: TextInputType.emailAddress,
//     decoration: InputDecoration(
//       fillColor: Colors.white,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//       label: Text(labelText, style: TextStyle(color: labelColor)),
//     ),
//     validator: (value) {
//       if (value == null || value == "") {
//         return errorText;
//       }
//       return null;
//     },
//   );
// }

class Text_Field_Form extends StatefulWidget {
  const Text_Field_Form({
    super.key,
    required this.controller,
    required this.labelText,
    required this.errorText,
    this.labelColor = Colors.black,
    this.isPassword = false,
    this.maxLines = 1,
  });

  @override
  State<Text_Field_Form> createState() => _Text_Field_Form_State();

  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final Color labelColor;
  final bool isPassword;
  final int maxLines;
}

class _Text_Field_Form_State extends State<Text_Field_Form> {
  bool _ishidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.labelColor),
      obscureText: widget.isPassword ? _ishidden : false,
      enableSuggestions: !widget.isPassword,
      maxLines: widget.maxLines,
      minLines: widget.maxLines,
      autocorrect: !widget.isPassword,
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        fillColor: Colors.white,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _ishidden ? Icons.visibility_off : Icons.visibility,
                ),
                iconSize: 15,
                onPressed: () {
                  setState(() {
                    _ishidden = !_ishidden;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        label: Text(
          widget.labelText,
          style: TextStyle(color: widget.labelColor),
          textAlign: TextAlign.center,
        ),
      ),
      validator: (value) {
        if (value == null || value == "") {
          return widget.errorText;
        }
        return null;
      },
    );
  }
}
