import 'package:flutter/material.dart';

class TextFields {
  TextFields._();

  static Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    String? Function(String?)? validator,
    String? initVal,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        textDirection: textDirection, // Added textDirection parameter
        textAlign: textAlign, // Added textAlign parameter
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          alignLabelWithHint: true,
        ),
        validator: validator,
      ),
    );
  }
}
