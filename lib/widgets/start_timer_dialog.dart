import 'package:flutter/material.dart';

Future<void> showInformationDialog({
  required BuildContext context,
  String title = "Confirm",
  String initialValue = "",
  void Function()? onTap,
  void Function(String)? onChange,
}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: onChange,
                  decoration: InputDecoration(hintText: "Please Enter Seconds"),
                ),
              ],
            ),
            title: Text(title),
            actions: <Widget>[
              InkWell(
                child: Text('Cancel   '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              InkWell(
                child: Text('OK   '),
                onTap: () {
                  onTap!();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      });
}
