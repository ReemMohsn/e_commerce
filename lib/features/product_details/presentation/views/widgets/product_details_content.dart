import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_image_gallery.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_information.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_rating.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_review_card.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.selectedImageIndex,
    required this.isFavorite,
    required this.onImageSelected,
    required this.onFavoriteTap,
  });

  final ProductModel product;
  final int selectedImageIndex;
  final bool isFavorite;
  final ValueChanged<int> onImageSelected;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final images = product.images.isNotEmpty
        ? product.images
        : <String>[product.thumbnail];

    return ListView(
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
                            child: StatusBadge(
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
                          StatusBadge(
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
                    ProductInformation(product: product),
                    if (product.reviews.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Customer Reviews',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
    );
  }
}
