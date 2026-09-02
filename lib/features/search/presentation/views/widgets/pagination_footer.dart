import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_cubit.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationFooter extends StatelessWidget {
  const PaginationFooter({required this.state});

  final SearchSuccess state;

  @override
  Widget build(BuildContext context) {
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
              onPressed: context.read<SearchCubit>().retryPagination,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
