import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:e_commeric/features/profile/presentation/views/widgets/profile_avatar_button.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName,
    this.userImage,
    required this.onProfileTap,
    this.onNotificationsTap,
  });

  final String? userName;
  final String? userImage;
  final VoidCallback onProfileTap;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final name = userName?.trim();
    final displayName = name == null || name.isEmpty ? AppStrings.there : name;
    final initial = displayName == AppStrings.there
        ? AppStrings.defaultAvatarLetter
        : displayName.substring(0, 1).toUpperCase();

    return Row(
      children: [
        ProfileAvatarButton(
          imageUrl: userImage,
          fallbackText: initial,
          onPressed: onProfileTap,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            AppStrings.greeting(displayName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColor.textPrimary,
              fontSize: 19,
            ),
          ),
        ),
        IconButton(
          tooltip: AppStrings.notifications,
          onPressed: onNotificationsTap ?? () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColor.primary,
            size: 29,
          ),
        ),
      ],
    );
  }
}
