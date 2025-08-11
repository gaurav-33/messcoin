import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/splash_controller.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_button.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final SplashController controller =  Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Text(
                'Mess Coin',
                style: Theme.of(context)
                              .textTheme
                              .headlineLarge,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: NeuButton(
                shape: BoxShape.circle,
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  color: AppColors.dark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
