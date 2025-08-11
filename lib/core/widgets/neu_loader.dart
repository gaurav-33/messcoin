import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class NeuLoader extends StatefulWidget {
  const NeuLoader({super.key, this.size = 60});
  final double size;

  @override
  State<NeuLoader> createState() => _NeuLoaderState();
}

class _NeuLoaderState extends State<NeuLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: Center(
            child: Image.asset(
              'assets/images/looping-arrow.png',
              height: widget.size * 0.7,
              fit: BoxFit.cover,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
