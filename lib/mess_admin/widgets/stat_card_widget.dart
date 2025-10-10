import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/neu_container.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String iconPath;
  const StatCardWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.subtitle,
      required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      width: 200,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            iconPath,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
