import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/brands_section.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/categories_section.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_filter_sheet.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_header.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_section_header.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/pagination_footer.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/products_section.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/search_widget.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreWhenNeeded);
  }

  void _loadMoreWhenNeeded() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter <= 220) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  void _showFilters() {
    final homeCubit = context.read<HomeCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColor.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) =>
          BlocProvider.value(value: homeCubit, child: const HomeFilterSheet()),
    );
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 14,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return HomeHeader(
                userName: state.user.name,
                userImage: state.user.image,
              );
            }

            return const HomeHeader();
          },
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) =>
                    previous.productsStatus != current.productsStatus ||
                    previous.categories != current.categories ||
                    previous.brands != current.brands ||
                    previous.selectedCategorySlug !=
                        current.selectedCategorySlug ||
                    previous.selectedBrandName != current.selectedBrandName,
                builder: (context, state) {
                  final canFilter =
                      state.productsStatus == HomeRequestStatus.success &&
                      (state.categories.isNotEmpty || state.brands.isNotEmpty);

                  return SearchWidget(
                    onSearchTap: () =>
                        Navigator.pushNamed(context, AppRoute.search),
                    onFilterTap: canFilter ? _showFilters : null,
                    isFilterActive: state.hasActiveFilters,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: CategoriesSection()),
          const SliverToBoxAdapter(child: BrandsSection()),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
            sliver: SliverToBoxAdapter(
              child: HomeSectionHeader(title: 'Products'),
            ),
          ),
          const ProductsSection(),
          const SliverToBoxAdapter(child: PaginationFooter()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
