import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({
    super.key,
    this.imageUrl,
    this.fallbackText,
    required this.onPressed,
  });

  final String? imageUrl;
  final String? fallbackText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl?.trim();
    final text = fallbackText?.trim();

    return Tooltip(
      message: AppStrings.profile,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: CircleAvatar(
            radius: 23,
            backgroundColor: AppColor.secondary,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.surfaceSoft,
              child: ClipOval(
                child: SizedBox.expand(
                  child: image == null || image.isEmpty
                      ? text == null || text.isEmpty
                            ? const Icon(
                                Icons.person_outline_rounded,
                                color: AppColor.primary,
                              )
                            : Center(
                                child: Text(
                                  text.substring(0, 1).toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              )
                      : AppNetworkImage(
                          imageUrl: image,
                          fallbackIcon: Icons.person_outline_rounded,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
