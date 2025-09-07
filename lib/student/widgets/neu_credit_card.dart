import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:messcoin/config/app_colors.dart';

class NeuCreditCard extends StatefulWidget {
  const NeuCreditCard({
    super.key,
    this.fullName,
    this.rollNo,
    this.walletBalance,
    this.leftCoupon,
    this.onTap,
  });

  final String? fullName;
  final String? rollNo;
  final num? walletBalance;
  final num? leftCoupon;
  final VoidCallback? onTap;

  @override
  State<NeuCreditCard> createState() => _NeuCreditCardState();
}

class _NeuCreditCardState extends State<NeuCreditCard>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  Timer? _scrambleTimer;
  String _scrambledWallet = '';
  String _scrambledCoupon = '';

  @override
  void dispose() {
    _scrambleTimer?.cancel();
    super.dispose();
  }

  String _generateScrambleText(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void _startScrambleEffect() {
    _scrambleTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _scrambledWallet = _generateScrambleText(4);
        _scrambledCoupon = _generateScrambleText(4);
      });
    });
  }

  void _handleRefresh() async {
    if (_isRefreshing) return;

    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }

    _startScrambleEffect();

    widget.onTap?.call();

    await Future.delayed(const Duration(milliseconds: 350));
    _scrambleTimer?.cancel();
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  final List<Shadow> _shadows = [
    const Shadow(
      color: AppColors.darkLightShadowColor,
      blurRadius: 1,
      offset: Offset(-0.3, -0.3),
    ),
    const Shadow(
      color: Colors.black,
      blurRadius: 4,
      offset: Offset(2, 2),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth =
            constraints.maxWidth > 500 ? 500 : constraints.maxWidth;
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;
        return Container(
          constraints: const BoxConstraints(minHeight: 220),
          width: cardWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dark.withOpacity(0.9),
                Colors.black,
              ],
            ),
            border: Border.all(
              color: AppColors.darkLightShadowColor.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? AppColors.darkDarkShadowColor
                    : AppColors.darkShadowColor,
                offset: Offset(10, 10),
                blurRadius: 10,
              ),
              BoxShadow(
                color: isDarkMode
                    ? AppColors.darkLightShadowColor
                    : AppColors.lightShadowColor,
                offset: Offset(-10, -10),
                blurRadius: 10,
              ),
            ],
          ),
          child: _buildCardContent(context),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Mess Coin',
                style: TextStyle(
                  color: AppColors.neutralLight.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 1.5,
                  shadows: _shadows,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '|',
                style: TextStyle(
                  color: AppColors.lightDark,
                  fontSize: 16,
                  letterSpacing: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'NIT Patna',
                style: TextStyle(
                  color: AppColors.lightDark,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/chip.png',
                height: 44,
                color: AppColors.lightDark,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                color: AppColors.lightDark,
                onPressed: _handleRefresh,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.rollNo ?? '0000000',
                style: const TextStyle(
                  fontFamily: 'FiraCode',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColors.lightDark,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.fullName ?? 'Mess Coin User',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.neutralLight.withOpacity(0.8),
                  letterSpacing: 2,
                  overflow: TextOverflow.ellipsis,
                  shadows: _shadows,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceInfo('Left Coupon', '₹',
                  _isRefreshing ? _scrambledCoupon : (widget.leftCoupon ?? 0)),
              _buildBalanceInfo(
                  'Wallet',
                  '₹',
                  _isRefreshing
                      ? _scrambledWallet
                      : (widget.walletBalance ?? 0),
                  isEndAligned: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String currency, dynamic amount,
      {bool isEndAligned = false}) {
    return Column(
      crossAxisAlignment:
          isEndAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: AppColors.lightDark,
              fontSize: 12,
            )),
        RichText(
          text: TextSpan(
            text: '$currency ',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.lightDark,
            ),
            children: [
              TextSpan(
                text: '$amount',
                style: TextStyle(
                    fontFamily: 'FiraCode',
                    fontSize: 22,
                    color: AppColors.neutralLight.withOpacity(0.8),
                    letterSpacing: 1,
                    shadows: _shadows),
              )
            ],
          ),
        ),
      ],
    );
  }
}
