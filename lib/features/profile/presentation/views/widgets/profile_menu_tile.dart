import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColor.danger : AppColor.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  Icon(icon, size: 24, color: color),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: color),
                    ),
                  ),
                  const _CircularChevron(),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}

class ProfileToggleTile extends StatelessWidget {
  const ProfileToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onChanged(!value),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                const SizedBox(width: 1),
                Icon(icon, size: 24, color: AppColor.textPrimary),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Transform.scale(
                  scale: .86,
                  alignment: Alignment.centerRight,
                  child: Switch(value: value, onChanged: onChanged),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}

class _CircularChevron extends StatelessWidget {
  const _CircularChevron();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23,
      height: 23,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.background,
        border: Border.fromBorderSide(BorderSide(color: AppColor.outlineSoft)),
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 12,
        color: AppColor.textSecondary,
      ),
    );
  }
}
