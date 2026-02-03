import 'package:flutter/material.dart';

Color ColorCardText(isCompleted,isAccepted,isDeclined)=>
    isCompleted == true
    ? Colors.green.shade900
    : isAccepted == true
    ? Colors.amber.shade900
    : isDeclined == true
    ? Colors.red.shade900
    : Colors.deepPurpleAccent.shade700;


Color ColorCard(isCompleted,isAccepted,isDeclined)=>
    isCompleted == true
    ? Colors.green.shade100
    : isAccepted == true
    ? Colors.amber.shade100
    : isDeclined == true
    ? Colors.red.shade100
    : Colors.deepPurpleAccent.shade100;