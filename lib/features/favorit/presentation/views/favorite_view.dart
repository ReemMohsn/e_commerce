import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commeric/features/cart/presentation/cubit/cart_state.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_state.dart';
import 'package:e_commeric/features/favorit/presentation/views/widgets/favorite_content.dart';
import 'package:e_commeric/features/home/presentation/view_model/main_home_cubit.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_message.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/profile_avatar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreWhenNeeded);
  }

  void _loadMoreWhenNeeded() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter <= 220) {
      context.read<FavoriteCubit>().loadMoreFavorite();
    }
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, AppRoute.profile);
    if (mounted) {
      context.read<ProfileCubit>().getCurrentUser();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreWhenNeeded)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavoriteCubit, FavoriteState>(
          listener: (context, state) {
            if (context.read<MainHomeCubit>().state != 2) return;

            if (state is DeleteFavoriteLoading) {
              context.showLoadingDialog();
            } else if (state is DeleteFavoriteSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar(state.message);
              context.read<FavoriteCubit>().getFavorite();
            } else if (state is DeleteFavoriteFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
              context.read<FavoriteCubit>().getFavorite();
            }
          },
        ),
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is AddCartLoading) {
              context.showLoadingDialog();
            } else if (state is AddCartSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showSuccessSnackBar(state.message);
            } else if (state is AddCartFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              context.showErrorSnackBar(state.errorMessage);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          centerTitle: true,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: IconButton.outlined(
              tooltip: 'Back to home',
              onPressed: () => context.read<MainHomeCubit>().changeIndex(0),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
          title: Text(
            'Favorites',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final image = state is ProfileSuccess
                      ? state.user.image
                      : null;
                  return ProfileAvatarButton(
                    imageUrl: image,
                    onPressed: _openProfile,
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          buildWhen: (_, current) =>
              current is FavoriteInitial ||
              current is FavoriteLoading ||
              current is FavoriteEmpty ||
              current is FavoriteSuccess ||
              current is FavoriteFailure,
          builder: (context, state) {
            if (state is FavoriteFailure) {
              return HomeMessage(
                icon: Icons.cloud_off_outlined,
                message: state.errorMessage,
                actionLabel: 'Retry',
                onAction: context.read<FavoriteCubit>().getFavorite,
              );
            }

            if (state is FavoriteEmpty) {
              return const HomeMessage(
                icon: Icons.favorite_border_rounded,
                message: 'Your favorites list is empty.',
              );
            }

            if (state is FavoriteSuccess) {
              return FavoriteContent(
                state: state,
                scrollController: _scrollController,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
