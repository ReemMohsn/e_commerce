import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_collection_card.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_section_header.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/horizontal_empty_message.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/horizontal_section_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categoriesStatus != current.categoriesStatus ||
          previous.categories != current.categories ||
          previous.categoriesErrorMessage != current.categoriesErrorMessage,
      builder: (context, state) {
        late final Widget content;

        switch (state.categoriesStatus) {
          case HomeRequestStatus.initial:
          case HomeRequestStatus.loading:
            content = const Center(child: CircularProgressIndicator());
          case HomeRequestStatus.failure:
            content = HorizontalSectionError(
              message:
                  state.categoriesErrorMessage ?? 'Unable to load categories.',
              onRetry: context.read<HomeCubit>().fetchCategories,
            );
          case HomeRequestStatus.success:
            content = state.categories.isEmpty
                ? const HorizontalEmptyMessage(message: 'No categories found')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return HomeCollectionCard(
                        title: category.name,
                        imageUrl: category.image,
                        fallbackIcon: Icons.category_outlined,
                      );
                    },
                  );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: HomeSectionHeader(title: 'Categories'),
            ),
            SizedBox(height: 132, child: content),
          ],
        );
      },
    );
  }
}
