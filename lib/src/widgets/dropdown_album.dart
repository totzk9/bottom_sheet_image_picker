import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DropdownAlbum extends StatelessWidget {
  const DropdownAlbum({
    required this.onSelect,
    required this.albums,
    required this.selectedAlbum,
    super.key,
  });

  final ValueChanged<AssetPathEntity> onSelect;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AssetPathEntity>(
      underline: const SizedBox.shrink(),
      value: selectedAlbum,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: albums.map((AssetPathEntity album) {
        return DropdownMenuItem(
          value: album,
          child: Text(album.name),
        );
      }).toList(),
      onChanged: (AssetPathEntity? newValue) {
        if (newValue == null) {
          return;
        }
        onSelect(newValue);
      },
    );
  }
}
