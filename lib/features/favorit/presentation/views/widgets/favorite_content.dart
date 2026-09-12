import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_state.dart';
import 'package:e_commeric/features/favorit/presentation/views/widgets/pagination_footer.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_section_header.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/product_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteContent extends StatelessWidget {
  const FavoriteContent({
    super.key,
    required this.state,
    required this.scrollController,
  });

  final FavoriteSuccess state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(14, 8, 14, 12),
          sliver: SliverToBoxAdapter(
            child: HomeSectionHeader(title: 'All Products'),
          ),
        ),
        SliverPadding(
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
                  final product = state.products[index];
                  return ProductItemCard(
                    product: product,
                    isFavorite: true,
                    onFavoriteTap: () => context
                        .read<FavoriteCubit>()
                        .deleteFavorite(product.id),
                    onAddTap: () =>
                        context.read<CartCubit>().addToCart(product.id),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoute.productDetails,
                        arguments: product.id,
                      );
                      if (context.mounted) {
                        context.read<FavoriteCubit>().getFavorite();
                      }
                    },
                  );
                }, childCount: state.products.length),
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: PaginationFooter(state: state)),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
