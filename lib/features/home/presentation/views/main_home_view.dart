import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/services/app_services.dart';
import 'package:e_commeric/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:e_commeric/features/cart/presentation/views/cart_view.dart';
import 'package:e_commeric/features/favorit/presentation/view_model/favorite_cubit.dart';
import 'package:e_commeric/features/favorit/presentation/views/favorite_view.dart';
import 'package:e_commeric/features/favorit/presentation/views/widgets/favorite_action_listener.dart';
import 'package:e_commeric/features/home/data/models/navigation_item_model.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_cubit.dart';
import 'package:e_commeric/features/home/presentation/view_model/main_home_cubit.dart';
import 'package:e_commeric/features/home/presentation/views/home_view.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  static final List<NavigationItemModel> _items = [
    NavigationItemModel(
      label: AppStrings.home,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      page: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => HomeCubit(AppServices.homeRepository)
              ..fetchCategories()
              ..fetchProducts()
              ..fetchBrands(),
          ),
          BlocProvider(
            create: (_) =>
                ProfileCubit(AppServices.profileRepository)..getCurrentUser(),
          ),
          BlocProvider(create: (_) => CartCubit(AppServices.cartRepository)),
        ],
        child: const HomeView(),
      ),
    ),
    NavigationItemModel(
      label: AppStrings.cart,
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart_rounded,
      page: BlocProvider(
        create: (_) =>
            ProfileCubit(AppServices.profileRepository)..getCurrentUser(),
        child: const CartView(),
      ),
    ),
    NavigationItemModel(
      label: AppStrings.favorites,
      icon: Icons.favorite_border_rounded,
      selectedIcon: Icons.favorite_rounded,
      page: BlocProvider(
        create: (_) =>
            ProfileCubit(AppServices.profileRepository)..getCurrentUser(),
        child: const FavoriteView(),
      ),
    ),
    NavigationItemModel(
      label: AppStrings.menu,
      icon: Icons.menu_rounded,
      selectedIcon: Icons.menu_open_rounded,
      page: Placeholder(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainHomeCubit, int>(
      builder: (context, currentIndex) {
        return FavoriteActionListener(
          enabled: currentIndex != 2,
          child: Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: _items.map((item) => item.page).toList(growable: false),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                if (index == 1) {
                  context.read<CartCubit>().getCart();
                } else if (index == 2) {
                  context.read<FavoriteCubit>().getFavorite();
                }
                context.read<MainHomeCubit>().changeIndex(index);
              },
              destinations: _items
                  .map(
                    (item) => NavigationDestination(
                      label: item.label,
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
