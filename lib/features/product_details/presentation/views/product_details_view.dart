import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_state.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/views/widgets/favorite_action_listener.dart';
import 'package:e_commeric/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:e_commeric/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_details_content.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_purchase_bar.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_message.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/cart_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.watch<FavoriteCubit>();

    return FavoriteActionListener(
      child: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is AddCartSuccess) {
            Navigator.of(context, rootNavigator: true).pop();

            context.showSuccessSnackBar(state.message);
          } else if (state is AddCartFailure) {
            Navigator.of(context, rootNavigator: true).pop();

            context.showErrorSnackBar(state.errorMessage);
          } else if (state is AddCartLoading) {
            context.showLoadingDialog();
          }
        },
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            final cubit = context.read<ProductDetailsCubit>();
            final Widget body;
            final Widget? purchaseBar;

            if (state is ProductDetailsSuccess) {
              body = ProductDetailsContent(
                product: state.product,
                selectedImageIndex: state.selectedImageIndex,
                isFavorite: favoriteCubit.isFavorite(state.product.id),
                onImageSelected: cubit.selectImage,
                onFavoriteTap: () =>
                    favoriteCubit.toggleFavorite(state.product.id),
              );
              purchaseBar = ProductPurchaseBar(
                product: state.product,
                onAddToCart: () =>
                    context.read<CartCubit>().addToCart(state.product.id),
              );
            } else if (state is ProductDetailsFailure) {
              body = HomeMessage(
                icon: Icons.cloud_off_outlined,
                message: state.errorMessage,
                actionLabel: 'Retry',
                onAction: cubit.retry,
              );
              purchaseBar = null;
            } else {
              body = const Center(child: CircularProgressIndicator());
              purchaseBar = null;
            }

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                centerTitle: true,
                leadingWidth: 62,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColor.outlineSoft),
                      ),
                    ),
                    child: IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Product Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                actions: [
                  CartButton(
                    itemCount: 0,
                    onPressed: () async {
                      await Navigator.pushNamed(context, AppRoute.cart);
                      if (context.mounted) {
                        favoriteCubit.loadFavoriteStatus();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: body,
              bottomNavigationBar: purchaseBar,
            );
          },
        ),
      ),
    );
  }
}
