import 'package:e_commeric/core/routing/app_route.dart';
import 'package:e_commeric/features/auth/presentation/views/widgets/auth_back_button.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commeric/features/profile/presentation/cubit/profile_state.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/cart_button.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  Future<void> _openEditProfile() async {
    final state = context.read<ProfileCubit>().state;
    if (state is! ProfileSuccess) return;

    await Navigator.of(
      context,
    ).pushNamed(AppRoute.editProfile, arguments: state.user);

    if (!mounted) return;
    context.read<ProfileCubit>().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        leadingWidth: 76,
        leading: const Padding(
          padding: EdgeInsets.only(left: 14, top: 12, bottom: 12),
          child: AuthBackButton(),
        ),
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: CartButton(itemCount: 0),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 24,
          ),
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (BuildContext context, ProfileState state) {
                  if (state is ProfileLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ProfileEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.person_off_outlined, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No profile data available.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProfileFailure) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline_rounded, size: 48),
                          const SizedBox(height: 12),
                          Text(state.errorMessage, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                context.read<ProfileCubit>().getCurrentUser(),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProfileSuccess) {
                    return ProfileHeader(
                      name: state.user.name,
                      handle: state.user.email,
                      imageUrl: state.user.image,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: _openEditProfile,
                    ),
                    const ProfileMenuTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Subscription & Payment',
                    ),
                    ProfileToggleTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'App Notifications',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                    ),
                    ProfileToggleTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() => _darkModeEnabled = value);
                      },
                    ),
                    const ProfileMenuTile(
                      icon: Icons.star_border_rounded,
                      title: 'Rate Us',
                    ),
                    const ProfileMenuTile(
                      icon: Icons.record_voice_over_outlined,
                      title: 'Provide Feedback',
                    ),
                    const ProfileMenuTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      isDestructive: true,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
