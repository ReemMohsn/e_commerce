import 'package:e_commeric/core/services/app_services.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:e_commeric/features/home/presentation/widgets/home_collection_card.dart';
import 'package:e_commeric/features/home/presentation/widgets/home_filter_sheet.dart';
import 'package:e_commeric/features/home/presentation/widgets/home_header.dart';
import 'package:e_commeric/features/home/presentation/widgets/home_message.dart';
import 'package:e_commeric/features/home/presentation/widgets/home_section_header.dart';
import 'package:e_commeric/features/home/presentation/widgets/horizontal_empty_message.dart';
import 'package:e_commeric/features/home/presentation/widgets/product_item_card.dart';
import 'package:e_commeric/features/home/presentation/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  late final Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = AppServices.preferences.profile;
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
      builder: (_) => BlocProvider.value(
        value: homeCubit,
        child: const HomeFilterSheet(),
      ),
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
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            return HomeHeader(
              userName: snapshot.data?['name'] as String?,
              userImage: snapshot.data?['image'] as String?,
            );
          },
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
                sliver: SliverToBoxAdapter(
                  child: SearchWidget(
                    onSearchTap: () =>
                        Navigator.pushNamed(context, AppRoute.search),
                    onFilterTap: state is HomeSuccess ? _showFilters : null,
                    isFilterActive:
                        state is HomeSuccess && state.hasActiveFilters,
                  ),
                ),
              ),
              if (state is HomeInitial || state is HomeLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is HomeFailure)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: HomeMessage(
                    icon: Icons.cloud_off_outlined,
                    message: state.errorMessage,
                    actionLabel: 'Retry',
                    onAction: context.read<HomeCubit>().fetchHomeData,
                  ),
                )
              else if (state is HomeSuccess)
                ..._buildHomeSlivers(context, state),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildHomeSlivers(BuildContext context, HomeSuccess state) {
    final visibleProducts = state.filteredProducts;

    return [
      const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        sliver: SliverToBoxAdapter(
          child: HomeSectionHeader(title: 'Categories'),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 132,
          child: state.categories.isEmpty
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
                ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
        sliver: SliverToBoxAdapter(child: HomeSectionHeader(title: 'Brands')),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 132,
          child: state.brands.isEmpty
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
                ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
        sliver: SliverToBoxAdapter(child: HomeSectionHeader(title: 'Products')),
      ),
      if (visibleProducts.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: state.hasActiveFilters
                ? HomeMessage(
                    icon: Icons.filter_alt_off_outlined,
                    message: 'No products found for the selected filters.',
                    actionLabel: 'Clear Filters',
                    onAction: context.read<HomeCubit>().clearFilters,
                  )
                : const HomeMessage(
                    icon: Icons.inventory_2_outlined,
                    message: 'No products are available right now.',
                  ),
            ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final columns = width >= 900
                  ? 4
                  : width >= 600
                  ? 3
                  : 2;

              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 264,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ProductItemCard(product: visibleProducts[index]),
                  childCount: visibleProducts.length,
                ),
              );
            },
          ),
        ),
      SliverToBoxAdapter(child: _PaginationFooter(state: state)),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.state});

  final HomeSuccess state;

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
              onPressed: context.read<HomeCubit>().retryPagination,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
