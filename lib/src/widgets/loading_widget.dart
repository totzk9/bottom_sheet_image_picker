import 'package:flutter/material.dart';

import '../../bottom_sheet_image_picker.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    required this.decoration,
    super.key,
  });

  final PickerDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (decoration.loadingWidget != null)
          ? decoration.loadingWidget
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
