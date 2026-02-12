import 'package:flutter/material.dart';

Color colorCardText(isCompleted, isAccepted, isDeclined) => isCompleted == true
    ? Colors.green.shade700
    : isAccepted == true
    ? Colors.amber.shade700
    : isDeclined == true
    ? Colors.red.shade700
    : Colors.deepPurpleAccent.shade700;

Color colorCard(isCompleted, isAccepted, isDeclined) => isCompleted == true
    ? Colors.green.shade100
    : isAccepted == true
    ? Colors.amber.shade100
    : isDeclined == true
    ? Colors.red.shade100
    : Colors.deepPurpleAccent.shade100;
