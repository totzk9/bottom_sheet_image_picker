import 'dart:io';

import 'package:bottom_sheet_image_picker/bottom_sheet_image_picker.dart';
import 'package:bottom_sheet_image_picker/src/media_controller.dart';
import 'package:bottom_sheet_image_picker/src/widgets/dropdown_album.dart';
import 'package:bottom_sheet_image_picker/src/widgets/select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class Header extends StatefulWidget {
  const Header({
    required this.onSelect,
    required this.albums,
    required this.selectedAlbum,
    required this.onDone,
    required this.mediaController,
    this.mediaCount,
    this.decoration,
  });

  final ValueChanged<AssetPathEntity> onSelect;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;
  final ValueChanged<List<Media>> onDone;
  final MediaCount? mediaCount;
  final PickerDecoration? decoration;
  final MediaController mediaController;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  List<Media> selectedMedia = [];

  @override
  void initState() {
    widget.mediaController.onUpdateSelection = (selectedMediaList) {
      if (widget.mediaCount == MediaCount.multiple) {
        setState(() => selectedMedia = selectedMediaList.cast<Media>());
      } else if (selectedMediaList.length == 1) {
        widget.onDone(selectedMediaList);
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        widget.decoration?.cancelIcon ??
            (Platform.isAndroid == true
                ? const BackButton()
                : CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(CupertinoIcons.back),
                  )),
        const SizedBox(width: 4),
        AnimatedSwitcher(
          duration: Duration.zero,
          child: selectedMedia.isNotEmpty
              ? Text(
                  '${selectedMedia.length} items selected',
                  textAlign: TextAlign.start,
                  style: widget.decoration?.albumTitleStyle ??
                      textTheme.titleLarge,
                )
              : DropdownAlbum(
                  onSelect: widget.onSelect,
                  albums: widget.albums,
                  selectedAlbum: widget.selectedAlbum,
                ),
        ),
        const Spacer(),
        if (widget.mediaCount == MediaCount.multiple)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: selectedMedia.isNotEmpty
                ? SelectButton(
                    onPressed: () => widget.onDone(selectedMedia),
                  )
                : const SizedBox.shrink(),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
