import 'package:e_commeric/core/constants/api_link.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String? imageUrl;
  final BoxFit fit;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveUrl(imageUrl);
    if (resolvedUrl == null) return _ImageFallback(icon: fallbackIcon);

    return ColoredBox(
      color: AppColor.surfaceSoft,
      child: Image.network(
        resolvedUrl,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, _, _) => _ImageFallback(icon: fallbackIcon),
      ),
    );
  }

  String? _resolveUrl(String? value) {
    final path = value?.trim();
    if (path == null || path.isEmpty) return null;

    final uri = Uri.tryParse(path);
    if (uri?.hasScheme == true) return path;
    if (path.startsWith('//')) return 'https:$path';

    return Uri.parse(ApiLink.serverUrl).resolve(path).toString();
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surfaceSoft,
      child: Center(
        child: Icon(icon, size: 38, color: AppColor.hint),
      ),
    );
  }
}
