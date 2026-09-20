import 'dart:math' as math;
import 'package:e_commeric/core/extensions/screen_context_extension.dart';
import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpCodeField extends StatelessWidget {
  const OtpCodeField({super.key, required this.onChanged, this.length = 4})
    : assert(length > 0);

  final ValueChanged<String> onChanged;
  final int length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final cellSize = math.min(
          context.responsiveWidth(67),
          math.max(0.0, (availableWidth - (length - 1) * 8) / length),
        );
        final defaultPinTheme = PinTheme(
          width: cellSize,
          height: cellSize,
          textStyle: const TextStyle(
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: AppColor.textPrimary,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.inputBorder, width: 1.6),
          ),
        );

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Pinput(
            length: length,
            separatorBuilder: (_) => const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.primary, width: 1.8),
              ),
            ),
            preFilledWidget: const Text(
              AppStrings.otpPlaceholder,
              style: TextStyle(color: AppColor.divider, fontSize: 24),
            ),
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}
