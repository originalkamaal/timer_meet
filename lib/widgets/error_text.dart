import 'package:flutter/material.dart';

Visibility errorText(String error) => Visibility(
    visible: error != "",
    child: Text(
      error,
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ));
