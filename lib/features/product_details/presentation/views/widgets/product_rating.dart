import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProductRating extends StatelessWidget {
  const ProductRating({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final activeStars = rating.round().clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 5; index++)
          Icon(
            index < activeStars
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            color: AppColor.rating,
            size: 19,
          ),
        const SizedBox(width: 5),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
