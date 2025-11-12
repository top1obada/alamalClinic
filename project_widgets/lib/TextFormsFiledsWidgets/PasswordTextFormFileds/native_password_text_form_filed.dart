import 'package:flutter/material.dart';
import 'package:project_widgets/Validators/vd_not_empty.dart';
import 'package:project_widgets/Validators/vd_password.dart';

class WDNativePasswordTextFormField extends StatelessWidget {
  const WDNativePasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textDirection,
  });

  final TextEditingController controller;
  final String hintText;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      textDirection: textDirection, // Add textDirection support
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: (value) {
        String? validValue = EmptyValidator.validateNotEmpty(value, 'password');

        if (validValue != null) return validValue;

        validValue = PasswordValidator.validatePassword(value);

        if (validValue != null) return validValue;

        return null;
      },
    );
  }
}
