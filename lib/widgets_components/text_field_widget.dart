import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.callback,
      required this.labelText,
      required this.textCapitalization,
      required this.textInputType,
      required this.icon});
  final Function(String?) callback;
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          icon: icon,
        ),
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        onChanged: callback,
      ),
    );
  }
}
