import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.isFavorite,
    required this.onImageSelected,
    required this.onFavoriteTap,
  });

  final List<String> images;
  final int selectedIndex;
  final bool isFavorite;
  final ValueChanged<int> onImageSelected;
  final VoidCallback onFavoriteTap;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(covariant ProductImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex &&
        _pageController.hasClients) {
      _pageController.animateToPage(
        widget.selectedIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Column(
        children: [
          SizedBox(
            height: 285,
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    onPageChanged: widget.onImageSelected,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AppNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.contain,
                        fallbackIcon: Icons.inventory_2_outlined,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 0,
                  child: Material(
                    color: AppColor.background,
                    shape: const CircleBorder(
                      side: BorderSide(color: AppColor.outlineSoft),
                    ),
                    child: IconButton(
                      tooltip: widget.isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: widget.onFavoriteTap,
                      icon: Icon(
                        widget.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: widget.isFavorite
                            ? AppColor.danger
                            : AppColor.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.images.length > 1) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 58,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected = widget.selectedIndex == index;
                  return InkWell(
                    onTap: () => widget.onImageSelected(index),
                    borderRadius: BorderRadius.circular(9),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 58,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColor.background,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.primary
                              : AppColor.outlineSoft,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: AppNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.contain,
                          fallbackIcon: Icons.inventory_2_outlined,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
