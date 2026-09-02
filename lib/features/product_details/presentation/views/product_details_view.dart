import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:e_commeric/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_details_content.dart';
import 'package:e_commeric/features/product_details/presentation/views/widgets/product_purchase_bar.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/cart_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        final Widget body;
        final Widget? purchaseBar;

        if (state is ProductDetailsSuccess) {
          body = ProductDetailsContent(
            product: state.product,
            selectedImageIndex: state.selectedImageIndex,
            quantity: state.quantity,
            isFavorite: state.isFavorite,
            canDecreaseQuantity: state.canDecreaseQuantity,
            canIncreaseQuantity: state.canIncreaseQuantity,
            onRefresh: cubit.retry,
            onImageSelected: cubit.selectImage,
            onFavoriteTap: cubit.toggleFavorite,
            onDecreaseQuantity: cubit.decrementQuantity,
            onIncreaseQuantity: cubit.incrementQuantity,
          );
          purchaseBar = ProductPurchaseBar(product: state.product);
        } else if (state is ProductDetailsFailure) {
          body = _ProductDetailsError(
            message: state.errorMessage,
            onRetry: cubit.retry,
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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
              ),
            ),
            title: Text(
              'Product Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              const CartButton(itemCount: 0),
              const SizedBox(width: 8),
            ],
          ),
          body: body,
          bottomNavigationBar: purchaseBar,
        );
      },
    );
  }
}

class _ProductDetailsError extends StatelessWidget {
  const _ProductDetailsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColor.hint,
              size: 52,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
