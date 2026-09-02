import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.minimumQuantity,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final int minimumQuantity;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (minimumQuantity > 1)
              Text(
                'Minimum order: $minimumQuantity',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 150,
          height: 46,
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.inputBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Decrease quantity',
                onPressed: canDecrease ? onDecrease : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              Text(
                '$quantity',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                tooltip: 'Increase quantity',
                onPressed: canIncrease ? onIncrease : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
