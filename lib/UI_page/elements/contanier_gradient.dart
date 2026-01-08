// TODO Implement this library.import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

Widget contanier_gradient() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Colors.transparent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    ),
  );
}
