import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName,
    this.userImage,
    this.onNotificationsTap,
  });

  final String? userName;
  final String? userImage;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final name = userName?.trim();
    final displayName = name == null || name.isEmpty ? 'there' : name;
    final initial = displayName == 'there'
        ? 'M'
        : displayName.substring(0, 1).toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: AppColor.secondary,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.surfaceSoft,
            child: ClipOval(
              child: SizedBox.expand(
                child: userImage == null || userImage!.trim().isEmpty
                    ? Center(
                        child: Text(
                          initial,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      )
                    : AppNetworkImage(
                        imageUrl: userImage,
                        fallbackIcon: Icons.person_outline_rounded,
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Hi $displayName!',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColor.textPrimary,
              fontSize: 19,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
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
