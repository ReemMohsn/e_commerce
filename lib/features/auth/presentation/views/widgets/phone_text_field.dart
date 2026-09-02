import 'package:e_commeric/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.labelText = 'Phone Number',
    this.validator,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      labelText: labelText,
      hintText: '+20 1501142409',
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      validator: validator,
      autofillHints: const [AutofillHints.telephoneNumber],
      prefixIcon: const SizedBox(
        width: 58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android_rounded, size: 18),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down_rounded, size: 19),
          ],
        ),
      ),
    );
  }
}
