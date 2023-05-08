import 'package:flutter/material.dart';

Widget elevatedFilledButton(
    {required String title, required Color color, void Function()? onTap}) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )),
          ),
        ),
      ),
    ],
  );
}
