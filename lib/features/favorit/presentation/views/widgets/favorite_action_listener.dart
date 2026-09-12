import 'package:e_commeric/core/extensions/snack_bar_context_extension.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/cubit/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteActionListener extends StatelessWidget {
  const FavoriteActionListener({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (!enabled) return;

        if (state is AddFavoriteSuccess) {
          context.showSuccessSnackBar(state.message);
        } else if (state is AddFavoriteFailure) {
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is DeleteFavoriteSuccess) {
          context.showSuccessSnackBar(state.message);
        } else if (state is DeleteFavoriteFailure) {
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      child: child,
    );
  }
}
