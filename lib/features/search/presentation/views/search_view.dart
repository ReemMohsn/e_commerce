import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/core/services/app_services.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/home_message.dart';
import 'package:e_commeric/features/home/presentation/views/widgets/product_item_card.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_cubit.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_state.dart';
import 'package:e_commeric/features/search/presentation/views/widgets/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
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
      context.read<SearchCubit>().loadMoreProducts();
    }
  }

  void _onSearchChanged(String value) {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
    context.read<SearchCubit>().onSearchChanged(value);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
        leadingWidth: 76,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                final image = snapshot.data?['image'] as String?;
                return CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColor.secondary,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColor.surfaceSoft,
                    child: ClipOval(
                      child: SizedBox.expand(
                        child: image == null || image.trim().isEmpty
                            ? const Icon(
                                Icons.person_outline_rounded,
                                color: AppColor.primary,
                              )
                            : AppNetworkImage(
                                imageUrl: image,
                                fallbackIcon: Icons.person_outline_rounded,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onSubmitted: context.read<SearchCubit>().submitSearch,
              decoration: const InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: Icon(Icons.search_rounded, size: 27),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const HomeMessage(
                    icon: Icons.search_rounded,
                    message: 'Type a product name to start searching.',
                  );
                }

                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchEmpty) {
                  return HomeMessage(
                    icon: Icons.search_off_rounded,
                    message: 'No products found matching "${state.query}".',
                  );
                }

                if (state is SearchFailure) {
                  return HomeMessage(
                    icon: Icons.cloud_off_outlined,
                    message: state.errorMessage,
                    actionLabel: 'Retry',
                    onAction: context.read<SearchCubit>().retrySearch,
                  );
                }

                return _buildSearchResults(state as SearchSuccess);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchSuccess state) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Search Results',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColor.textPrimary),
            ),
          ),
        ),
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = state.products[index];
                  return ProductItemCard(
                    product: product,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoute.productDetails,
                      arguments: product.id,
                    ),
                  );
                }, childCount: state.products.length),
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: PaginationFooter(state: state)),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
