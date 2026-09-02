import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.onSearchTap,
    this.onFilterTap,
    this.isFilterActive = false,
  });

  final VoidCallback onSearchTap;
  final VoidCallback? onFilterTap;
  final bool isFilterActive;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      showCursor: false,
      onTap: onSearchTap,
      decoration: InputDecoration(
        hintText: 'What are you looking for?',
        prefixIcon: const Icon(Icons.search_rounded, size: 27),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6),
          child: IconButton(
            tooltip: 'Filter products',
            onPressed: onFilterTap ?? () {},
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isFilterActive
                  ? AppColor.secondary
                  : Colors.transparent,
              side: const BorderSide(color: AppColor.inputBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColor.primary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
