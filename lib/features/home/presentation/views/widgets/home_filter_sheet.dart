import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFilterSheet extends StatelessWidget {
  const HomeFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.brands != current.brands ||
          previous.selectedCategorySlug != current.selectedCategorySlug ||
          previous.selectedBrandName != current.selectedBrandName,
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.78,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter Products',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColor.textPrimary,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColor.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterOption(
                            label: 'All',
                            isSelected: state.selectedCategorySlug == null,
                            onSelected: () => context
                                .read<HomeCubit>()
                                .filterByCategory(null),
                          ),
                          ...state.categories.map(
                            (category) => _FilterOption(
                              label: category.name,
                              isSelected:
                                  state.selectedCategorySlug == category.slug,
                              onSelected: () => context
                                  .read<HomeCubit>()
                                  .filterByCategory(category.slug),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Brand',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColor.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterOption(
                            label: 'All',
                            isSelected: state.selectedBrandName == null,
                            onSelected: () =>
                                context.read<HomeCubit>().filterByBrand(null),
                          ),
                          ...state.brands.map(
                            (brand) => _FilterOption(
                              label: '${brand.emoji} ${brand.name}',
                              isSelected: state.selectedBrandName == brand.name,
                              onSelected: () => context
                                  .read<HomeCubit>()
                                  .filterByBrand(brand.name),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: state.hasActiveFilters
                            ? context.read<HomeCubit>().clearFilters
                            : null,
                        child: const Text('Clear Filters'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: AppColor.secondary,
      backgroundColor: AppColor.surfaceSoft,
      side: BorderSide(
        color: isSelected ? AppColor.primary : AppColor.inputBorder,
      ),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isSelected ? AppColor.primary : AppColor.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
