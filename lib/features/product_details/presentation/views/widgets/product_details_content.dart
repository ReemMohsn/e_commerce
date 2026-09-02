import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_image_gallery.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_rating.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_review_card.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/quantity_selector.dart';
import 'package:flutter/material.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.selectedImageIndex,
    required this.quantity,
    required this.isFavorite,
    required this.canDecreaseQuantity,
    required this.canIncreaseQuantity,
    required this.onRefresh,
    required this.onImageSelected,
    required this.onFavoriteTap,
    required this.onDecreaseQuantity,
    required this.onIncreaseQuantity,
  });

  final ProductModel product;
  final int selectedImageIndex;
  final int quantity;
  final bool isFavorite;
  final bool canDecreaseQuantity;
  final bool canIncreaseQuantity;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onImageSelected;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onIncreaseQuantity;

  @override
  Widget build(BuildContext context) {
    final images = product.images.isNotEmpty
        ? product.images
        : <String>[product.thumbnail];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ProductImageGallery(
                images: images,
                selectedIndex: selectedImageIndex
                    .clamp(0, images.length - 1)
                    .toInt(),
                isFavorite: isFavorite,
                onImageSelected: onImageSelected,
                onFavoriteTap: onFavoriteTap,
              ),
            ),
          ),
          ColoredBox(
            color: AppColor.surfaceSoft,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _StatusBadge(
                                icon: Icons.local_shipping_outlined,
                                label: product.shippingInformation,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ProductRating(
                            rating: product.rating,
                            reviewCount: product.reviews.length,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            product.brand,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 8),
                            _StatusBadge(
                              icon: Icons.sell_outlined,
                              label:
                                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Product Details',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.textPrimary,
                        ),
                      ),
                      if (product.tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 7,
                          children: product.tags
                              .map(
                                (tag) => Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: AppColor.background,
                                  side: const BorderSide(
                                    color: AppColor.outlineSoft,
                                  ),
                                  label: Text('#$tag'),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _ProductInformation(product: product),
                      const SizedBox(height: 20),
                      QuantitySelector(
                        quantity: quantity,
                        minimumQuantity: product.minimumOrderQuantity,
                        canDecrease: canDecreaseQuantity,
                        canIncrease: canIncreaseQuantity,
                        onDecrease: onDecreaseQuantity,
                        onIncrease: onIncreaseQuantity,
                      ),
                      if (product.reviews.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Customer Reviews',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        for (final review in product.reviews) ...[
                          ProductReviewCard(review: review),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductInformation extends StatelessWidget {
  const _ProductInformation({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            _InformationRow(
              icon: Icons.inventory_2_outlined,
              label: 'Availability',
              value: '${product.availabilityStatus} (${product.stock})',
            ),
            const Divider(),
            _InformationRow(
              icon: Icons.verified_user_outlined,
              label: 'Warranty',
              value: product.warrantyInformation,
            ),
            const Divider(),
            _InformationRow(
              icon: Icons.assignment_return_outlined,
              label: 'Returns',
              value: product.returnPolicy,
            ),
            const Divider(),
            _InformationRow(
              icon: Icons.qr_code_2_rounded,
              label: 'SKU',
              value: product.sku,
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColor.primary),
          const SizedBox(width: 9),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColor.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColor.primary),
            ),
          ),
        ],
      ),
    );
  }
}
