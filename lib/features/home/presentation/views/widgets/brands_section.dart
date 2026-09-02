import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_collection_card.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_section_header.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/horizontal_empty_message.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/horizontal_section_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.brandsStatus != current.brandsStatus ||
          previous.brands != current.brands ||
          previous.brandsErrorMessage != current.brandsErrorMessage,
      builder: (context, state) {
        late final Widget content;

        switch (state.brandsStatus) {
          case HomeRequestStatus.initial:
          case HomeRequestStatus.loading:
            content = const Center(child: CircularProgressIndicator());
          case HomeRequestStatus.failure:
            content = HorizontalSectionError(
              message: state.brandsErrorMessage ?? 'Unable to load brands.',
              onRetry: context.read<HomeCubit>().fetchBrands,
            );
          case HomeRequestStatus.success:
            content = state.brands.isEmpty
                ? const HorizontalEmptyMessage(message: 'No brands found')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.brands.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final brand = state.brands[index];
                      return HomeCollectionCard(
                        title: brand.name,
                        imageUrl: null,
                        emoji: brand.emoji,
                        fallbackIcon: Icons.storefront_outlined,
                      );
                    },
                  );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: HomeSectionHeader(title: 'Brands'),
            ),
            SizedBox(height: 132, child: content),
          ],
        );
      },
    );
  }
}
