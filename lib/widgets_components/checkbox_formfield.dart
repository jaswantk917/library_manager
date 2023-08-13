import 'package:flutter/material.dart';

/// Use CheckboxListTile as part of Form
class CheckboxListTileFormField extends FormField<bool> {
  CheckboxListTileFormField({
    Key? key,
    Widget? title,
    BuildContext? context,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    ValueChanged<bool>? onChanged,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    bool dense = false,
    Color? errorColor,
    Color? activeColor,
    Color? checkColor,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
    EdgeInsetsGeometry? contentPadding,
    bool autofocus = false,
    Widget? subtitle,
    Widget? secondary,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<bool> state) {
            errorColor ??= (context == null
                ? Colors.red
                : Theme.of(context).colorScheme.error);

            return CheckboxListTile(
              title: title,
              dense: dense,
              activeColor: activeColor,
              checkColor: checkColor,
              value: state.value,
              onChanged: enabled
                  ? (value) {
                      state.didChange(value);
                      if (onChanged != null) onChanged(value!);
                    }
                  : null,
              subtitle: state.hasError
                  ? Text(
                      state.errorText!,
                      style: TextStyle(color: errorColor),
                    )
                  : subtitle,
              controlAffinity: controlAffinity,
              secondary: secondary,
              contentPadding: contentPadding,
              autofocus: autofocus,
            );
          },
        );
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      Widget? title,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false,
      String subtitle = ''})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              title: title,
              value: state.value,
              onChanged: state.didChange,
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText ?? "",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    )
                  : Text(subtitle),
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}