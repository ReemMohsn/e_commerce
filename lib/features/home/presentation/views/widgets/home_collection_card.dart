import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class HomeCollectionCard extends StatelessWidget {
  const HomeCollectionCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.fallbackIcon,
    this.emoji,
  });

  final String title;
  final String? imageUrl;
  final IconData fallbackIcon;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: imageUrl != null
                    ? AppNetworkImage(
                        imageUrl: imageUrl,
                        fallbackIcon: fallbackIcon,
                        fit: BoxFit.contain,
                      )
                    : ColoredBox(
                        color: AppColor.surfaceSoft,
                        child: Center(
                          child: emoji == null
                              ? Icon(
                                  fallbackIcon,
                                  size: 38,
                                  color: AppColor.hint,
                                )
                              : Text(
                                  emoji!,
                                  style: const TextStyle(fontSize: 42),
                                ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title.isEmpty ? 'Unnamed' : title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
