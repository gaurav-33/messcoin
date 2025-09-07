import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.width,
    this.height,
    this.label,
    this.hintText,
    this.prefixText,
    this.obscure,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.controller,
    this.keyboardType,
  });
  final String? label;
  final String? hintText;
  final String? prefixText;
  final double? width;
  final double? height;
  final bool? obscure;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscure ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.label ?? 'Label',
          style: theme.textTheme.bodyMedium,
        ),
      ),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(bottom: 10),
          height: widget.height ?? 60,
          width: widget.width,
          decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow,
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: theme.colorScheme.onPrimary,
                  offset: const Offset(-5, -5),
                  blurRadius: 10,
                ),
              ]),
          child: Center(
            child: TextFormField(
              obscureText: isObscure,
              cursorColor: theme.colorScheme.secondary,
              maxLines: widget.maxLines ?? 1,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              controller: widget.controller,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText ?? 'Enter',
                  hintStyle: theme.textTheme.bodySmall,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  prefixText: widget.prefixText,
                  prefixStyle: theme.textTheme.bodyMedium,
                  suffixIcon: (widget.obscure == true)
                      ? IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        )
                      : null),
            ),
          )),
    ]);
  }
}
