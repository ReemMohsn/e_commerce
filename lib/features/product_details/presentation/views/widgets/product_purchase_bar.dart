import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColor.background,
        border: Border(top: BorderSide(color: AppColor.outlineSoft)),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price', style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      _formatPrice(product.priceAfterDiscount),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (product.hasDiscount)
                      Text(
                        _formatPrice(product.price),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColor.hint,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    foregroundColor: AppColor.primary,
                    side: const BorderSide(color: AppColor.primary, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double value) => '${value.toStringAsFixed(2)} EGP';
}
