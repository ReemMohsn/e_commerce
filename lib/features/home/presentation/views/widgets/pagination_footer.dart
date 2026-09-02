import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationFooter extends StatelessWidget {
  const PaginationFooter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.productsStatus != current.productsStatus ||
          previous.isLoadingMore != current.isLoadingMore ||
          previous.paginationErrorMessage != current.paginationErrorMessage,
      builder: (context, state) {
        if (state.productsStatus != HomeRequestStatus.success) {
          return const SizedBox.shrink();
        }

        if (state.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.all(22),
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        }

        final error = state.paginationErrorMessage;
        if (error != null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 4),
            child: Column(
              children: [
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColor.danger),
                ),
                TextButton(
                  onPressed: context.read<HomeCubit>().retryPagination,
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
