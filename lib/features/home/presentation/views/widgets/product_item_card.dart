import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductItemCard extends StatelessWidget {
  const ProductItemCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final discount = product.hasDiscount ? product.discountPercentage : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AppNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.contain,
                          fallbackIcon: Icons.inventory_2_outlined,
                        ),
                      ),
                    ),
                    if (discount != null)
                      Positioned(
                        top: 7,
                        left: 7,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            child: Text(
                              '${discount.round()}% OFF',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColor.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Material(
                        color: AppColor.background,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onFavoriteTap ?? () {},
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 20,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatPrice(product.priceAfterDiscount),
                maxLines: 1,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (product.hasDiscount)
                Text(
                  _formatPrice(product.price),
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.hint,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              else
                const SizedBox(height: 13),
              const SizedBox(height: 2),
              Text(
                product.title.isEmpty ? 'Unnamed product' : product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColor.rating,
                    size: 17,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double value) {
    final amount = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$amount LE';
  }
}
