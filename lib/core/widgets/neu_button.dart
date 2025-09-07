import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  const NeuButton({
    super.key,
    this.width,
    this.height,
    required this.child,
    this.onTap,
    this.shape,
    this.invert,
    this.padding,
    this.invertColor,
  });

  final double? width;
  final double? height;
  final Widget child;
  final VoidCallback? onTap;
  final BoxShape? shape;
  final bool? invert;
  final EdgeInsets? padding;
  final Color? invertColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(microseconds: 1000),
          curve: Curves.easeInBack,
          width: width ?? 100,
          height: height ?? 50,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: shape != null ? null : BorderRadius.circular(15),
            color: invert != null && invert!
                ? invertColor ?? theme.colorScheme.secondary
                : theme.colorScheme.surface,
            shape: shape ?? BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 10,
                spreadRadius: 1,
                offset: invert != null && invert == true
                    ? const Offset(-5, -5)
                    : const Offset(5, 5),
              ),
              BoxShadow(
                color: theme.colorScheme.onPrimary,
                blurRadius: 10,
                spreadRadius: 1,
                offset: invert != null && invert == true
                    ? const Offset(5, 5)
                    : const Offset(-5, -5),
              ),
            ],
          ),
          child: Center(child: child)),
    );
  }
}
