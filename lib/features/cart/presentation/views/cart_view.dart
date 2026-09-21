import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:e_commeric/features/cart/presentation/view_model/cart_state.dart';
import 'package:e_commeric/features/cart/presentation/views/widgets/cart_content.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_message.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/profile_avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  Future<void> _openProfile(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoute.profile);
    if (context.mounted) {
      context.read<ProfileCubit>().getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          AppStrings.cart,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final image = state is ProfileSuccess ? state.user.image : null;
                return ProfileAvatarButton(
                  imageUrl: image,
                  onPressed: () => _openProfile(context),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartFailure) {
            return HomeMessage(
              icon: Icons.cloud_off_outlined,
              message: state.errorMessage,
              actionLabel: AppStrings.retry,
              onAction: context.read<CartCubit>().getCart,
            );
          }

          if (state is CartEmpty) {
            return const HomeMessage(
              icon: Icons.shopping_cart_outlined,
              message: AppStrings.yourCartIsEmpty,
            );
          }

          if (state is CartSuccess) {
            return CartContent(products: state.products);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
