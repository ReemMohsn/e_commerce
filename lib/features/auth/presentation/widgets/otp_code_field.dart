import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeField extends StatefulWidget {
  const OtpCodeField({super.key, required this.onChanged, this.length = 4});

  final ValueChanged<String> onChanged;
  final int length;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged(_controllers.map((controller) => controller.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 67,
          height: 67,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textInputAction: index == widget.length - 1
                ? TextInputAction.done
                : TextInputAction.next,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) => _onDigitChanged(index, value),
            style: const TextStyle(
              fontSize: 30,
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: AppColor.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '—',
              hintStyle: const TextStyle(color: AppColor.divider, fontSize: 24),
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColor.inputBorder,
                  width: 1.6,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColor.primary,
                  width: 1.8,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
