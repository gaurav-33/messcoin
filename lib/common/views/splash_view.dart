import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/splash_controller.dart';
import '../../utils/responsive.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  final SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Brightness.dark == Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    SizedBox(
                        width: Responsive.contentWidth(context) * 0.5,
                        child: Image.asset(
                          isDark
                              ? "assets/images/mess-coin-logo-dark.png"
                              : "assets/images/mess-coin-logo-light.png",
                        )),
                    // const SizedBox(height: 20),
                    // Text(
                    //   'Mess Coin',
                    //   style: theme.textTheme.headlineLarge,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
