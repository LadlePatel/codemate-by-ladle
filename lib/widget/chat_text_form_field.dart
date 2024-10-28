import 'package:flutter/material.dart';

class ChattextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;

  const ChattextFormField({
    super.key,
    this.focusNode,
    this.controller,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      autocorrect: true,
      focusNode: focusNode,
      controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 27, 53, 75),
      ),
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: "Enter Your Prompt",
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please Enter Some Text";
        }
        return null;
      },
    );
  }
}
