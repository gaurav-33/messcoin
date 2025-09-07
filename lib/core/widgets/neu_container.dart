import 'package:flutter/material.dart';

class NeuContainer extends StatelessWidget {
  const NeuContainer({
    super.key,
    this.height,
    this.width,
    this.constraints,
    this.padding,
    this.shape,
    this.margin,
    required this.child,
  });

  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: constraints,
      height: height,
      width: width,
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: shape != null ? null : BorderRadius.circular(25),
          shape: shape ?? BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              offset: const Offset(5, 5),
              blurRadius: 15,
            ),
            BoxShadow(
              color: theme.colorScheme.onPrimary,
              offset: const Offset(-5, -5),
              blurRadius: 15,
            ),
          ]),
      child: Center(child: child),
    );
  }
}
