import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String message,
    void Function()? onPressedCancel, void Function()? onPressedConfirm) {
  // set up the buttons
  Widget cancelButton = TextButton(
    onPressed: onPressedCancel,
    child: const Text("Cancel"),
  );
  Widget continueButton = TextButton(
    onPressed: onPressedConfirm,
    child: const Text("Continue"),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
