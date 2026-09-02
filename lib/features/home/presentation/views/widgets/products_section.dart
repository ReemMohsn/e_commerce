import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_message.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/product_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.productsStatus != current.productsStatus ||
          previous.filteredProducts != current.filteredProducts ||
          previous.productsErrorMessage != current.productsErrorMessage ||
          previous.selectedCategorySlug != current.selectedCategorySlug ||
          previous.selectedBrandName != current.selectedBrandName,
      builder: (context, state) {
        switch (state.productsStatus) {
          case HomeRequestStatus.initial:
          case HomeRequestStatus.loading:
            return const SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          case HomeRequestStatus.failure:
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: HomeMessage(
                  icon: Icons.cloud_off_outlined,
                  message:
                      state.productsErrorMessage ?? 'Unable to load products.',
                  actionLabel: 'Retry',
                  onAction: context.read<HomeCubit>().fetchProducts,
                ),
              ),
            );
          case HomeRequestStatus.success:
            final visibleProducts = state.filteredProducts;

            if (visibleProducts.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: state.hasActiveFilters
                      ? HomeMessage(
                          icon: Icons.filter_alt_off_outlined,
                          message:
                              'No products found for the selected filters.',
                          actionLabel: 'Clear Filters',
                          onAction: context.read<HomeCubit>().clearFilters,
                        )
                      : const HomeMessage(
                          icon: Icons.inventory_2_outlined,
                          message: 'No products are available right now.',
                        ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final columns = width >= 900
                      ? 4
                      : width >= 600
                      ? 3
                      : 2;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 264,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = visibleProducts[index];
                      return ProductItemCard(
                        product: product,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoute.productDetails,
                          arguments: product.id,
                        ),
                      );
                    }, childCount: visibleProducts.length),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
