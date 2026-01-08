import 'package:flutter/material.dart';

Widget text_ui_shadow(value, text_key) {
  return Text(
    value[text_key].toString(),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
      ],
    ),
  );
}

Widget text_ui_tile(value, text_key) {
  return Text(
    value[text_key].toString(),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}
