import 'dart:math' as math;

import 'package:e_commeric/core/common/widgets/app_network_image.dart';
import 'package:e_commeric/core/extensions/screen_context_extension.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.handle,
    this.imageUrl,
    this.onImagePressed,
  });

  final String name;
  final String handle;
  final String? imageUrl;
  final VoidCallback? onImagePressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final scale = context.responsiveWidth(1);

    return SizedBox(
      height: 268 * scale,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Positioned.fill(child: CustomPaint(painter: _OrbitPainter())),
          Positioned(
            top: 49 * scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 123 * scale,
                  height: 123 * scale,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.background,
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColor.primary, width: 2),
                    ),
                  ),
                  child: ClipOval(
                    child: AppNetworkImage(
                      imageUrl: imageUrl,
                      fallbackIcon: Icons.person_rounded,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: 5,
                  child: Material(
                    color: AppColor.background,
                    shape: const CircleBorder(
                      side: BorderSide(color: AppColor.outlineSoft),
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onImagePressed,
                      child: const SizedBox.square(
                        dimension: 27,
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          size: 17,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 184 * scale,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / 268;
    final center = Offset(size.width / 2, 133 * scale);
    final orbitWidth = math.min(size.width - 42, 315.0 * scale);
    final orbitPaint = Paint()
      ..color = AppColor.outlineSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: orbitWidth, height: 216 * scale),
      orbitPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, -1),
        width: orbitWidth - 14,
        height: 226 * scale,
      ),
      orbitPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, -2),
        width: orbitWidth - 28,
        height: 236 * scale,
      ),
      orbitPaint,
    );

    final dotPaint = Paint()
      ..color = AppColor.outlineSoft
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * .18, 86 * scale), 8, dotPaint);
    canvas.drawCircle(Offset(size.width * .83, 87 * scale), 10, dotPaint);
    canvas.drawCircle(Offset(size.width * .15, 199 * scale), 10, dotPaint);
    canvas.drawCircle(Offset(size.width * .78, 205 * scale), 11, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
