import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              size: 27,
              color: AppColor.primary,
            ),
          ),
          if (itemCount > 0)
            Positioned(
              top: 3,
              right: 1,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  itemCount > 9 ? '9+' : '$itemCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
