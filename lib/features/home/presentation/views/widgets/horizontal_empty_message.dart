import 'package:flutter/material.dart';

class HorizontalEmptyMessage extends StatelessWidget {
  const HorizontalEmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
