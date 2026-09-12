import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/cart/presentation/views/widgets/cart_checkout_bar.dart';
import 'package:e_commeric/features/cart/presentation/views/widgets/cart_product_card.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_cubit.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartContent extends StatelessWidget {
  const CartContent({required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.watch<FavoriteCubit>();
    final subtotal = products.fold<double>(
      0,
      (total, product) => total + product.priceAfterDiscount,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Products on Cart',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return CartProductCard(
                product: product,
                isFavorite: favoriteCubit.isFavorite(product.id),
                onFavoriteTap: () => favoriteCubit.toggleFavorite(product.id),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    AppRoute.productDetails,
                    arguments: product.id,
                  );
                  if (context.mounted) {
                    favoriteCubit.loadFavoriteStatus();
                  }
                },
              );
            },
          ),
        ),
        CartCheckoutBar(itemCount: products.length, subtotal: subtotal),
      ],
    );
  }
}
