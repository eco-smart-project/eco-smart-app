import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final void Function(String?) onSubmitted;

  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.textInputAction = TextInputAction.next,
    required this.onSubmitted,
    this.enabled = true,
  });

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: 'Digite sua senha',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
