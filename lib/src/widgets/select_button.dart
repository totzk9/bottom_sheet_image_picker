import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    required this.onPressed,
    this.done,
    super.key,
  });

  final Widget? done;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Widget child = done ??
        Text(
          'SELECT',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        );

    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return TextButton(
      onPressed: () => onPressed,
      child: child,
    );
  }
}
