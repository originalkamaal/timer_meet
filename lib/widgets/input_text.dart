import 'package:flutter/material.dart';

Widget buildTextInput(
    {String placeHolder = "",
    String initialValue = "",
    String inputType = "",
    String iconName = "",
    void Function(String value)? onChange,
    TextEditingController? controller}) {
  return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade400)),
      width: double.maxFinite,
      height: 50,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 17),
            child: inputType == "mobile"
                ? const Text("+91")
                : Image.asset(
                    "assets/icons/$iconName.png",
                    height: 20,
                    width: 20,
                    opacity: AlwaysStoppedAnimation(0.7),
                  ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              initialValue: initialValue,
              onChanged: onChange,
              obscureText: inputType == "password" ? true : false,
              keyboardType: inputType == "mobile"
                  ? TextInputType.phone
                  : inputType == "number"
                      ? TextInputType.number
                      : TextInputType.name,
              style: TextStyle(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  height: 1.5),
              decoration: InputDecoration(
                hintText: placeHolder,
                contentPadding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                hintStyle: TextStyle(height: 1.5, color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ));
}
